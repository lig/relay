#!/bin/sh
set -euf

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)
cd "${ROOT_DIR}"

if command -v jsonnetfmt >/dev/null 2>&1; then
  find lib components environments -type f \( -name '*.libsonnet' -o -name '*.jsonnet' \) -print0 \
    | xargs -0 jsonnetfmt -i
else
  echo "warning: jsonnetfmt not found; skipping formatting" >&2
fi

if command -v tk >/dev/null 2>&1; then
  tk fmt environments/default
else
  echo "warning: tk not found; skipping tk fmt" >&2
fi

if command -v jb >/dev/null 2>&1; then
  jb install
else
  echo "warning: jb not found; skipping dependency refresh" >&2
fi
