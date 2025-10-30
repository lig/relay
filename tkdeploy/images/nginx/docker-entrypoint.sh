#!/bin/sh
set -e

# TODO: inject templated nginx configuration into /etc/nginx prior to launch.
exec nginx -g 'daemon off;'
