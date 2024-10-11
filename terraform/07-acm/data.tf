data "aws_route53_zone" "zone" {
  name         = "chowdary.cloud"
  private_zone = false
}