MAKEFLAGS+= --silent --always-make
.DEFAULT_GOAL:= help
SHELL:=bash

DOCKER_TARGETS=$(sort $(dir $(wildcard ./**/Dockerfile)))
UPDATE_CLI:=updatecli
DOCKER:=docker
USER?=$(shell whoami)
BASE_TAG:="$(USER)/activemq"

help:
	grep -E '^[a-zA-Z_-]+.*:.*?## .*$$' $(word 1,$(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-all: ## Do a local docker build using docker build
ifndef ACTIVEMQ_VERSION
	for t in $(DOCKER_TARGETS); do \
		target=$$(basename $$t); \
		echo "-------- $$target ($$(cat  "$${target}/Dockerfile" | grep "ARG ACTIVEMQ_VERSION"))"; \
		"$(DOCKER)" build  . --no-cache --tag "$(BASE_TAG):$${target}" -f "$${target}/Dockerfile" --load; \
	done
else
	for t in $(DOCKER_TARGETS); do \
		target=$$(basename $$t); \
		echo "-------- $$target (ENV ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION))"; \
		"$(DOCKER)" build  . --no-cache --build-arg "ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION)" --tag "$(BASE_TAG):$${target}" -f "$${target}/Dockerfile" --load; \
	done
endif

build-%: ## Do a specific local docker build (e.g. build-temurin) using vanilla docker build
ifndef ACTIVEMQ_VERSION
	echo "-------- $* ($$(cat  "$*/Dockerfile" | grep "ARG ACTIVEMQ_VERSION"))"
	"$(DOCKER)" build  . --no-cache --tag "$(BASE_TAG):$*" -f "$*/Dockerfile" --load
else
	echo "-------- $* (ENV ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION))"
	"$(DOCKER)" build  . --no-cache --build-arg "ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION)" --tag "$(BASE_TAG):$*" -f "$*/Dockerfile" --load
endif

diff:  ## Check dependencies via updatecli
	$(UPDATE_CLI) diff

update:  ## Updates dependencies via updatecli
	$(UPDATE_CLI) apply

clean: ## Delete built images
	$(DOCKER) images | grep "$(BASE_TAG)" | awk '{print $$3}' | xargs -r docker rmi
