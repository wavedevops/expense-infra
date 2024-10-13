```hcl
resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")

}

resource "aws_instance" "vpn" {

  key_name = aws_key_pair.vpn.key_name
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  subnet_id = element(split(",", data.aws_ssm_parameter.public_subnet_id.value), 0)
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price                      = "0"  # Automatically use the lowest price
      instance_interruption_behavior = "stop"  # Stop instead of terminate on interruption
      spot_instance_type             = "persistent"  # Keep instance running even after interruption
    }
  }


  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.env}-${var.component}"
    }
  )
}



resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "vpn"
  type    = "A"
  ttl     = "5"
  records = [aws_instance.vpn.public_ip]  # Use public_ip instead of id
}

```
```
 This Cloud front distribution
actually designed to deliver the CDN mechanism. 
CDN  for "Content delivery Network"

the geographical distance between the user
and server increases so obviously
latency also increase right
 so to reduce our latency whatever the content we want
to deliver we can place that content to
nearby End customer geographical
location

all our content with very low or minimal latency

to reduce the delays we are going to use this Cloud friend Distribution on top of this load balancer
```