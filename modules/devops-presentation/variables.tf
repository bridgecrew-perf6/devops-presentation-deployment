variable "cluster" {
  description = "ECS cluster the service is deployed in."
  nullable    = false
  type = object({
    name                    = string
    task_execution_role_arn = string
  })
}

variable "load_balancer" {
  description = "Load balancer used for ingress communication with the cluster."
  type = object({
    arn = string
  })
}

variable "service" {
  description = "Service configuration settings."
  nullable    = false
  type = object({
    cpu_units  = number
    image_name = string
    ingress = object({
      port     = number
      protocol = string
    })
    memory_units = number
    name         = string
  })
}

variable "vpc" {
  description = "VPC related configuration required to configure the cluster."
  type = object({
    id              = string
    private_subnets = list(string)
  })
}
