resource "null_resource" "cert-manager-crds" {
  provisioner "local-exec" {
    command = <<EOF
# sleep 60
# export KUBECONFIG="${path.root}/kube_config.yml"
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
helm repo update
EOF

    environment = {
      KUBECONFIG = local_file.kube_cluster_yaml.filename
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
mv ${path.root}/kube_config.yml ${path.root}/kube_config.yml_old
EOD
  
    # on_failure = continue

 }
  # depends_on = [
  #   rke_cluster.dev_cluster,
  #   local_file.kube_cluster_yaml
  # ]
}



# install rancher
resource "helm_release" "rancher" {
  name      = "xsj-rancherdev"
  # repository = "https://releases.rancher.com/server-charts/latest"
  chart     = "rancher-latest/rancher"
  # version   = local.rancher_version
  namespace = "cattle-system"
  create_namespace = "true"
  set {
    name  = "hostname"
    value = "${local.name}.${local.domain}"
  }

  set {
    name  = "ingress.tls.source"
    value = "secret"
  }
  depends_on = [
    null_resource.cert-manager-crds
  ]


}

resource "null_resource" "wait_for_rancher" {
  provisioner "local-exec" {
    command = <<EOF
while [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; do
    subject=$(curl -vk -m 2 "https://$${RANCHER_HOSTNAME}/ping" 2>&1 | grep "subject:")
    echo "Cert Subject Response: $${subject}"
    if [ "$${subject}" != "*  subject: CN=$${RANCHER_HOSTNAME}" ]; then
      sleep 10
    fi
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF


    environment = {
      RANCHER_HOSTNAME = "${local.name}.${local.domain}"
      TF_LINK          = helm_release.rancher.name
    }
  }
}


# Provider bootstrap config with alias
provider "rancher2" {
  alias = "bootstrap"

  api_url   = "https://${local.name}.${local.domain}"
  bootstrap = true
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  depends_on = [null_resource.wait_for_rancher]
  password = var.rancher_password
}


