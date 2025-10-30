# syntax=docker/dockerfile:1

# TODO: bake iroh-relay static binary into an OCI image.
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

# Copy the iroh-relay binary during implementation.

CMD ["/usr/local/bin/iroh-relay", "--help"]
