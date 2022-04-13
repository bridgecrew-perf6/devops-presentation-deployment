locals {
  definitions = [{
    name      = var.service.name
    image     = var.service.image_name
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = var.service.name
        awslogs-region        = data.aws_region.current.id
        awslogs-stream-prefix = var.service.name
      }
    }
    portMappings = [
      {
        containerPort = var.service.ingress.port
        hostPort      = var.service.ingress.port
      },
      {
        containerPort = local.nginx.port
        hostPort      = local.nginx.port
      }
    ]
  }]
  nginx = {
    port     = 80
    protocol = "TCP"
  }
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "devops-presentation" {
  container_definitions    = jsonencode(local.definitions)
  cpu                      = var.service.cpu_units
  execution_role_arn       = var.cluster.task_execution_role_arn
  family                   = var.service.name
  memory                   = var.service.memory_units
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_security_group" "service_ingress" {
  description = "Attached to services that require connection to the ingress load balancer."
  name        = var.service.name
  tags = {
    Name = var.service.name
  }
  vpc_id = var.vpc.id
}

resource "aws_security_group_rule" "load_balancer_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = var.service.ingress.port
  protocol          = var.service.ingress.protocol
  security_group_id = aws_security_group.service_ingress.id
  to_port           = var.service.ingress.port
  type              = "ingress"
}

resource "aws_security_group_rule" "load_balancer_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Grants egress access to everything"
  from_port         = 0
  protocol          = "ALL"
  security_group_id = aws_security_group.service_ingress.id
  to_port           = 0
  type              = "egress"
}

resource "aws_ecs_service" "devops-presentation" {
  cluster       = var.cluster.name
  desired_count = 1
  launch_type   = "FARGATE"
  load_balancer {
    container_name   = var.service.name
    container_port   = var.service.ingress.port
    target_group_arn = aws_lb_target_group.service.arn
  }
  name = var.service.name
  network_configuration {
    security_groups = [aws_security_group.service_ingress.id]
    subnets         = var.vpc.private_subnets
  }
  task_definition = aws_ecs_task_definition.devops-presentation.arn
}

