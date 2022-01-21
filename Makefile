VERSION ?= 0.4.0
RUST_VERSION ?= 1.57.0
REPO ?= liquid-dev/lambda-rust
REGISTRY = ghcr.io
TAG ?= "$(REGISTRY)/$(REPO):$(VERSION)-rust-$(RUST_VERSION)"

publish: build
	@docker push $(TAG)

build:
	@docker build --build-arg RUST_VERSION=$(RUST_VERSION) -t $(TAG) .
	@docker tag $(TAG) $(REPO):latest

debug: build
	@docker run --rm -it \
		-u $(id -u):$(id -g) \
		-v ${PWD}:/code \
		-v ${HOME}/.cargo/registry:/cargo/registry \
		-v ${HOME}/.cargo/git:/cargo/git  \
		--entrypoint=/bin/bash \
		$(REPO)
