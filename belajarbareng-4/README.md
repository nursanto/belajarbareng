# Belajar Bareng 4

## Table of Contents
* [Services of type LoadBalancer](#Services-of-type-LoadBalancer)
* [Nginx Ingress](#Nginx-Ingress)
* [Managing State with Deployments](#Managing-State-with-Deployments)
* [Jobs and Cron Jobs](#Jobs-and-Cron-Jobs)
* [Scheduling](#Scheduling)
* [Volumes and Data](#Volumes-and-Data)


### APIs and Access

[root@k8s ~]# kubectl cluster-info
Kubernetes master is running at https://172.42.42.100:6443
KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   178m
[root@k8s ~]#
