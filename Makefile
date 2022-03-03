.POSIX:

SORBET_VERSION ?= $(shell git describe --tags | cut -d. -f1-3)
REGISTRY ?= ghcr.io/dockwa/sorbet
REGISTRY_IMAGE ?= $(SORBET_VERSION)

ifeq ($(PUSH),1)
	PUSH_FLAG := --push
endif

.PHONY: multiarch-qemu-reset
multiarch-qemu-reset:
	# this is PROBABLY dangerous in the event your system already has bin
	# handlers or something but whatever, those are *super* uncommon normally
	#
	# DO NOT run this on GitHub Actions, use docker/setup-qemu-action@v1
	# instead!
	[ "$$(uname -s)" = "Linux" ] && docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || true

.PHONY: buildx-image
buildx-image:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		-t $(REGISTRY):$(REGISTRY_IMAGE) \
		$(PUSH_FLAG) \
		.
