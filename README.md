# att-proxy-port — cluster manifests

Exported 2026-10-29T19:01Z from context `lke631133-ctx`
by export-manifests.sh. Cluster-generated fields (status, uid, resourceVersion, managedFields,
clusterIP, nodePort, last-applied annotations, controller finalizers) are stripped.

## Layout
- `helm/<release>/` — Helm-managed components as chart + `values.yaml` + `install.sh`.
  `rendered-manifest.reference.yaml` is for diffing only; do not apply it.
- `_cluster/` — Namespaces and cluster-scoped Gateway API objects (e.g. GatewayClass).
- `<namespace>/` — one file per object (Gateway, routes, EnvoyProxy, policies, Deployments,
  Services, ConfigMaps, …). Each directory has a `kustomization.yaml`.
- `<namespace>/_secrets-redacted/` — Secret shapes with every value set to `REPLACE_ME`.
  Not referenced by any kustomization. Do not put real values in git (use SOPS / External Secrets).
- `_provenance.tsv` — every object seen: exported or skipped (with reason) and its field managers.

## Rebuild order
1. `helm/eg/install.sh` (Envoy Gateway controller + Gateway API CRDs)
2. Create secrets out-of-band
3. `kubectl apply -k .`
4. `helm/<other releases>/install.sh`

## What this does NOT capture
- Files baked into container images (e.g. nginx.conf built into the nginx-backend image).
  Check the image in `origin/deployment-nginx-backend.yaml`; if config isn't in a ConfigMap, it's in the image.
- Secret values.
- CRD definitions (they ship with the Envoy Gateway chart).
- Objects skipped as derived (see `_provenance.tsv`): Envoy proxy Deployment/Service generated
  from the Gateway, ReplicaSets/Pods, Helm-owned objects.

## Review before committing
- Service annotations `service.beta.kubernetes.io/linode-loadbalancer-*`: a
  `…-nodebalancer-id` annotation pins a specific NodeBalancer. Keep it to adopt the existing NB;
  remove it for a fresh cluster.
- nodePorts were stripped. If the port translation depends on fixed nodePorts, rerun with KEEP_NODEPORTS=1.
