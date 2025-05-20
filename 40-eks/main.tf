resource "aws_key_pair" "eks" {
  key_name   = "expense-eks"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8WPolbkCwqSA5jKWoicyny4hKXeMhRZDHFc8F0dZP1mlgiGCUxgTvEoEOzcLlwKwOpoJ46H6o984o2JxU5sEAJf2nMYUYi42x/+5Kq+Ylxf0fqorblw/xMkHeycH/eA/l+iU1KJal5gIx1gBDPP2Wbnfp+q+kLKkbHjWEQtOohbyxH/NDWGeyYZt2H0qM7bcezRF9ObpVVCIrfZpubj20YzOtXj7YH9+7AYN60USg92qFx+W9+7b5Pr3oO6QU1g75o1bjI0JeFg8mGHOoqNSoZiQw513CTd/K16LDdSL2eisyudVzLrRnG8qB5QRWySdOHO6TnxJs0HDLH+NHXoRtYufULi6tViTe2HpyKHWPKZp+pjZIfv/FNBiXAqzrbe7c6Wv1+hBQkRbA75KuKkBW0vWqE4B4O3OBx+0VIuI99NL3LrQsf+pp9Dje16oxFmLMaenSE2VRRQL09/id6mnXb7fgKKJ+PJWQFwxo/pHl+hn0I61Yu4fSME8RLaoIbJ0= Prudviraj@LAPTOP-P2GU3L4D"

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.32" # later we upgrade 1.32
  create_node_security_group = false
  create_cluster_security_group = false
  cluster_security_group_id = local.eks_control_plane_sg_id
  node_security_group_id = local.eks_node_sg_id

  #bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    metrics-server = {}
  }

  # Optional
  cluster_endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    /* blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["m5.xlarge"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    } */

    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #ami_type       = "AL2_x86_64"
      instance_types = ["m5.xlarge"]
      key_name = aws_key_pair.eks.key_name

      min_size     = 2
      max_size     = 10
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoadBalancingPolicy = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
        Name = local.name
    }
  )
}