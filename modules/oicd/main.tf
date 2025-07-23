provider "aws" {
  region = "us-east-1"
}

#Create OICD Provider for Github. DO this once per AWS account
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's SHA-1 fingerprint
}

#Create the IAM Role in AWS. This role will be assumed by Github Actions
resource "aws_iam_role" "github_oidc_role" {
  name = "github-actions-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            # Restrict access to specific GitHub repos/orgs
            "token.actions.githubusercontent.com:sub" = "BethanyCDW/ocidtest/tree/main" #replace org/repo/branch
          }
        }
      }
    ]
  })

  tags = {
    Name = "GitHubActionsOIDC"
  }
}

#IAM policy least privilege
resource "aws_iam_policy" "github_oidc_least_privilege" {
  name        = "github-oidc-least-privilege"
  description = "Least privilege policy for GitHub OIDC role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "EKSAccess",
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:CreateNamespace",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ],
        Resource = "*"
      },
      {
        Sid    = "S3StateAccess",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = "*"
      },
      {
        Sid    = "IAMPassRole",
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

#Attach the IAM Policy to the role
resource "aws_iam_role_policy_attachment" "github_oidc_attach_least_privilege" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.github_oidc_least_privilege.arn
}