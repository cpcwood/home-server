# CI deploy identity. Every resource here is namespace-scoped, so the SA can
# manage all of them itself — which is what lets CI run `terraform apply` and
# `helm upgrade` as this SA without any cluster-wide access. The namespace
# itself is NOT managed here (it's cluster-scoped); create it once at bootstrap.
#
# First apply runs locally with an admin kubeconfig (the SA can't create
# itself). After that, CI authenticates as the SA via the ci_kubeconfig output.

locals {
  namespace = "home-server-${var.environment}"
}

resource "kubernetes_service_account_v1" "deploy" {
  metadata {
    name      = "home-server-deploy"
    namespace = local.namespace
  }
}

# k8s >= 1.24 doesn't auto-mint SA token Secrets; create one and wait for the
# token controller to populate it.
resource "kubernetes_secret_v1" "deploy_token" {
  metadata {
    name      = "home-server-deploy-token"
    namespace = local.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.deploy.metadata[0].name
    }
  }
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

# Built-in `admin` ClusterRole bound namespace-scoped — full control of core /
# apps / networking / RBAC within this namespace, nothing beyond it.
resource "kubernetes_role_binding_v1" "deploy_admin" {
  metadata {
    name      = "home-server-deploy-admin"
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.deploy.metadata[0].name
    namespace = local.namespace
  }
}

# The ESO and Gateway API CRDs don't aggregate into the built-in `admin` role,
# so grant their verbs explicitly. Without this the chart's ExternalSecret /
# Gateway / HTTPRoute resources fail to apply.
resource "kubernetes_role_v1" "deploy_crds" {
  metadata {
    name      = "home-server-deploy-crds"
    namespace = local.namespace
  }
  rule {
    api_groups = ["external-secrets.io"]
    resources  = ["externalsecrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["gateways", "httproutes"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding_v1" "deploy_crds" {
  metadata {
    name      = "home-server-deploy-crds"
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.deploy_crds.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.deploy.metadata[0].name
    namespace = local.namespace
  }
}
