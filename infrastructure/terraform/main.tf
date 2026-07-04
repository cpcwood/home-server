terraform {
  required_version = "~> 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.2"
    }
  }

  backend "s3" {
    encrypt      = true
    bucket       = "cpcwood-terraform-remote-state"
    key          = "home-server/production/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project     = "home-server"
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local kubeconfig: admin context for the first apply, the deploy SA's kubeconfig
# in CI (written from KUBE_CONFIG_DATA before terraform runs).
provider "kubernetes" {
  config_path = "~/.kube/config"
}
