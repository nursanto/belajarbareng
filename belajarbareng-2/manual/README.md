# Kubernetes Installation

## Node

|       Hostname       |   IP Address  |
|----------------------|---------------|
| kmaster.example.com  | 172.42.42.100 |
| kworker1.example.com | 172.42.42.101 |
| kworker2.example.com | 172.42.42.102 |

## Do on all nodes

#### Update hosts file
	cat >>/etc/hosts<<EOF
	172.42.42.100 kmaster.example.com kmaster
	172.42.42.101 kworker1.example.com kworker1
	172.42.42.102 kworker2.example.com kworker2
    EOF

#### Install docker from Docker-ce repository
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install -y docker-ce

#### Enable docker service
	systemctl enable docker
	systemctl start docker
	systemctl status docker

#### Disable SELinux
	setenforce 0
	sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

#### Stop and disable firewalld
	systemctl disable firewalld
	systemctl stop firewalld

#### Add sysctl settings
	cat >>/etc/sysctl.d/kubernetes.conf<<EOF
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system

#### Disable swap
	sed -i '/swap/d' /etc/fstab
	swapoff -a

#### Add yum repo file for Kubernetes
	cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
	        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	EOF

#### Install Kubernetes
	yum install -y kubeadm kubelet kubectl

#### Start and Enable kubelet service
	systemctl enable kubelet
	systemctl start kubelet

#### Enable ssh password authentication
	sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
	systemctl reload sshd

#### Set Root password
	echo "kubeadmin" | passwd --stdin root

#### Update vagrant user's bashrc file
	echo "export TERM=xterm" >> /etc/bashrc


## Do on master node
#### Initialize Kubernetes
	kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log

#### Copy Kube admin config
	mkdir /root/.kube
	cp /etc/kubernetes/admin.conf /root/.kube/config

#### Deploy calico network
	kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml

#### Generate Cluster join command
	kubeadm token create --print-join-command > joincluster.sh
	scp joincluster.sh root@kworker1:.
	scp joincluster.sh root@kworker2:.

## Do on worker nodes
#### Join worker nodes to the Kubernetes cluster
	chmod +x joincluster.sh
	./joincluster.sh


### Source
Venkat Nagappan [GitHub - justmeandopensource](https://github.com/justmeandopensource/kubernetes/tree/master/vagrant-provisioning)
