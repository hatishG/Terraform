project_name = "AWS_EKS_Setup"
component = "DevOps"
environment = "dev"
eks_version = "1.27"
vpc_params = {
  vpc_cidr = "10.1.0.0/16"
  enable_nat_gateway = true
  one_nat_gateway_per_az = true
  single_nat_gateway = false
  enable_vpn_gateway = false
  enable_flow_log = false
}
