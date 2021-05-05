
locals {
  name               = var.name
  rancher_version    = var.rancher_version
  kubernetes_version = var.kubernetes_version
  le_email           = var.email
  domain             = var.domain
}

variable "rancher_password" {
type = string
description = "Your admin password"
default = "K8spassword@"
}

