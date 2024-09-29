#### dns for cloudflare
provider "cloudflare" {
  api_token = data.aws_ssm_parameter.token.value
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}