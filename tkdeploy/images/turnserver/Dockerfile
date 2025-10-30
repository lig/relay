# syntax=docker/dockerfile:1

# TODO: containerize chatmail-turn binary with UDP listener capabilities.
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

# Copy chatmail-turn binary during implementation.

CMD ["/usr/local/bin/chatmail-turn", "--help"]
