# Belajar Bareng 7

## Install Openshift
* [node](#node)
* [all node](#do-on-all-node)
* [master node](#master-node)

### node
|   Role   |         FQDN        |   IP Address  |    OS    |  RAM | CPU | Disk | Partition |
|----------|---------------------|---------------|----------|------|-----|------|-----------|
|  master  | master.plowoh.lab   | 192.168.6.208 | CentOS 7 |  4G  |  4  | sda  |  root fs  |
|          |                     |               |          |      |     | sdb  |     -     | 
|  node    | node.plowoh.lab     | 192.168.6.206 | CentOS 7 |  4G  |  4  | sda  |  root fs  |
|          |                     |               |          |      |     | sdb  |     -     | 
|  infra   | infra.plowoh.lab    | 192.168.6.207 | CentOS 7 |  4G  |  4  | sda  |  root fs  |
|          |                     |               |          |      |     | sdb  |     -     | 


## do on all node
### 1. Configure Hosts and edit 
	hostnamectl set-hostname master.plowoh.lab

	cat >> /etc/hosts << EOF
	192.168.6.208   master.plowoh.lab
	192.168.6.206   node.plowoh.lab
	192.168.6.207   infra.plowoh.lab
	EOF


### 2. update package and install some dependency
	yum -y update
	yum -y install vim tmux wget git zile net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct openssl-devel httpd-tools  python-cryptography python2-pip python-devel python-passlib java-1.8.0-openjdk-headless "@Development Tools"

### 3. add configuration on NetworkManager & network interface
	vim /etc/NetworkManager/NetworkManager.conf
	...
	[main]
	dns=none
	...

	systemctl restart NetworkManager

	vim /etc/sysconfig/network-scripts/ifcfg-ens160
	...
	PEERDNS="YES"
	...

	systemctl restart network

	cat /etc/resolv.conf
	search example.lab
	nameserver 192.168.26.44

### 4. add epel repo and install docker
	yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
	yum -y install docker-1.13.1

### 5. setup docker storage using lvm
	cat >> /etc/sysconfig/docker-storage-setup << EOF
	DEVS=/dev/sdb
	VG=docker-vgo
	EOF

	sed -i '/STORAGE/d' /etc/sysconfig/docker-storage-setup

	cat /dev/null > /etc/docker/daemon.json
	cat >> /etc/docker/daemon.json << EOF
	{
	    "insecure-registries" : ["172.30.0.0/16"]
	}
	EOF

	docker-storage-setup
	lvextend -l +100%FREE /dev/docker-vgo/docker-pool

	systemctl enable docker.service --now; systemctl status docker.service

### 6. reboot server
	reboot

## master node
### 1. download ansible and install
	wget https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.7.10-1.el7.ans.noarch.rpm
	yum -y localinstall ansible-2.7.10-1.el7.ans.noarch.rpm
	ansible --version

### 2. clone openshift repository
	git clone https://github.com/openshift/openshift-ansible.git
	cd openshift-ansible && git fetch && git checkout release-3.11 && cd ..

### 3. download inventory and edit if needed
	wget https://raw.githubusercontent.com/nursanto/belajarbareng/master/belajarbareng-7/materials/inventory.ini
	vim inventory.ini

### 4. configure ssh Passwordless from master to itself and other node
	ssh-keygen
	ssh-copy-id 192.168.6.208
	ssh-copy-id 192.168.6.206
	ssh-copy-id 192.168.6.207

### 5. deploy openshift
	ansible all -i inventory.ini -m ping
	ansible-playbook -i inventory.ini openshift-ansible/playbooks/prerequisites.yml
	ansible-playbook -i inventory.ini openshift-ansible/playbooks/deploy_cluster.yml -vvv

### 6. add user to openshift
	htpasswd /etc/origin/master/htpasswd tes
	htpasswd /etc/origin/master/htpasswd myadmin
	oc adm policy add-cluster-role-to-user cluster-admin myadmin

### 7. openshift dashboard
	https://okd.plowoh.lab:8443
