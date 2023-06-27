variable "environment" {
  default = "production"
}

variable "aws_profile" {
  description = "AWS profile to access AWS API"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "eu-west-2"
}

variable "application_storage_s3_bucket_name" {
  default = "home-server-application-storage"
}
