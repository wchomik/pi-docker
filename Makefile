IMAGE_NAME = pi-agent
IMAGE_TAG = latest
CONTAINER = $(IMAGE_NAME):$(IMAGE_TAG)

# 1. Capture the second word as the directory path
# 2. $(eval $(RUN_ARGS):;@:) tells Make to do nothing with the path target so it doesn't error
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)

# Comma-separated list of extensions to install and load
# e.g. EXTENSIONS=npm:pi-observability,npm:pi-web-access
EXTENSIONS ?= npm:pi-observability,npm:pi-web-access

# Path to pi home directory on the host to mount into the container.
# Set to empty string to disable mounting (e.g. PI_HOME=).
PI_HOME ?= ~/.pi

.PHONY: help build update refresh run shell serve rm

help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build: ## Build the image
	docker build -t $(CONTAINER) .

update: ## Pull newest base image and rebuild
	docker build --pull -t $(CONTAINER) .

refresh: ## Rebuild the image (run this after changing dependencies)
	docker build --no-cache -t $(CONTAINER) .

run: ## Run agent in a dir with extensions. Usage: make run ~/my-project
	@echo "Extensions: $(EXTENSIONS)"
ifneq ($(PI_HOME),)
	@echo "PI_HOME: $(PI_HOME)"
endif
	@WORK_DIR=$(or $(RUN_ARGS),.) && docker run --rm -it $(if $(PI_HOME),-v $$(realpath $(PI_HOME)):/root/.pi,) -e PI_EXTENSIONS=$(EXTENSIONS) -v $$WORK_DIR:/work -w /work $(CONTAINER) pi

shell: ## Open bash in a container. Usage: make shell ~/my-project
ifneq ($(PI_HOME),)
	@echo "PI_HOME: $(PI_HOME)"
endif
	@WORK_DIR=$(or $(RUN_ARGS),.) && docker run --rm -it $(if $(PI_HOME),-v $$(realpath $(PI_HOME)):/root/.pi,) -e PI_EXTENSIONS=$(EXTENSIONS) -v $$WORK_DIR:/work -w /work $(CONTAINER) /bin/bash

TTYD_PORT ?= 7681
TTYD_THEME ?= theme={"background": "black"}

serve: ## Run agent via ttyd in browser (http://localhost:7681). Usage: make serve ~/my-project
	@echo "Extensions: $(EXTENSIONS)"
ifneq ($(PI_HOME),)
	@echo "PI_HOME: $(PI_HOME)"
endif
	@echo "Open http://localhost:$(TTYD_PORT) in your browser"
	@WORK_DIR=$(or $(RUN_ARGS),.) && docker run --rm -it -p $(TTYD_PORT):$(TTYD_PORT) $(if $(PI_HOME),-v $$(realpath $(PI_HOME)):/root/.pi,) -e TTYD_PORT=$(TTYD_PORT) -e TTYD_THEME=$(TTYD_THEME) -e PI_EXTENSIONS=$(EXTENSIONS) -v $$WORK_DIR:/work -w /work $(CONTAINER)

rm: ## Remove the image
	docker rmi $(CONTAINER)
