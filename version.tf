terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = "1.1.3"
    }
    local = {
      source = "hashicorp/local"
    }
    helm = {
      source = "hashicorp/helm"
    }
    null = {
      source = "hashicorp/null"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}
