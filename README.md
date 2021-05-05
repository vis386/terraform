RKE Terraform
=============


## Local/BuildServer Setup : 
1. Build Server to be installed with  terraform '>0.13'
https://learn.hashicorp.com/tutorials/terraform/install-cli

2.  kubectl 
https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/


 If you already have terraform on your local, please follow below upgrade instructions
Terraform upgrade - update registry  https://registry.terraform.io/providers/rancher/rke/latest/docs/guides/upgrade_to_0.13

## Servers required for current setup :
OS: Centos 7 or higher

 3 VM's for HA kube cluster ( ex: xsj-dvaprnchr0{1-3}.xilinx.com ) <br />
 1 VM for Nginx LoadBalancer 



## What's in the repo :  Simplified steps to Automate and build HA Rancher cluster ( Downstream cluster's not part of it)
1. Ansible-playbook - to run pre-req's
2. Terraform RKE cluster  - Spin up 3 node K8s cluster.
3. export kube config yaml - to connect to Cluster via kubectl <br />
		export KUBECONFIG=$(pwd)/kube_config_cluster.yml <br />
    Check all nodes/pods. <br />
		kubectl get pods --all-namespaces ; kubectl get nodes
4. Post Steps of k8s cluater - Build Rancher on rke cluster with CA cert
5. Create Nginx Load balancer  - Isolated step on different VM ( if setup is on Cloud, replace it with Elastic LoadBalancer)





### Foreman Run - Currently using dev foreman server - xsj-dvapcfg01 
 -p -> Playbook name
 -s -> set of servers to run on 
 Current limitation for foreman setup is to have playbook in Single file. Instead of role/repo.

	/group/compres/bssa/Linux/ansible/script/playbook_job.py -p rke_prereq.yaml -s 'name > xsj-dvaprnchr01 and name < xsj-dvaprnchr04'

### Nginx LoadBalancer - Make sure Docker is installed. If not, you can run above ansible-playbook on Nginx VM to install docker.
Get SSL certs before hand ; And nginx conf is present on additional folder

	docker run -d --restart=unless-stopped --name=nginxlb  -p 80:80 -p 443:443   -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf  -v /etc/nginx/ssl/xsj-rancherdev.pem:/etc/nginx/ssl/xsj-rancherdev.pem -v /etc/nginx/ssl/xsj-rancherdev.key:/etc/nginx/ssl/xsj-rancherdev.key nginx:1.14

### Terraform Run
    terrform init
    terraform plan
    terraform apply

### Messed up w/ terraform config and Installation : clean up 3 VM's with below docker cleanup commands -  last resort
	docker rm -f $(docker ps -qa)
	docker rmi -f $(docker images -q)
	docker volume rm $(docker volume ls -q)

	for mount in $(mount | grep tmpfs | grep '/var/lib/kubelet' | awk '{ print $3 }') /var/lib/kubelet /var/lib/rancher; do umount $mount; done

	sudo rm -rf /etc/kubernetes

### Note : 
Pre-requisite of Rancher terformra is to have Nginx load balancer ready first, <br />
 If not, Rancher setup fails after creating RKE cluster and keeps looking for LB Enpoint 

Need CA cert for Nginx load balancer

Enpoint - https://xsj-rancherdev.xilinx.com/ 

### Known Issue
Whenever node is restarted ; its not bringing up docker - so might have to restart docker 
systemctl restart docker.service

