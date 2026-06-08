output "application_storage_s3_bucket_id" {
  description = "Bucket holding application user uploads"
  value       = aws_s3_bucket.application_storage_s3.id
}

output "github_actions_role_arn" {
  description = "Set this as the AWS_OIDC_ROLE_ARN repository variable in GitHub"
  value       = aws_iam_role.github_actions.arn
}

output "ci_kubeconfig" {
  description = "Base64 kubeconfig for the home-server-deploy SA — bootstrap.sh pushes it as the KUBE_CONFIG_DATA repo secret."
  sensitive   = true
  value = base64encode(yamlencode({
    apiVersion        = "v1"
    kind              = "Config"
    "current-context" = "home-server-deploy"
    clusters = [{
      name = var.cluster
      cluster = {
        server                       = var.cluster_api_url
        "certificate-authority-data" = base64encode(kubernetes_secret_v1.deploy_token.data["ca.crt"])
      }
    }]
    users = [{
      name = "home-server-deploy"
      user = { token = kubernetes_secret_v1.deploy_token.data["token"] }
    }]
    contexts = [{
      name = "home-server-deploy"
      context = {
        cluster   = var.cluster
        user      = "home-server-deploy"
        namespace = local.namespace
      }
    }]
  }))
}

output "parameter_arns" {
  description = "AWS Parameter Store ARNs that External Secrets Operator pulls from"
  value = {
    app         = aws_ssm_parameter.app.arn
    app_storage = aws_ssm_parameter.app_storage.arn
    db          = aws_ssm_parameter.db.arn
    build       = aws_ssm_parameter.build.arn
  }
}
