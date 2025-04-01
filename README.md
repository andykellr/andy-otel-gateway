# andy-otel-gateway

## Building the image

Important! You need to have a copy of the `opampsupervisor` binary in the root directory.
I grabbed mine from the `bindplane-otel-collector` distribution.

```bash
docker build -t andy-otel-gateway -f Dockerfile .
```

## Running the image

```bash
docker compose up -d
```
