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
      image_version = "d581d34b997ce495915e26b50273d097f2a54fd0"
      ingress = {
        port     = 8080
        protocol = "TCP"
      }
      memory_units = 512
      name         = "DevOps-Pres"
    }
  }
}