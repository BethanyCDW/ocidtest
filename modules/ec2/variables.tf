variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
  default     = "ec2-creator-role"
}

variable "trusted_entities" {
  description = "The principals (AWS account, user, or service) allowed to assume this role"
  type        = list(string)
  default     = ["arn:aws:iam::755213274221:saivana-gh-role"] # Replace with your trusted entity
}
variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}