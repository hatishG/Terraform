data "aws_availability_zones" "available" {
    state = "available"
}

locals {
  env_name = "${var.project_name}-${var.environment}-${replace(var.eks_version, ".", "-")}"
}