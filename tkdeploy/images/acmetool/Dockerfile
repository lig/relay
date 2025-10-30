# syntax=docker/dockerfile:1

# TODO: containerize acmetool redirector and hooks for certificate issuance.
FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y acmetool curl && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/acmetool", "--help"]
