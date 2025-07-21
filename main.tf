module "oicd" {
  source = "./modules/oicd"
}
module "ec2" {
  source = "./modules/ec2"
  vpc_id    = "vpc-id"
  subnet_id = "subnet-id"
  key_name  = "my-ssh-key"
}
module "eks" {
  source = "./modules/eks"
  region             = "us-east-1"
  cluster_name       = "my-eks-cluster"
  oidc_provider_arn  = "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
  oidc_subject       = "repo:your-org/your-repo:ref:refs/heads/main"
  eks_node_role_arn  = "arn:aws:iam::123456789012:role/EKSNodeRole"
}