# andy-otel-gateway

## Generating the build

```bash
make build
```

```bash
docker pull ghcr.io/observiq/otel-distro-builder:main
docker run --rm -v $(pwd):/workspace -v $(pwd)/build:/build ghcr.io/observiq/otel-distro-builder:main \
  --manifest /workspace/manifest.yaml
```

## Building the image

Important! You need to have a copy of the `opampsupervisor` binary in the root directory.
I grabbed mine from the `bindplane-otel-collector` distribution.

```bash
make image
```

```bash
docker build -t andy-otel-gateway -f Dockerfile .
```

## Running the image

```bash
make up
```

```bash
docker compose up -d
```
