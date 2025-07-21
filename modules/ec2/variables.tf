variable "vpc_id" {
  type        = string
  description = "The VPC ID to deploy the EC2 instance into"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID to deploy the EC2 instance into"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name for EC2 login"
}
