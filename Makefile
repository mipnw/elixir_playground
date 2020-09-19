SHELL := /bin/bash
PROJECTNAME = elixir_playground
THIS_DIR = $(shell pwd)

.PHONY: help
help:
	@echo 'Usage: make [target] [options]'
	@echo 'Build and use the Elixir Playground'
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

ifndef VERBOSE
.SILENT:
endif

.dockerimage: Dockerfile Makefile
	docker build \
		--force-rm \
		-f Dockerfile \
		-t $(PROJECTNAME):latest \
		--target dev \
		$(THIS_DIR)
	docker image ls $(PROJECTNAME):latest > .dockerimage
build: .dockerimage ## builds the Elixir Playground: a Docker image with Elixir installed

.PHONY: shell
shell: .dockerimage ## shells into the Elixir Playground in a Docker container
	docker run \
		--rm \
		-it \
		--hostname devbox \
		--workdir /$(PROJECTNAME) \
		--volume $(THIS_DIR)/projects:/$(PROJECTNAME) \
		$(PROJECTNAME):latest

.PHONY: iex
iex: .dockerimage ## interactive Elixir in a Docker container
	docker run \
		--rm \
		-it \
		--hostname iex \
		$(PROJECTNAME):latest \
		/usr/bin/iex

.PHONY: clean
clean: ## cleans your host of development artifacts
	-docker image rm -f $(PROJECTNAME):latest &> /dev/null
	-rm .dockerimage &> /dev/null