module "db" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "${var.component}-${var.env}" #expense-dev

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "transactions" #default schema for expense project
  username = "root"
  port     = "3306"

  vpc_security_group_ids = [data.aws_ssm_parameter.database_sg_id.value]

  # DB subnet group
  db_subnet_group_name = data.aws_ssm_parameter.db_subnet_id.value

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.component}-${var.env}"
    }
  )

  manage_master_user_password = false
  password = "ExpenseApp1"
  skip_final_snapshot = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

}

# module "record" {
#   source = "../../moduels/03.dns"
#   zone_id = data.cloudflare_zone.zone.id
#   component = "db"
#   dns_record = module.db.db_instance_address
#   record_type = "CNAME"
# }
resource "cloudflare_record" "db" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "db-${var.env}"
  content = module.db.db_instance_address
  type    = "CNAME"
  ttl     = 60
  proxied = false
#   allow_overwrite = true

  # Lifecycle rules to create before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}