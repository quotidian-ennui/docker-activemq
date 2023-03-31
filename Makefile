MAKEFLAGS+= --silent --always-make
.DEFAULT_GOAL:= help
.ONESHELL:
SHELL:=bash

DOCKER_TARGETS=$(sort $(dir $(wildcard ./**/Dockerfile)))
UPDATE_CLI:=$(shell which updatecli)
DOCKER:=$(shell which docker)
USER?=$(shell whoami)
BASE_TAG:="$(USER)/activemq"

help:
	grep -E '^[a-zA-Z_-]+.*:.*?## .*$$' $(word 1,$(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-all: ## Do a local docker build using docker build
ifndef ACTIVEMQ_VERSION
	$(error ACTIVEMQ_VERSION environment variable not set)
endif
	for t in $(DOCKER_TARGETS); do
		target=$$(basename $$t)
		echo "-------- $$target ($(ACTIVEMQ_VERSION))";
		"$(DOCKER)" build  . --build-arg "ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION)" --tag "$(BASE_TAG):$${target}" -f "$${target}/Dockerfile" --load
	done

build-%: ## Do a specific local docker build (e.g. build-temurin) using vanilla docker build
ifndef ACTIVEMQ_VERSION
	$(error ACTIVEMQ_VERSION environment variable not set)
endif
	echo "-------- $* ($(ACTIVEMQ_VERSION))"
	"$(DOCKER)" build  . --build-arg "ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION)" --tag "$(BASE_TAG):$*" -f "$*/Dockerfile" --load

diff:  ## Check dependencies via updatecli
	$(UPDATE_CLI) diff

update:  ## Updates dependencies via updatecli
	$(UPDATE_CLI) apply
