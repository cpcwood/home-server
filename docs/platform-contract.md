# Platform contract

What this Helm chart and its supporting Terraform expect from the Kubernetes cluster it deploys into. Treat it like an API: change a name, namespace, or kind on either side and the other side breaks.

## What the platform provides

| Resource | Name | Scope |
|---|---|---|
| `ClusterSecretStore` (External Secrets Operator) | `aws-parameter-store`, with provider `aws.service: ParameterStore` | cluster |
| ESO operator + CRDs | — | cluster |
| `GatewayClass` | `traefik` | cluster |
| Gateway API v1 CRDs (`Gateway`, `HTTPRoute`) | — | cluster |
| Default `StorageClass` | `local-path` | cluster |
| cert-manager + CRDs | — | cluster |
| `ClusterIssuer` (production) | `letsencrypt-prod`, with `solvers[].http01.gatewayHTTPRoute` | cluster |
| `ClusterIssuer` (staging) | `letsencrypt-staging`, with `solvers[].http01.gatewayHTTPRoute` | cluster |
| IAM principal authorised on AWS SSM Parameter Store | reads `/<cluster>/*` (`ssm:GetParameter*`, `ssm:DescribeParameters`, `kms:Decrypt` via SSM) | AWS account |
| GitHub OIDC provider | `token.actions.githubusercontent.com` | AWS account |
| Velero (cluster backup) | backs up namespaces + PersistentVolumes on a schedule | cluster |
| kube-prometheus-stack (Prometheus, Alertmanager, Grafana, kube-state-metrics, node-exporter) | release `kube-prometheus-stack`, namespace `observability` | cluster |
| Prometheus Operator CRDs (`ServiceMonitor`, `PodMonitor`, `PrometheusRule`) | `monitoring.coreos.com` | cluster |
| `metrics-server` | namespace `kube-system` | cluster |

If any of these is missing, the corresponding app feature breaks: pods crashloop on missing env vars (ESO), `Gateway` never reaches `Programmed: True` (GatewayClass), TLS cert hangs `Pending` (ClusterIssuer), `terraform apply` errors at a data-source lookup (OIDC provider), the `HorizontalPodAutoscaler` reports `<unknown>` CPU and never scales (metrics-server).

Backups are the platform's job: Velero snapshots every app namespace and its PersistentVolumes (so the Postgres data volume is covered). Apps do not ship their own backup jobs.

## What this app must do

- **Store every secret at `/<cluster>/home-server/<env>/<bundle>`** in AWS Parameter Store, type `SecureString`. Leading `/` follows the Parameter Store convention.
- **Reference the ClusterSecretStore by name** in every `ExternalSecret` (`global.clusterSecretStore` in the umbrella values).
- **Reference the GatewayClass by name** in every `Gateway` (per-chart `gateway.className`).
- **Read the GitHub OIDC provider as a Terraform `data` source**, never as a resource.
- **Install into the `home-server-production` namespace** (CI passes `--namespace home-server-production`). The namespace is created once at bootstrap (`kubectl create namespace`); the deploy ServiceAccount + its namespaced RBAC are managed by this repo's Terraform (`ci.tf`), not by the chart. Cross-namespace references in templates assume this name.
- **Label Grafana dashboard ConfigMaps `grafana_dashboard: "1"`** — the Grafana sidecar watches every namespace for this label and auto-imports the dashboard JSON.
- **Label `ServiceMonitor` / `PodMonitor` / `PrometheusRule` with `release: kube-prometheus-stack`** — Prometheus selects these by that label across all namespaces; without it the resource is silently ignored. (App metrics also need a `/metrics` endpoint to scrape — not yet exposed.)

## What this app must not do

- Define a `ClusterSecretStore` or `GatewayClass` (cluster-scoped — platform's job).
- Install Traefik, cert-manager, ESO, or a `StorageClass` (platform's job, or bundled with the cluster runtime).
- Declare the GitHub `aws_iam_openid_connect_provider` as a resource (it's account-scoped; the platform owns it). If a `terraform plan` proposes creating it, the data-source lookup failed — the platform isn't applied yet.
- Pin platform-component versions. Versioning lives on the platform side.

## Onboarding a new app on the same cluster

1. App repo creates its own Helm chart with `ExternalSecret` manifests referencing `ClusterSecretStore aws-parameter-store` and `Gateway` resources referencing `GatewayClass traefik`.
2. App's secrets live at `/<cluster>/<new-app>/<env>/*`. The platform's IAM policy already grants access to the whole `/<cluster>/*` subtree.
3. App's CI uses its own OIDC role, trusting the same account-scoped OIDC provider.

Adding a second app to an existing cluster requires zero platform changes. Adding a second cluster requires a new entry in the platform's allowed-prefix list.

## Versioning + change management

The contract is unversioned — there's one cluster, edits are coordinated by hand.

- **Breaking platform changes** (rename ClusterSecretStore, drop a ClusterIssuer, swap GatewayClass): update every consuming app's chart first, then the platform.
- **Additive platform changes** (new ClusterIssuer, new operator, new GatewayClass alongside): non-breaking, apps opt in when they need it.

## Failure modes

| Symptom | Likely contract breach |
|---|---|
| `ExternalSecret` stuck in `SecretSyncedError`, references `aws-parameter-store` not found | Platform not applied, ESO CRDs missing, or ClusterSecretStore renamed |
| `ExternalSecret` fails with `AccessDenied` from AWS | IAM principal lacks `ssm:Get*` / `kms:Decrypt` on the cluster prefix, or the parameter path doesn't match `/<cluster>/*` |
| `Gateway` stuck `Programmed: False`, no external address | Gateway API CRDs absent, controller not running, or `GatewayClass` name mismatched |
| `HTTPRoute` attaches but backend returns 404 | Service name in `backendRefs` doesn't exist in the same namespace, or `parentRefs.sectionName` doesn't match a Gateway listener name |
| TLS cert stuck `Pending`, `Certificate` conditions reference HTTPRoute | `ClusterIssuer` solver isn't `gatewayHTTPRoute` |
| `terraform apply` errors at `data.aws_iam_openid_connect_provider.github` | Platform OIDC provider not yet created |
| DB pod stuck `Pending` with "no persistent volumes available" | Default `StorageClass` isn't `local-path` (or `local-path-provisioner` not running) |
| Grafana dashboard ConfigMap never shows up in Grafana | Missing `grafana_dashboard: "1"` label, or the Grafana dashboard sidecar isn't running |
| `ServiceMonitor` exists but Prometheus shows no targets/metrics | Missing `release: kube-prometheus-stack` label, or the app exposes no `/metrics` endpoint |
| `HorizontalPodAutoscaler` shows `<unknown>` for CPU, never scales | `metrics-server` not running in `kube-system` |
