# Kubernetes Installation

## Node

|   Role   |         FQDN         |   IP Address  |    OS    |  RAM | CPU |
|----------|----------------------|---------------|----------|------|-----|
|  Master  | kmaster.example.com  | 172.42.42.100 | CentOS 7 |  2G  |  2  |
|  Worker  | kworker1.example.com | 172.42.42.101 | CentOS 7 |  1G  |  1  |
|  Worker  | kworker2.example.com | 172.42.42.102 | CentOS 7 |  1G  |  1  |


## instruction
[root@k8s ~]#  git clone https://github.com/nursanto/belajarbareng.git
Cloning into 'belajarbareng'...
remote: Enumerating objects: 148, done.
remote: Counting objects: 100% (148/148), done.
remote: Compressing objects: 100% (103/103), done.
remote: Total 148 (delta 36), reused 130 (delta 26), pack-reused 0
Receiving objects: 100% (148/148), 4.70 MiB | 1.39 MiB/s, done.
Resolving deltas: 100% (36/36), done.
[root@k8s tmp]# cd belajarbareng/belajarbareng-2/script/
[root@k8s script]# ls
bootstrap_kmaster_calico.sh  bootstrap_kmaster_flannel.sh  bootstrap_kmaster.sh  bootstrap_kworker.sh  bootstrap.sh  kube-flannel.yaml  Vagrantfile
[root@k8s script]#
[root@k8s script]# vagrant up
==> vagrant: A new version of Vagrant is available: 2.2.6 (installed version: 2.2.0)!
==> vagrant: To upgrade visit: https://www.vagrantup.com/downloads.html

Bringing machine 'kmaster' up with 'virtualbox' provider...
Bringing machine 'kworker1' up with 'virtualbox' provider...

	<output_omitted>

    kworker2: Running: /tmp/vagrant-shell20191024-14445-auhx8t.sh
    kworker2: [TASK 1] Join node to Kubernetes Cluster
[root@k8s script]# 
[root@k8s script]#
[root@k8s script]# ssh vagrant@kmaster     ### password: vagrant
vagrant@kmaster's password:
Last login: Mon Oct 28 09:32:06 2019
[vagrant@kmaster ~]$ kubectl cluster-info
Kubernetes master is running at https://172.42.42.100:6443
KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[vagrant@kmaster ~]$


### Source
Venkat Nagappan [GitHub - justmeandopensource](https://github.com/justmeandopensource/kubernetes/tree/master/vagrant-provisioning)
