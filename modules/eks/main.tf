#This code provisions the EKS IAM role, automatically updates aws-auth with RBAC access, and prepares for namespace provisioning via terraform, kubectl, or helm
provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# 1. IAM Role for GitHub Actions
resource "aws_iam_role" "eks_namespace_provisioner" {
  name = "eks-namespace-provisioner"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub" = var.oidc_subject
        }
      }
    }]
  })
}

# 2. IAM Policy: DescribeCluster (Kubernetes Provider needs this)
resource "aws_iam_policy" "eks_namespace_policy" {
  name        = "EKSNamespaceProvisionPolicy"
  description = "Allows DescribeCluster"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["eks:DescribeCluster"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.eks_namespace_provisioner.name
  policy_arn = aws_iam_policy.eks_namespace_policy.arn
}

# 3. Automatically configure aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_namespace_provisioner.arn
        username = "namespace-provisioner"
        groups   = ["system:masters"]
      },
      {
        rolearn  = var.eks_node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
  }

  lifecycle {
    ignore_changes = [
      data # so we don't overwrite it if managed elsewhere
    ]
  }
}

