provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.0.0"

  name = "mediawiki-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  map_public_ip_on_launch = true
  single_nat_gateway = true
  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "demo"
  }
}

module "ebs_csi_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "ebs_csi_policy"
  path        = "/"
  description = "ebs_csi_policy"

  policy = file("${path.module}/ebs_csi_policy.json")
}

module "eks_cluster" {
  source               = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v19.15.3"
  cluster_name         = "mediawiki-eks-cluster"
  cluster_version      = "1.27"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnets
  cluster_endpoint_public_access  = true
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  eks_managed_node_groups = {
    nodegroup1 = {
      iam_role_additional_policies = {policy_arn=module.ebs_csi_policy.arn}
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3a.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Terraform = "true"
    Environment = "demo"
  }
}
