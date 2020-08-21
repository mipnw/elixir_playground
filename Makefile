SHELL := /bin/bash
PROJECTNAME = elixir_playground
THIS_DIR = $(shell pwd)
WORKDIR = /$(PROJECTNAME)

.PHONY: help
help:
	@echo 'Usage: make [target] [options]'
	@echo 'Build and use the Elixir Playground'
	@echo ''
	@echo 'Targets:'      
	@echo '  build     builds the Elixir Playground: a Docker image with Elixir installed'
	@echo '  shell     shells into the Elixir Playground in a Docker container'
	@echo '  iex       interactive Elixir in a Docker container'
	@echo '  clean     cleans your host of development artifacts'
	@echo ''

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
build: .dockerimage

.PHONY: shell
shell: .dockerimage
	docker run \
		--rm \
		-it \
		--hostname devbox \
		--workdir $(WORKDIR) \
		--volume $(THIS_DIR)/scripts:$(WORKDIR) \
		$(PROJECTNAME):latest

.PHONY: iex
iex: .dockerimage
	docker run \
		--rm \
		-it \
		--hostname iex \
		$(PROJECTNAME):latest \
		/usr/bin/iex

.PHONY: clean
clean:
	-docker image rm -f $(PROJECTNAME):latest &> /dev/null
	-rm .dockerimage &> /dev/null