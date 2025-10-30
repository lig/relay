# syntax=docker/dockerfile:1

# TODO: bundle nginx with stream module, fcgi support, and chatmail static assets.
FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx fcgiwrap && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
