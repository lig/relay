# syntax=docker/dockerfile:1

# TODO: package Dovecot with push notification Lua hooks and chatmaild sockets.
# This placeholder installs distro packages; refine with custom build or OBS
# packages matching the existing deployment.
FROM debian:bookworm-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y dovecot-imapd dovecot-lmtpd && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/sbin/dovecot", "-F"]
