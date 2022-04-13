variable "compute_cluster" {
  description = "Configuration to create the compute cluster."
  default = {
    ingress = {
      name = "mycluster-ingress"
    }
    name                = "mycluster"
    task_execution_role = "TaskExecutionRole"
  }
}

variable "devops_presentation" {
  description = "DevOps presentation service configuration"
  default = {
    service = {
      cpu_units     = 256
      image_name    = "juanmacvega/devops-presentation"
      image_version = "d5288f6d61ec850da17efe8b3939da5dd309006d"
      ingress = {
        port     = 8080
        protocol = "TCP"
      }
      memory_units = 512
      name         = "DevOps-Pres"
    }
  }
}