Chatmail Tanka Deployment
=========================

This directory hosts the Jsonnet/Tanka reimplementation of the existing
`cmdeploy` bare-metal workflow. The goal is to describe the same relay
topology—Postfix, Dovecot, nginx, acmetool, OpenDKIM, chatmaild workers,
IROH relay, TURN, mtail, and supporting cron/timer jobs—as Kubernetes
manifests that can be composed, diffed, and applied with `tk`.

## Prerequisites

- `tk` (Grafana Tanka) and `jsonnet-bundler (jb)` available on `$PATH`.
- `jsonnet` / `jsonnetfmt` for formatting the library code.
- `python3` for the helper scripts under `tkdeploy/scripts`.
- Access to a Kubernetes cluster (or dummy API server) for `tk diff/apply`.
- Optional: container runtime & build tooling for the images in `tkdeploy/images`.

`scripts/initenv.sh` still applies when preparing local development hosts:
Ubuntu/Debian users need `python3-dev` and `gcc` in order to build Python
dependencies before invoking any chatmaild utilities. The Tanka workflow
assumes those packages are present when running the conversion helpers.

### Jsonnet dependencies

`jb init` has pre-generated `jsonnetfile.json` together with a locked
`jsonnetfile.lock.json`. The following packages were pinned:

- `github.com/jsonnet-libs/k8s-libsonnet@291653b2` – core Kubernetes types.
- `github.com/jsonnet-libs/xtd@4eee017d` – utility mixins used across components.

`github.com/grafana/tanka-lib/kubernetes` is recommended but could not be
fetched automatically on this machine because Git attempted an interactive
SSH clone. Run the following once Git credential helpers are configured:

```
jb install github.com/grafana/tanka-lib/kubernetes@main
```

and commit the resulting vendor changes.

## Layout

```
tkdeploy/
  README.md               – this document
  tkrc.yaml               – default Tanka runtime configuration
  jsonnetfile.json        – Jsonnet Bundler manifest
  jsonnetfile.lock.json   – version lock file
  environments/
    default/
      main.jsonnet        – aggregates components for the default env
      spec.json           – cluster connection placeholders
      values.libsonnet    – environment overrides (create per cluster)
  lib/
    config.libsonnet      – shared configuration mirroring chatmail.ini
    util.libsonnet        – helper functions and Jsonnet mixins
    patches.libsonnet     – overlay hooks used to tweak upstream libs
  components/             – service specific manifests (Postfix, nginx, ...)
  images/                 – Dockerfiles for stateful/stateless workloads
  scripts/
    ini_to_jsonnet.py     – converts chatmail.ini into Jsonnet objects
    tkdeploy              – wrapper around tk commands
    lint.sh               – helper for fmt/diff validation
  vendor/                 – jb-managed dependencies
```

Each component library (`components/*.libsonnet`) will render ConfigMaps,
Secrets, Deployments/StatefulSets, Services, CronJobs, and required RBAC
objects for the corresponding subsystem currently installed by `cmdeploy`.

## Workflow Summary

1. Populate `environments/default/values.libsonnet` using the conversion
   helper: `python3 scripts/ini_to_jsonnet.py ../chatmaild/src/chatmaild/ini/chatmail.ini.f`.
2. Review `main.jsonnet` to enable or disable optional services (IROH relay,
   mtail, metrics cronjobs) matching the bare-metal configuration.
3. Format and vendor dependencies: `./scripts/lint.sh` (runs `jsonnetfmt`,
   `tk fmt`, and `tk tool` validations) once the libraries are populated.
4. Explore the rendered manifests: `./scripts/tkdeploy show environments/default`.
5. When satisfied, use `./scripts/tkdeploy apply environments/default`.

## Mapping from cmdeploy

| Service / Artifact | Bare-metal source | Planned Kubernetes resource |
| ------------------ | ----------------- | --------------------------- |
| chatmaild services | `cmdeploy/src/cmdeploy/service/*.service.f`, timers in same directory | Deployments (long-running) and CronJobs with ConfigMaps/Secrets for chatmail.ini |
| Postfix | `cmdeploy/src/cmdeploy/postfix/*.j2`, login map, reinjection ports | StatefulSet with PVCs for `/var/spool/postfix`, ConfigMaps for templated configuration |
| Dovecot | `cmdeploy/src/cmdeploy/dovecot/*` | StatefulSet with RWX storage for `/home/vmail`, Secret mounts for doveauth sockets |
| nginx + fcgiwrap | `cmdeploy/src/cmdeploy/nginx/*.j2`, `chatmaild/newemail.py` | Deployment + Service + optional Ingress, ConfigMaps for nginx stream/http config |
| acmetool | `cmdeploy/src/cmdeploy/acmetool/*` | Deployment + CronJob (HTTP-01 solver) or migration notes to `cert-manager` |
| OpenDKIM | `cmdeploy/src/cmdeploy/opendkim/*` | Deployment with Secret-backed key material, ConfigMap for Lua/policy files |
| mtail | `cmdeploy/src/cmdeploy/mtail/*` | Deployment exposing metrics Service and optional ServiceMonitor |
| IROH relay | `cmdeploy/src/cmdeploy/iroh-relay.{service,toml}` | Deployment + Service, ConfigMap for `iroh-relay.toml` |
| TURN server | `cmdeploy/src/cmdeploy/service/turnserver.service.f` | Deployment or DaemonSet with hostNetwork/NodePort for UDP 3478 |
| Journald tuning | `cmdeploy/src/cmdeploy/journald.conf` | DaemonSet or documentation for node-level journald settings |
| Web assets | `www/src/**/*` | ConfigMap or container image consumed by nginx |

Component libraries currently emit planning metadata; wire them up to real Kubernetes objects as the migration progresses.

## Status & Next Steps

- [x] Repository scaffolding, Jsonnet bundler setup, helper scripts, and container image placeholders.
- [ ] Translate each component plan into concrete Jsonnet resources (Deployments, StatefulSets, Services, Secrets, PVCs, CronJobs).
- [ ] Integrate `github.com/grafana/tanka-lib/kubernetes` once Git credential prompts are resolved and the dependency can be vendored.
- [ ] Flesh out Dockerfiles with binaries and CI publishing instructions.
- [ ] Add unit tests or `tk tool test` invocations to guard generated manifests.

When adding real manifests, update this README to reflect image names, volume mounts, and operational runbooks.

## Open items & risks

- Confirm Kubernetes storage classes that satisfy `/home/vmail`,
  `/var/lib/acme`, `/etc/dkimkeys`, and `/var/spool/postfix` persistence.
- Mail workloads often require low ports and predictable IPs (SMTP/IMAP).
  The manifests must account for host networking or LoadBalancer support.
- TURN (UDP 3478) and IROH (TCP 3340) may need separate Services or
  direct hostPort usage depending on cluster capabilities.
- ACME issuance in Kubernetes should likely leverage `cert-manager`; the
  acmetool assets remain documented for reference until replaced.
- Secret distribution for DKIM keys, echobot password, and chatmail.ini
  material needs alignment with your secret management strategy (CSI,
  SealedSecrets, Vault, etc.).

Track these concerns in follow-up issues while the Jsonnet components are
implemented.
