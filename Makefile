.PHONY: clean
.DEFAULT_GOAL := build

GIT_HASH := $(shell git --no-pager show --format=%h --no-patch)
BUILD_DATE := $(shell date +%Y%m%d-%H%M%S)
BRANCH := $(shell git symbolic-ref --short HEAD)

IS_DIRTY := $(shell ! [[ -z "$(git status --porcelain 2> /dev/null)" ]] && echo "-dirty")
VERSION := ${GIT_HASH}${IS_DIRTY}
TAG ?= ${VERSION}

IMAGE_REPOSITORY := atlassianlabs/fluentd
IMAGE_REFERENCE := ${IMAGE_REPOSITORY}:$(TAG)

help: ### Dumps out all the target lines with suffixed comments
	@cat < $(MAKEFILE_LIST) \
		| awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ { split($$2, A, "###"); print $$1"|||"A[2]; }' \
		| column -t -s'|||'

build: ### Builds a local docker image passing in the git information in as a label
	docker build -t ${IMAGE_REFERENCE} \
		--label build_date="${BUILD_DATE}" \
		--label=branch="${BRANCH}" \
		--label=version="${VERSION}" \
		.

release: build ### Pushes the locally build docker image to the hub.docker.com registry
	docker push ${IMAGE_REFERENCE}
