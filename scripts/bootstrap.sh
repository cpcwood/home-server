#!/usr/bin/env bash
# One-time local bootstrap, run from a workstation with admin access. Stands up
# everything CI needs so that pushing to main can build + deploy the app.
# Idempotent — safe to re-run (e.g. to rotate the SA token or pick up changes).
# Steps, in the order the dependencies force:
#   1. Ensure the app namespace. It's cluster-scoped so Terraform can't own it
#      (CI runs terraform as the namespace-scoped deploy SA), and it must exist
#      before apply creates the deploy SA inside it — so it's created here with
#      your admin kubectl context.
#   2. terraform init + apply — AWS resources + the deploy SA/RBAC. Interactive:
#      review the plan before approving.
#   3. Push AWS_OIDC_ROLE_ARN (variable) + KUBE_CONFIG_DATA (secret) to GitHub
#      from the terraform outputs.
#
# Not included: the app deploy. Container images are built by the CI build job,
# so the first app deploy is the first push to main — nothing to helm-install
# from a clean cluster until those images exist.
#
# Prereqs: nix devshell; AWS credentials; an admin kubectl context on the
# cluster; `gh auth login`.

set -euo pipefail

# Must match local.namespace in ci.tf (home-server-<environment>).
NAMESPACE="${NAMESPACE:-home-server-production}"

cd "$(git rev-parse --show-toplevel)/infrastructure/terraform"

for cmd in gh terraform kubectl base64; do
  command -v "$cmd" >/dev/null || { echo "missing $cmd — run from the nix devshell" >&2; exit 1; }
done

# Checked up front so a successful apply isn't followed by a failed push.
gh auth status >/dev/null 2>&1 || { echo "not authenticated — run 'gh auth login'" >&2; exit 1; }

echo "→ ensuring namespace ${NAMESPACE} (kubectl context: $(kubectl config current-context))"
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f - >/dev/null

echo "→ terraform init + apply"
terraform init -input=false
terraform apply

ROLE_ARN="$(terraform output -raw github_actions_role_arn)"
CI_KUBECONFIG="$(terraform output -raw ci_kubeconfig)"

echo "→ AWS_OIDC_ROLE_ARN  (variable)"
gh variable set AWS_OIDC_ROLE_ARN --body "$ROLE_ARN"

echo "→ KUBE_CONFIG_DATA   (secret, home-server-deploy SA kubeconfig)"
printf '%s' "$CI_KUBECONFIG" | gh secret set KUBE_CONFIG_DATA
echo "    decoded server: $(printf '%s' "$CI_KUBECONFIG" | base64 -d | grep -oE 'server: [^ ]+' | head -1)"
echo "    (token + CA omitted — sensitive)"

echo
echo "Done. Verify: gh variable list && gh secret list"
