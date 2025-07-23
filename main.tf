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
  source            = "./modules/eks"
  region            = "us-east-1"
  cluster_name      = "my-eks-cluster"
  oidc_provider_arn = module.oicd.oidc_provider_arn
  oidc_subject      = module.oicd.oidc_subject
  eks_node_role_arn = "arn:aws:iam::059134021762:role/EKSNodeRole"
}