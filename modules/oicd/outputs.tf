output "oidc_role_arn" {
  description = "ARN of the IAM role assumed by GitHub via OIDC"
  value       = aws_iam_role.github_oidc_role.arn
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "oidc_subject" {
  description = "OIDC subject (sub condition in trust policy)"
  value       = "repo:your-org/your-repo:ref:refs/heads/main"
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.github.url
}
