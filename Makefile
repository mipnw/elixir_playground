SHELL := /bin/bash
PROJECTNAME = elixir_playground
THIS_DIR = $(shell pwd)


DOCKER_ARGS :=                --env LOCAL_USER_ID=$(shell id -u)
DOCKER_ARGS := $(DOCKER_ARGS) --env LOCAL_GROUP_ID=$(shell id -g)
DOCKER_ARGS := $(DOCKER_ARGS) --env ROOT=$(ROOT)
DOCKER_ARGS := $(DOCKER_ARGS) --workdir /$(PROJECTNAME)
DOCKER_ARGS := $(DOCKER_ARGS) --volume $(THIS_DIR)/projects:/$(PROJECTNAME)
ifdef DOCKER_USER_PATH
DOCKER_ARGS := $(DOCKER_ARGS) --volume $(DOCKER_USER_PATH):/mnt/appuser:ro
endif

.PHONY: help
help:
	@echo 'Usage: make [target] [options]'
	@echo 'Build and use the Elixir Playground'
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

ifndef VERBOSE
.SILENT:
endif

.dockerimage: Dockerfile $(shell find scripts -type f)
	docker build \
		--force-rm \
		-f Dockerfile \
		-t $(PROJECTNAME):latest \
		$(THIS_DIR)
	docker image ls $(PROJECTNAME):latest > .dockerimage
build: .dockerimage ## builds the Elixir Playground: a Docker image with Elixir installed

.PHONY: shell
shell: .dockerimage ## shells into the Elixir Playground in a Docker container
	docker run --rm -it \
		--hostname devbox \
		$(DOCKER_ARGS) \
		$(PROJECTNAME):latest \
		/bin/bash

.PHONY: iex
iex: .dockerimage ## interactive Elixir in a Docker container
	docker run --rm -it \
		$(DOCKER_ARGS) \
		$(PROJECTNAME):latest \
		/usr/bin/iex

.PHONY: clean
clean: ## cleans your host of development artifacts
	-docker image rm -f $(PROJECTNAME):latest &> /dev/null
	-rm .dockerimage &> /dev/null