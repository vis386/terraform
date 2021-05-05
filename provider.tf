# Configure the RKE provider
provider "rke" {
  debug = true
  log_file = "./rke.log"
}

# provider "helm" {
#   kubernetes {
#     # config_path = "${path.root}/.kube_config.yml"
#     # "${path.root}/kube_config.yml"
#     load_config_file       = false
#   }
# }

provider "helm" {
  kubernetes {
    config_path = local_file.kube_cluster_yaml.filename
  }
}
