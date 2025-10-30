# syntax=docker/dockerfile:1

# TODO: build Postfix image with config volume mounts and minimal runtime
# dependencies. Install postfix, configure entrypoint to read ConfigMap data,
# and ensure mail queue directories are mounted from persistent volumes.
FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postfix && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/sbin/postfix", "start-fg"]
