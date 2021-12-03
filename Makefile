.POSIX:

.PHONY: multiarch-qemu-reset
multiarch-qemu-reset:
	# this is PROBABLY dangerous in the event your system already has bin
	# handlers or something but whatever, those are *super* uncommon,
	# especially on CI rigs
	[ "$$(uname -s) $$(uname -m)" = "Linux x86_64" ] && docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || true

.PHONY: release-linux-amd64
release-linux-amd64: multiarch-qemu-reset
	docker buildx build --platform linux/amd64 .

.PHONY: release-linux-arm64
release-linux-arm64: multiarch-qemu-reset
	docker buildx build --platform linux/arm64 .

.PHONY: release-linux
release-linux: multiarch-qemu-reset
	docker buildx build --platform linux/amd64,linux/arm64 .
