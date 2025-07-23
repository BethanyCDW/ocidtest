resource "aws_iam_role" "ec2_creator_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.trusted_entities
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ec2_role_creator_policy" {
  name        = "${var.role_name}_policy"
  description = "Allows creating IAM roles and EC2 roles"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:PassRole",
          "ec2:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_creator_role.name
  policy_arn = aws_iam_policy.ec2_role_creator_policy.arn
}

resource "aws_iam_policy" "tf_state_access" {
  name = "${var.role_name}_tf_state_access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::bb-oicd-test",
          "arn:aws:s3:::bb-oicd-test/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:us-east-2:755213274221:table/my-tf-lock-table"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_tf_state_access" {
  role       = aws_iam_role.ec2_creator_role.name
  policy_arn = aws_iam_policy.tf_state_access.arn
}