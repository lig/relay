# syntax=docker/dockerfile:1

# TODO: create OpenDKIM image with lua policy hooks and key volume mounts.
FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y opendkim opendkim-tools && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/sbin/opendkim", "-f"]
