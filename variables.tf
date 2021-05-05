variable "rancher_version" {
type = string
description = "Rancher Version"
default = "2.5"
}

variable "kubernetes_version" {
type = string
description = "Kubernetes Version"
default = "$K8S_VERSION"
}

variable "domain" {
type = string
description = "Your domain name"
default = "xilinx.com"
}


variable "name" {
type = string
description = "Rancher Management Cluster Name"
default = "xsj-rancherdev"
}


variable "ui_password" {
type = string
description = "Your password"
default = "k8s123!"
# default = "$UI_PASSWORD"
}




variable "email" {
type = string
description = "Email Address"
default = "akaithe@xilinx.com"
}
