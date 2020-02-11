RELEASE_TYPE ?= patch

CURRENT_VERSION := $(shell git ls-remote --tags | awk '{ print $$2}'| sort -nr | head -n1|sed 's/refs\/tags\///g')

ifndef CURRENT_VERSION
  CURRENT_VERSION := 0.0.0
endif

NEXT_VERSION := $(shell docker run --rm alpine/semver semver -c -i $(RELEASE_TYPE) $(CURRENT_VERSION))

IMAGE ?= $(shell echo trendyoltech/trendyol-consul-template:{{VERSION}} | sed -E "s/{{VERSION}}/$(NEXT_VERSION)/g")

.PHONY: current-version next-version build release

current-version:
	@echo $(CURRENT_VERSION)

next-version:
	@echo $(NEXT_VERSION)

build:
	@docker image build \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_TIME=`date -u +"%m-%d-%YT%H:%M:%SZ"` \
	--build-arg VERSION=$(NEXT_VERSION) \
	--tag $(IMAGE) \
	.
release: build
	@docker image push $(IMAGE)
