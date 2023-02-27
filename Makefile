MAKEFLAGS+= --silent --always-make
.DEFAULT_GOAL:= help
.ONESHELL:

DOCKER_TARGETS=$(sort $(dir $(wildcard ./**/Dockerfile)))
UPDATE_CLI:=$(shell which updatecli)
DOCKER:=$(shell which docker)
USER?=$(shell whoami)
BASE_TAG:="$(USER)/activemq"
PLATFORM:="linux/amd64"

help:
	grep -E '^[a-zA-Z_-]+.*:.*?## .*$$' $(word 1,$(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Do a local docker build
ifndef ACTIVEMQ_VERSION
	$(error ACTIVEMQ_VERSION environment variable not set)
endif
	for t in $(DOCKER_TARGETS); do \
		target=$$(basename $$t)
		echo "-------- $$target ($$ACTIVEMQ_VERSION)"; \
		"$(DOCKER)" buildx build  . --build-arg "ACTIVEMQ_VERSION=$(ACTIVEMQ_VERSION)" --platform $(PLATFORM) --tag "$(BASE_TAG):$${target}" -f "$${target}/Dockerfile" --load; \
	done

diff:  ## Check dependencies via updatecli
	$(UPDATE_CLI) diff

apply:  ## Updates dependencies via updatecli
	$(UPDATE_CLI) apply
