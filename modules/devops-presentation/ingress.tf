locals {
  target_group_name        = "${random_string.target_group_prefix.result}-${var.service.name}"
  target_group_target_type = "ip"
}

resource "aws_lb_target_group" "service" {
  lifecycle {
    create_before_destroy = true
  }
  connection_termination = true
  deregistration_delay = "1"
  health_check {
    healthy_threshold   = 2
    interval            = 10
    port                = var.service.ingress.port
    protocol            = var.service.ingress.protocol
    unhealthy_threshold = 2
  }
  name        = local.target_group_name
  port        = var.service.ingress.port
  protocol    = var.service.ingress.protocol
  target_type = local.target_group_target_type
  vpc_id      = var.vpc.id
}

resource "aws_lb_listener" "cluster_ingress" {
  default_action {
    target_group_arn = aws_lb_target_group.service.arn
    type             = "forward"
  }
  load_balancer_arn = var.load_balancer.arn
  port              = 80
  protocol          = var.service.ingress.protocol
}

resource "random_string" "target_group_prefix" {
  length  = 2
  special = false

  keepers = {
    name        = var.service.name
    port        = var.service.ingress.port
    protocol    = var.service.ingress.protocol
    target_type = local.target_group_target_type
  }
}