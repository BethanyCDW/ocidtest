output "iam_role_arn" {
  description = "ARN of the IAM Role created by the module"
  value       = module.ec2.iam_role_arn
}