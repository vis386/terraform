######


resource rke_cluster "dev_cluster" {
  cluster_name = "Management_Cluster"
  cluster_yaml = file("cluster.yaml")
  ignore_docker_version = true
  ssh_agent_auth = true
  kubernetes_version = "v1.19.2-rancher1-1"
  # nodes {
  #   address = "xsj-dvaprnchr01.xilinx.com"
  #   internal_address = "10.18.28.241"
  #   user    = "akaithe"
  #   role    = ["controlplane", "worker", "etcd"]
  #   ssh_key_path = file("~/.ssh/id_rsa")
  # }
  # nodes {
  #   address = "xsj-dvaprnchr02.xilinx.com"
  #   internal_address = "10.18.28.242"
  #   user    = "akaithe"
  #   role    = ["controlplane", "worker", "etcd"]
  #   ssh_key_path = file("~/.ssh/id_rsa")
  # }
  # nodes {
  #   address = "xsj-dvaprnchr03.xilinx.com"
  #   internal_address = "10.18.28.243"
  #   user    = "akaithe"
  #   role    = ["controlplane", "worker", "etcd"]
  #   ssh_key_path = file("~/.ssh/id_rsa")
  # }
  # upgrade_strategy {
  #     drain = true
  #     max_unavailable_worker = "20%"
  # }
  addons_include = [
    "https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml",
    "https://gist.githubusercontent.com/superseb/499f2caa2637c404af41cfb7e5f4a938/raw/930841ac00653fdff8beca61dab9a20bb8983782/k8s-dashboard-user.yml",
  ]
}

# ssh-add ~/.ssh/id_rsa
# ssh-add -L


###############################################################################
# If you need kubeconfig.yml for using kubectl, please uncomment follows.
###############################################################################
resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config.yml"
  content  = rke_cluster.dev_cluster.kube_config_yaml
}
