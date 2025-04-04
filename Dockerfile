# Alpine is used to stage files and directories that are
# copied into the scratch image. It is also used to create
# /etc/passwd and /etc/group files for the otel user. Lastly,
# Alpine is used to retrieve the CA certificates.
FROM alpine AS stage

RUN addgroup -S -g 10005 otel && adduser -S -u 10005 -G otel otel

RUN apk update && apk add --no-cache ca-certificates

RUN mkdir \
  /etc/otel \
  /etc/otel/storage \
  && chown -R otel:otel /etc/otel \
  && chmod 0750 /etc/otel/storage

# Scratch images contain nothing by default. The built image
# will contain only what was copied into it. This means it
# does not contain utilities like ls, cat, or even a shell.
# Care must be taken to ensure that the built image contains
# the required permissions and ca-certificate files.
FROM scratch

COPY --from=stage /etc/passwd /etc/passwd
COPY --from=stage /etc/group /etc/group
COPY --from=stage /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=stage --chown=otel:otel /etc/otel /etc/otel
COPY --from=stage --chown=otel:otel /etc/otel/storage /etc/otel/storage

COPY build/dist/andy-otel-gateway_linux_arm64_v8.0/andy-otel-gateway /collector/andy-otel-gateway
COPY supervisor.yaml /etc/otel/supervisor.yaml
COPY opampsupervisor /collector/opampsupervisor

ENV OIQ_OTEL_COLLECTOR_HOME=/etc/otel
ENV OIQ_OTEL_COLLECTOR_STORAGE=/etc/otel/storage

USER otel
WORKDIR /etc/otel
ENTRYPOINT [ "/collector/opampsupervisor", "--config", "/etc/otel/supervisor.yaml" ]
EXPOSE 4317 55678 55679
