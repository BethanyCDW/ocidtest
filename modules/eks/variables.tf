variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN"
  type        = string
}

variable "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to store Terraform state"
  type        = string
}

variable "service_account_subject" {
  description = "OIDC subject format: system:serviceaccount:<namespace>:<serviceaccount-name>"
  type        = string
}