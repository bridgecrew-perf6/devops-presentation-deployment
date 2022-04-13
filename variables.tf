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
      image_version = "bcf616bcf62684a238520680902906c240707df6"
      ingress = {
        port     = 8080
        protocol = "TCP"
      }
      memory_units = 512
      name         = "DevOps-Pres"
    }
  }
}