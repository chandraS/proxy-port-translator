#!/usr/bin/env bash
# Reproduces Helm release 'eg' (chart gateway-helm-1.8.3, app v1.8.3, captured at revision 2).
# A Helm release does not record which repo the chart came from — verify the chart source.
set -euo pipefail

helm upgrade --install eg oci://docker.io/envoyproxy/gateway-helm \
  --version 1.8.3 \
  -n envoy-gateway-system --create-namespace \
  -f "$(dirname "$0")/values.yaml"
