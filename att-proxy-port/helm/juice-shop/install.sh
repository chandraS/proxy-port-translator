#!/usr/bin/env bash
# Reproduces Helm release 'juice-shop' (chart juice-shop-5.8.0, app v20.1.1, captured at revision 1).
# A Helm release does not record which repo the chart came from — verify the chart source.
set -euo pipefail
helm repo add secureCodeBox https://charts.securecodebox.io   # verify this is the repo you used
helm upgrade --install juice-shop secureCodeBox/juice-shop \
  --version 5.8.0 \
  -n origin --create-namespace \
  -f "$(dirname "$0")/values.yaml"
