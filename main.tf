module "oicd" {
  source = "./modules/oicd"
}
module "ec2" {
  source          = "./modules/ec2"
  role_name       = var.role_name
  trusted_entities = var.trusted_entities
}

module "eks_namespace_role" {
  source                 = "./modules/eks"
  role_name              = "eks-namespace-role"
  oidc_provider_url = module.oicd.oidc_provider_url
  oidc_provider_arn = module.oicd.oidc_provider_arn
  eks_cluster_arn         = "arn:aws:eks:us-east-2:755213274221:cluster/my-eks-cluster"
  s3_bucket_arn          = "arn:aws:s3:::bb-oicd-test"
  service_account_subject = "system:serviceaccount:kube-system:my-sa"
}