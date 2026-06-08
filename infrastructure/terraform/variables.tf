variable "cluster" {
  description = "Cluster identifier — first segment of the Parameter Store path so multi-cluster deployments don't collide. Matches the platform stack name."
  type        = string
  default     = "cpcwood-k8s"
}

variable "environment" {
  description = "Deployment environment — third segment of the Parameter Store path"
  type        = string
  default     = "production"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-2"
}

variable "application_storage_s3_bucket_name" {
  description = "Base name for the application user-uploads S3 bucket (random suffix appended)"
  type        = string
  default     = "home-server-application-storage"
}

variable "github_repository" {
  description = "GitHub repository (owner/name) allowed to assume the CI role via OIDC"
  type        = string
  default     = "cpcwood/home-server"
}

variable "cluster_api_url" {
  description = "Public Kubernetes API endpoint baked into the CI kubeconfig — must be reachable from GitHub Actions runners"
  type        = string
  default     = "https://k8s.cpcwood.com:58497"
}
