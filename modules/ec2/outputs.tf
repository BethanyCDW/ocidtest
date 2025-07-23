output "iam_role_arn" {
  description = "ARN of the IAM Role"
  value       = aws_iam_role.ec2_creator_role.arn
}