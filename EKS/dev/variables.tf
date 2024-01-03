variable "project_name" {
    description = "A project name to be used in resources"
    type = string
    default = "AWS_EKS_Setup"
}

variable "component" {
    description = "A team using this project (devops, web, ios, data)"
    type = string
}

variable "environment" {
    description = "Dev/Prod/Staging will be used in AWS resources name_tag"
    type = string
}

variable "eks_version" {
    description = "Kubernetes version, will be used in AWS resources names"
    type = string
}

variable "vpc_params" {
    description = "An object with required parameters to create VPC"
    type = object({
      vpc_cidr = string
      enable_nat_gateway = bool
      one_nat_gateway_per_az = bool
      single_nat_gateway = bool
      enable_vpn_gateway = bool
      enable_flow_log = bool
    })
}