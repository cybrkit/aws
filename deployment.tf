provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Simple API Gateway deployment with S3/CDN as frontend calling Lambda through API
//module "api_gateway" {
//  source = "./api_gateway"
//  region = "${var.aws_region}"
//}

# Simple environment setup for 1 master 2 node K8S cluster - kubeadm ready for self-learning labs
//module "k8s1" {
//  source = "./k8s"
//  k8s_cidr = "192.168.0.0/16"
//  k8s_name = "cluster1"
//}