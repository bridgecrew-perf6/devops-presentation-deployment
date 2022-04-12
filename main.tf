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
    arn         = data.aws_lb.ingress.arn
  }
  service = var.devops_presentation.service
  vpc = {
    id              = data.aws_vpc.vpc.id
    private_subnets = data.aws_subnets.private_subnets.ids
  }
}