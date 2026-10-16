
VENV := .venv
PYTHON := $(VENV)/bin/python
KERNEL := pontia-llm-entrega-final

.PHONY: setup notebook clean

setup:
	uv sync --python 3.11
	uv pip install --python $(PYTHON) jupyterlab ipykernel
	$(PYTHON) -m ipykernel install --user --name $(KERNEL) --display-name "$(KERNEL)"
	uv export --format requirements-txt --no-hashes --no-annotate --no-header -o requirements.txt
	@echo "Entorno preparado."

notebook:
	uv run --no-sync jupyter lab

clean:
	-$(PYTHON) -m jupyter kernelspec remove -f $(KERNEL)
	rm -rf $(VENV)
	@echo "Entorno eliminado."
