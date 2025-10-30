# Chatmail container build targets

This directory collects Dockerfiles (and future build scripts) for the
workloads that `cmdeploy` currently installs directly on the host. Each
subdirectory maps to a component rendered by the Jsonnet libraries in
`tkdeploy/components/`.

| Image | Purpose | Notes |
|-------|---------|-------|
| `postfix/` | SMTP queue handling (25/465/587) | Requires persistent `/var/spool/postfix` volume. |
| `dovecot/` | IMAP storage and SASL sockets | Needs `/home/vmail` RWX storage and Lua hook injection. |
| `nginx/` | HTTPS front-end, CGI for onboarding | Streams TLS to Postfix/Dovecot; integrate with `fcgiwrap`. |
| `opendkim/` | DKIM signing and policy enforcement | Mounts DKIM keys from Secrets; ships Lua policy scripts. |
| `chatmaild/` | Python services (doveauth, filtermail, etc.) | Build from local source, export separate entrypoints. |
| `acmetool/` | Legacy ACME client | Reference implementation; consider replacing with `cert-manager`. |
| `mtail/` | Metrics collector | Packages delivered_mail program and exposes `/metrics`. |
| `iroh-relay/` | Optional DERP relay | Disabled when `config.iroh_relay` is overridden. |
| `turnserver/` | chatmail-turn WebRTC helper | May require host networking or MetalLB for UDP 3478. |

Each Dockerfile presently documents the intended behaviour but does not yet
copy binaries or full configuration. Flesh these out once the corresponding
Jsonnet components are ready and CI publishing steps are defined.
