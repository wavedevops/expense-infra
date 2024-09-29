module "vpn" {
  source      = "../../moduels/02.sg"
  component   = "vpn"
  env         = var.env
  common_tags = var.common_tags
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  project     = var.project
}
