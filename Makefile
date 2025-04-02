OCB_VERSION := 0.123.0
OTEL_VERSION := 0.123.1

.PHONY: build
build:
	docker pull ghcr.io/observiq/otel-distro-builder:main
	docker run --rm -v $(shell pwd):/workspace -v $(shell pwd)/build:/build ghcr.io/observiq/otel-distro-builder:main --manifest /workspace/manifest.yaml --ocb-version $(OCB_VERSION) --supervisor-version $(OTEL_VERSION)

.PHONY: image
image:
	docker build -t andy-otel-gateway -f Dockerfile .

.PHONY: up
up:
	docker compose up -d
