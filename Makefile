.PHONY: clean
.DEFAULT_GOAL := build

GIT_HASH := $(shell git --no-pager show --format=%h --no-patch)
BUILD_DATE := $(shell date +%Y%m%d-%H%M%S)

VERSION := ${GIT_HASH}${IS_DIRTY}

IMAGE_REPOSITORY := atlassianlabs/fluentd
IMAGE_REFERENCE := ${IMAGE_REPOSITORY}:$(tag)

help: ### Dumps out all the target lines with suffixed comments
	@cat < $(MAKEFILE_LIST) \
		| awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ { split($$2, A, "###"); print $$1"|||"A[2]; }' \
		| column -t -s'|||'

build: ### Builds a local docker image passing in the git information in as a label
ifndef tag
	@echo "No value found for tag. Specify the image tag on the command line with\n\tmake build tag=1.0.0"
	@exit 1
endif
	docker build -t ${IMAGE_REFERENCE} \
		--label build_date="${BUILD_DATE}" \
		--label version="${VERSION}" \
		.

release: build ### Pushes the locally build docker image to the hub.docker.com registry
	git tag $(tag)
	docker push ${IMAGE_REFERENCE} latest

