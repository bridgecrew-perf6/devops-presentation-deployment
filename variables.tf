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
      image_version = "b07e2ed7f7b37b8f0005a3d41a2cef3206fd9a36"
      ingress = {
        port     = 8080
        protocol = "TCP"
      }
      memory_units = 512
      name         = "DevOps-Pres"
    }
  }
}