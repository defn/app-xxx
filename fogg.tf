provider "aws" {
}

module "app" {
  source = "../module-aws-app"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"
}

module "default" {
  source = "../module-aws-service"

  bucket_remote_state = "${var.bucket_remote_state}"
  context_org = "${var.context_org}"
  context_env = "${var.context_env}"

  cidr_blocks = "${var.cidr_blocks}"

  az_count = "${var.az_count}"
}
