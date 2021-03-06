provider "aws" {
}

module "app" {
  source = "../module-aws-app"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  app_name = "${var.app_name}"
}

variable asg_min { default = 0 }
variable asg_max { default = 0 }

module "default" {
  source = "../module-aws-service"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  cidr_blocks = "${var.cidr_blocks}"

  az_count = "${var.az_count}"
  nat_count = "${var.nat_count}"
  igw_count = "${var.igw_count}"

  app_name = "${var.app_name}"
  service_name = "default"
  app_service_name = "${var.app_name}-default"

  asg_min = "${var.asg_min}"
  asg_max = "${var.asg_max}"
}

output "instances" {
  value = [ "${module.default.instances}" ]
}

output "app_sg_id" {
  value = "${module.app.sg_id}"
}

output "default_sg_id" {
  value = "${module.default.sg_id}"
}

resource "aws_route53_record" "app" {
  zone_id = "${module.default.zone_id}"
  name = "${var.app_name}"
  type = "A"

  alias {
    name = "${module.default.elb_dns_name}"
    zone_id = "${module.default.elb_zone_id}"
    evaluate_target_health = false
  }
}
