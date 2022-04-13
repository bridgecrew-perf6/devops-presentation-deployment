locals {
  image = join(":", [var.devops_presentation.service.image_name, var.devops_presentation.service.image_version])
  service = {
    cpu_units    = var.devops_presentation.service.cpu_units
    image_name   = local.image
    ingress      = var.devops_presentation.service.ingress
    memory_units = var.devops_presentation.service.memory_units
    name         = var.devops_presentation.service.name
  }
}

data "aws_lb" "ingress" {
  name = var.compute_cluster.ingress.name
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["myvpc"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_iam_role" "task_execution_role" {
  name = var.compute_cluster.task_execution_role
}

module "devops-presentation" {
  source = "./modules/devops-presentation"

  cluster = {
    name                    = var.compute_cluster.name
    task_execution_role_arn = data.aws_iam_role.task_execution_role.arn
  }
  load_balancer = {
    arn = data.aws_lb.ingress.arn
  }
  service = local.service
  vpc = {
    id              = data.aws_vpc.vpc.id
    private_subnets = data.aws_subnets.private_subnets.ids
  }
}