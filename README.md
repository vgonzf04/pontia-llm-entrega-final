# Asistente turístico inteligente de Tenerife

Proyecto final del módulo **Large Language Models**.

## 1. Descripción

Este proyecto implementa un asistente conversacional en español para ayudar a organizar visitas a **Tenerife**. Utiliza **Google Gemini** mediante su API y combina información de una guía turística en PDF con predicciones meteorológicas de **Open-Meteo**.

El prototipo se desarrolla en un **Jupyter Notebook** e incorpora recuperación aumentada por generación (**RAG**), conversación multiturno, llamadas manuales a herramientas (*function calling*), respuesta en *streaming* y un registro de las ejecuciones de herramientas.

## 2. Funcionalidades

- **Consultas turísticas basadas en documentos:** recupera fragmentos de la guía de Tenerife y aporta referencias a las páginas empleadas.
- **Predicción meteorológica:** consulta temperatura máxima y mínima, precipitación y una descripción del tiempo para una fecha concreta en **Santa Cruz de Tenerife**.
- **Preguntas combinadas:** puede utilizar ambas herramientas para proponer actividades en función de la previsión meteorológica.
- **Diálogo multiturno:** conserva el historial de preguntas y respuestas y, cuando supera el umbral configurado, genera un resumen del contexto anterior.
- **Function calling manual:** Gemini selecciona las herramientas mediante declaraciones JSON Schema; Python ejecuta las llamadas y devuelve los resultados al modelo.
- **Streaming:** muestra progresivamente la respuesta del modelo en el notebook.
- **Registro de llamadas:** almacena nombre de herramienta, argumentos, resultado, estado y error en `tool_logs`.

## 3. Tecnologías y dependencias

| Componente | Tecnología |
| --- | --- |
| Lenguaje y entorno | Python, Jupyter Notebook |
| Modelo generativo | Google Gemini mediante `google-genai` |
| Modelo de embeddings | `gemini-embedding-001` |
| Lectura del documento PDF | PyMuPDF (`pymupdf`) |
| Fragmentación del texto | `langchain-text-splitters` |
| Índice vectorial y recuperación | FAISS (`faiss-cpu`), NumPy |
| Meteorología | Open-Meteo y `requests` |
| Configuración | `python-dotenv` |
| Evaluación y gráficos | pandas, Matplotlib |

El modelo de generación se configura con la variable `GOOGLE_GENERATION_MODEL`. El notebook establece `gemini-3.5-flash-lite` como valor predeterminado; si no está disponible para la clave utilizada, hay que establecer un identificador de modelo válido. El modelo de embeddings se configura con `GOOGLE_EMBEDDING_MODEL` y utiliza `gemini-embedding-001` por defecto.

## 4. Estructura del proyecto

Estructura esperada del repositorio (ajustar los nombres si cambian):

```text
proyecto/
├── asistente_llm.ipynb
├── data/
│   └── TENERIFE.pdf
├── README.md
├── pyproject.toml        # también disponible requirements.txt
├── .env.example
└── .gitignore
```

**Importante:** el notebook busca el archivo en `data/TENERIFE.pdf`, por lo que debe encontrarse exactamente en esa ruta al ejecutarlo desde la raíz del proyecto.

## 5. Instalación y configuración

### 5.1. Requisitos

- Python 3.11 (entorno utilizado en el desarrollo) y Jupyter Notebook.
- Clave de API de Google Gemini con acceso a modelos de generación y embeddings.
- Conexión a Internet para generar embeddings, consultar Gemini y obtener predicciones de Open-Meteo.
- Guía turística `data/TENERIFE.pdf`.

### 5.2. Crear el entorno e instalar dependencias

El proyecto utiliza **uv** para gestionar las dependencias y el entorno virtual y dispone de un **Makefile** que automatiza la configuración de Jupyter.

#### Requisitos previos

- **uv**, gestor de entornos y dependencias de Python.
- **Make**, disponible habitualmente en macOS y Linux.
- **Git**, para clonar el repositorio.
- **`pyproject.toml`**, con las dependencias del proyecto declaradas.

No es necesario crear manualmente un entorno virtual: `uv` sincroniza el entorno con **Python 3.11** y puede instalar esa versión de Python si es necesario.

#### Preparación del entorno

Desde la carpeta raíz del repositorio, ejecutar:

```bash
make setup
```

El objetivo `setup` del Makefile realiza cuatro operaciones:

1. Ejecuta `uv sync --python 3.11` para crear o sincronizar `.venv` con las dependencias de `pyproject.toml`.
2. Instala **JupyterLab** e **ipykernel** en `.venv`.
3. Registra un kernel de Jupyter denominado `pontia-llm-entrega-final`.
4. Exporta un archivo `requirements.txt` a partir de las dependencias declaradas.

Una vez finalizado el comando, el entorno estará preparado para ejecutar el notebook.

#### Iniciar JupyterLab

```bash
make notebook
```

Este comando ejecuta `uv run --no-sync jupyter lab`. En JupyterLab, abrir `asistente_llm.ipynb`, seleccionar el kernel **`pontia-llm-entrega-final`** y ejecutar las celdas de forma ordenada. Asegurarse previamente de configurar la API key y colocar la guía turística en la ruta indicada.

#### Eliminar el entorno

```bash
make clean
```

El comando elimina el kernel registrado y la carpeta `.venv`. No elimina el código fuente ni el archivo `requirements.txt`.

#### Resumen de comandos

| Comando | Función |
| --- | --- |
| `make setup` | Prepara Python 3.11, sincroniza las dependencias, instala Jupyter y registra el kernel. |
| `make notebook` | Inicia JupyterLab desde el entorno del proyecto. |
| `make clean` | Elimina el entorno virtual y el kernel del proyecto. |

**Nota:** no es necesario activar manualmente `.venv` para utilizar estos comandos. El Makefile utiliza rutas relativas al entorno; está preparado principalmente para macOS y Linux, o una terminal compatible con sus comandos.


### Instalación y ejecución en Windows

En Windows, si no se dispone de `make`, el entorno puede configurarse manualmente siguiendo estos pasos.

#### 1. Requisitos previos

Es necesario disponer de:

- Python 3.11.
- PowerShell.

#### 2. Crear el entorno virtual e instalar dependencias

Existen dos alternativas dependiendo del archivo de dependencias disponible.

##### Opción A: utilizando `pyproject.toml` con uv (recomendada)

Primero, instalar `uv` si no se dispone de él:

```powershell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Después, desde el directorio del proyecto:

```powershell
uv sync --python 3.11
```

Este comando crea automáticamente el entorno virtual `.venv` e instala las dependencias declaradas en `pyproject.toml`. Si existe `uv.lock`, utiliza las versiones bloqueadas.

Si JupyterLab e ipykernel no están incluidos entre las dependencias, instalarlos:

```powershell
uv pip install jupyterlab ipykernel
```

##### Opción B: utilizando `requirements.txt` con pip

Crear el entorno virtual:

```powershell
py -3.11 -m venv .venv
```

Activarlo desde PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Instalar las dependencias del proyecto:

```powershell
python -m pip install -r requirements.txt
```

Si JupyterLab e ipykernel no están incluidos en el archivo, instalarlos:

```powershell
python -m pip install jupyterlab ipykernel
```


#### 3. Registrar el kernel de Jupyter

Una vez instaladas las dependencias, registrar el entorno virtual para que Jupyter pueda utilizarlo.

Si se ha utilizado la opción A (`uv`):

```powershell
uv run python -m ipykernel install --user --name pontia-llm-entrega-final --display-name "Python (Asistente LLM)"
```

Si se ha utilizado la opción B (`pip`), con el entorno activado:

```powershell
python -m ipykernel install --user --name pontia-llm-entrega-final --display-name "Python (Asistente LLM)"
```

#### 4. Configurar la API de Gemini

Crear un archivo `.env` en la raíz del proyecto con la siguiente variable:

```env
GOOGLE_API_KEY=tu_clave_api_de_gemini
```

La clave API puede obtenerse desde [Google AI Studio](https://aistudio.google.com/apikey).

El archivo `.env` no debe subirse al repositorio y debe estar incluido en `.gitignore`.

#### 5. Iniciar JupyterLab

Si se ha utilizado `uv`:

```powershell
uv run jupyter lab
```

Si se ha utilizado `pip`, con el entorno virtual activado:

```powershell
jupyter lab
```

Se abrirá JupyterLab en el navegador, normalmente en:

http://localhost:8888/lab

#### 6. Abrir y ejecutar el notebook

Una vez iniciado JupyterLab:

1. Abrir el archivo `asistente_llm.ipynb`.
2. Seleccionar el kernel **Python (Asistente LLM)**.
3. Comprobar que el PDF de la guía turística está disponible en la ruta indicada en el notebook.

#### 7. Desactivar el entorno

Si se ha utilizado la opción B, el entorno virtual puede desactivarse desde PowerShell mediante:

```powershell
deactivate
```

En la opción A no es necesario desactivar el entorno, ya que `uv run` ejecuta los comandos directamente en el entorno del proyecto.

### 5.3. Configurar la API key

Crear un archivo `.env` en la raíz:

```env
GOOGLE_API_KEY=tu_clave_api
GOOGLE_GENERATION_MODEL=gemini-3.5-flash-lite
GOOGLE_EMBEDDING_MODEL=gemini-embedding-001
```

El notebook utiliza `load_dotenv()` y, si `GOOGLE_API_KEY` no está definida, solicita introducirla de forma interactiva mediante `getpass`. Revisar el identificador del modelo de generación según los modelos disponibles en la cuenta y sustituirlo en el `.env` si es necesario.


## 6. Arquitectura y funcionamiento

### 6.1. Construcción del RAG

1. Se abre `data/TENERIFE.pdf` con PyMuPDF y se extrae el texto página a página.
2. Se divide el texto mediante `RecursiveCharacterTextSplitter`, con **`chunk_size=700`** y **`chunk_overlap=100`**.
3. Cada fragmento conserva su identificador (`chunk_id`) y número de página.
4. Se generan embeddings de documentos con el tipo de tarea `RETRIEVAL_DOCUMENT`.
5. Se normalizan los vectores con `faiss.normalize_L2()` y se incorporan a un índice `faiss.IndexFlatIP`.
6. Las preguntas se representan con embeddings `RETRIEVAL_QUERY`, se normalizan y se comparan con los vectores almacenados.
7. La herramienta entrega al modelo los fragmentos más similares, sus puntuaciones y las páginas de origen.

La combinación de normalización L2 y producto interno permite ordenar fragmentos por **similitud coseno**. El índice se construye en memoria cuando se ejecutan las celdas; la versión revisada no implementa carga y guardado persistente del índice FAISS.

### 6.2. Herramientas disponibles

**`search_internal_docs_tool(query: str, k: int = 3)`** recupera los fragmentos turísticos más relevantes. La búsqueda devuelve el contenido y sus referencias (página, fragmento y puntuación).

**`get_weather_tool(date: str)`** consulta la API de Open-Meteo para Santa Cruz de Tenerife. La fecha se especifica como `YYYY-MM-DD`; el resultado contiene fecha, temperatura máxima y mínima, precipitación total y descripción meteorológica a partir del código recibido.

Ambas herramientas se exponen a Gemini mediante `types.FunctionDeclaration` con JSON Schema y `types.Tool`. La ejecución es **manual**: se detectan las solicitudes `function_call`, se ejecuta la función Python correspondiente y se añade el resultado como `function_response` al historial.

La herramienta meteorológica emplea el endpoint de **pronóstico**, por lo que no debe utilizarse para presentar datos históricos de fechas fuera del rango admitido. La API puede devolver errores o códigos meteorológicos no recogidos en el diccionario de descripciones del proyecto.

### 6.3. Gestión de la conversación

El historial se conserva como una lista de objetos `types.Content`. El sistema emplea `client.models.count_tokens()` y, cuando supera **`MAX_TOKENS=5000`**, resume el historial anterior para reducir su longitud. Las nuevas interacciones siguen usando el contexto resultante.

La generación se configura en el notebook con **`TEMPERATURE=0.3`** y **`MAX_OUTPUT_TOKENS=1000`**. Estos parámetros controlan la generación, mientras que `MAX_TOKENS` es el umbral de gestión del historial: son límites diferentes.

## 7. Ejecución y uso

1. Situarse en el directorio raíz del repositorio.
2. Activar el entorno virtual e iniciar Jupyter con `jupyter notebook`.
3. Abrir `asistente_llm.ipynb`.
4. Ejecutar las celdas en orden para cargar la guía, generar embeddings, crear el índice y definir las herramientas.
5. En la celda principal de conversación, introducir una pregunta y pulsar Intro.
6. Escribir `exit` o `salir` para finalizar la conversación interactiva.

**Ejemplos de consultas:**

```text
¿Qué lugares puedo visitar en el Parque Rural de Anaga?
¿Qué platos típicos puedo probar en Tenerife?
¿Qué tiempo hará en Tenerife el 20 de octubre de 2026?
¿Qué actividades turísticas de la guía me recomiendas para esa fecha teniendo en cuenta la previsión meteorológica?
```

Las preguntas con fechas son ejemplos y deben adaptarse a fechas incluidas en el horizonte de pronóstico en el momento de ejecutarlas.

El bucle interactivo utiliza `input()`; para ejecutar posteriormente las celdas de evaluación es necesario salir del bucle con `exit` o `salir`.

## 8. Evaluación

El notebook incluye dos apartados de evaluación:

### 8.1. Recuperación del RAG

Se utiliza un conjunto fijo de preguntas turísticas para registrar:

- `top_1_score`: similitud del fragmento mejor clasificado.
- `mean_score`: similitud media de los fragmentos recuperados.
- `pages` y `chunks`: páginas e identificadores recuperados.

Los resultados se muestran en un `DataFrame` y en un gráfico de barras. **Estas métricas describen similitud semántica, no son porcentajes de respuestas correctas**.

### 8.2. Selección de herramientas

Se dispone de un conjunto `EVAL_CASES` con preguntas de información turística, gastronomía, previsión meteorológica, consultas que requieren ambas herramientas y preguntas generales o saludos que no deberían necesitar herramientas.

La función `evaluate_tool_selection()` ejecuta cada pregunta con una conversación independiente, obtiene las herramientas observadas desde `tool_logs` y las compara con `expected_tools`. Se registra la coincidencia (`tool_selection_ok`), un extracto de la respuesta y posibles excepciones.

La coincidencia de herramientas **no garantiza** que la respuesta sea correcta ni que la consulta externa se haya completado con éxito; estas cuestiones deben revisarse por separado. Los resultados dependen de las respuestas efectivas de Gemini y de la disponibilidad de servicios externos. Este README no presupone una tasa de éxito determinada.

## 9. Limitaciones y posibles mejoras

**Limitaciones actuales:**

- La información turística recuperada depende exclusivamente del contenido y la calidad textual de `TENERIFE.pdf`.
- Un fragmento de alta similitud no garantiza una respuesta correcta ni que la guía contenga un dato concreto.
- Las previsiones dependen de Open-Meteo, de su disponibilidad y del intervalo de fechas que admite el endpoint de pronóstico.
- El tiempo se consulta para unas coordenadas fijas de Santa Cruz de Tenerife, no para cualquier municipio o zona de la isla.
- El índice vectorial y el historial de conversación se mantienen en memoria durante la sesión; no se persisten entre ejecuciones.
- El resumen del historial reduce consumo de contexto, pero puede omitir información relevante.
- La evaluación automática incluida mide principalmente similitud de recuperación y elección de herramientas; no verifica exhaustivamente la exactitud factual.

**Mejoras futuras:**

- Guardar y cargar el índice FAISS para evitar regenerar embeddings en cada ejecución.
- Incorporar evaluación de relevancia manual, citas y corrección factual con un conjunto de referencia.
- Añadir validaciones de fechas, mensajes de error más específicos y pruebas de fallos simulados de la API meteorológica.
- Permitir elegir localidades de Tenerife para consultas meteorológicas más precisas.
- Implementar una interfaz web con Streamlit o Gradio.
- Almacenar conversaciones entre sesiones y ampliar las fuentes turísticas.

