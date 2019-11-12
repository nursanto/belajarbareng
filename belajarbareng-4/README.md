# Belajar Bareng 4

## Table of Contents
* [Services of type LoadBalancer](#Services-of-type-LoadBalancer)
* [Nginx Ingress](#Nginx-Ingress)



### Services of type LoadBalancer
[https://metallb.universe.tf/](https://metallb.universe.tf/])

	[root@k8s ~]# kubectl cluster-info
	Kubernetes master is running at https://172.42.42.100:6443
	KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

	To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   178m
	[root@k8s ~]#

	[root@k8s ~]# kubectl run nginx --image nursanto/nginx-hello-world --replicas 2
	kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
	deployment.apps/nginx created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                        READY   STATUS    RESTARTS   AGE
	pod/nginx-c9d5dd458-dbgdb   1/1     Running   0          20s
	pod/nginx-c9d5dd458-nx5tl   1/1     Running   0          20s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h43m

	NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/nginx   2/2     2            2           20s

	NAME                              DESIRED   CURRENT   READY   AGE
	replicaset.apps/nginx-c9d5dd458   2         2         2       20s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl expose deployment nginx --port 80 --type LoadBalancer
	service/nginx exposed
	[root@k8s ~]# kubectl get service
	NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
	kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP        3h44m
	nginx        LoadBalancer   10.108.138.129   <pending>     80:30681/TCP   6s
	[root@k8s ~]#
	[root@k8s ~]# wget https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
	[root@k8s ~]#
	[root@k8s ~]# kubectl create -f metallb.yaml
	namespace/metallb-system created
	podsecuritypolicy.policy/speaker created
	serviceaccount/controller created
	serviceaccount/speaker created
	clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
	clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
	role.rbac.authorization.k8s.io/config-watcher created
	clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
	clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
	rolebinding.rbac.authorization.k8s.io/config-watcher created
	daemonset.apps/speaker created
	deployment.apps/controller created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get namespaces
	NAME              STATUS   AGE
	default           Active   4h34m
	kube-node-lease   Active   4h34m
	kube-public       Active   4h34m
	kube-system       Active   4h34m
	metallb-system    Active   24s
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n metallb-system
	NAME                              READY   STATUS    RESTARTS   AGE
	pod/controller-65895b47d4-hdxbc   1/1     Running   0          31s
	pod/speaker-gzljp                 1/1     Running   0          31s
	pod/speaker-hd9qn                 1/1     Running   0          31s
	pod/speaker-xpfs7                 1/1     Running   0          31s

	NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
	daemonset.apps/speaker   3         3         3       3            3           beta.kubernetes.io/os=linux   32s

	NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/controller   1/1     1            1           32s

	NAME                                    DESIRED   CURRENT   READY   AGE
	replicaset.apps/controller-65895b47d4   1         1         1       32s
	[root@k8s ~]#
	[root@k8s ~]# kubectl get service
	NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
	kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP        4h35m
	nginx        LoadBalancer   10.108.138.129   <pending>     80:30681/TCP   51m
	[root@k8s ~]#
	[root@k8s ~]# cat >> metallb-ip-pool.yaml <<EOF
	apiVersion: v1
	kind: ConfigMap
	metadata:
	  namespace: metallb-system
	  name: config
	data:
	  config: |
	    address-pools:
	    - name: default
	      protocol: layer2
	      addresses:
	      - 172.42.42.200-172.42.42.210
	EOF
	[root@k8s ~]#
	[root@k8s ~]# cat metallb-ip-pool.yaml
	apiVersion: v1
	kind: ConfigMap
	metadata:
	  namespace: metallb-system
	  name: config
	data:
	  config: |
	    address-pools:
	    - name: default
	      protocol: layer2
	      addresses:
	      - 172.42.42.200-172.42.42.210
	[root@k8s ~]#
	[root@k8s ~]# kubectl create -f metallb-ip-pool.yaml
	configmap/config created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                        READY   STATUS    RESTARTS   AGE
	pod/nginx-c9d5dd458-dbgdb   1/1     Running   0          57m
	pod/nginx-c9d5dd458-nx5tl   1/1     Running   0          57m

	NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)        AGE
	service/kubernetes   ClusterIP      10.96.0.1        <none>          443/TCP        4h40m
	service/nginx        LoadBalancer   10.108.138.129   172.42.42.200   80:30681/TCP   56m

	NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/nginx   2/2     2            2           57m

	NAME                              DESIRED   CURRENT   READY   AGE
	replicaset.apps/nginx-c9d5dd458   2         2         2       57m
	[root@k8s ~]#
	[root@k8s ~]# for i in {1..10};do curl 172.42.42.200;done
	<h1>Hello world from nginx-c9d5dd458-dbgdb!</h1>
	<h1>Hello world from nginx-c9d5dd458-nx5tl!</h1>
	<h1>Hello world from nginx-c9d5dd458-dbgdb!</h1>
	<h1>Hello world from nginx-c9d5dd458-nx5tl!</h1>
	<h1>Hello world from nginx-c9d5dd458-nx5tl!</h1>
	<h1>Hello world from nginx-c9d5dd458-nx5tl!</h1>
	<h1>Hello world from nginx-c9d5dd458-nx5tl!</h1>
	<h1>Hello world from nginx-c9d5dd458-dbgdb!</h1>
	<h1>Hello world from nginx-c9d5dd458-dbgdb!</h1>
	<h1>Hello world from nginx-c9d5dd458-dbgdb!</h1>
	[root@k8s ~]#
	[root@k8s ~]# kubectl run nginx-2 --image nursanto/nginx-hello-world --replicas 2
	kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
	deployment.apps/nginx-2 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl expose deployment nginx-2 --port 80 --type LoadBalancer
	service/nginx-2 exposed
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -l run=nginx-2 --show-labels
	NAME                          READY   STATUS    RESTARTS   AGE   LABELS
	pod/nginx-2-df689f564-kn9c2   1/1     Running   0          89s   pod-template-hash=df689f564,run=nginx-2
	pod/nginx-2-df689f564-p8gv6   1/1     Running   0          89s   pod-template-hash=df689f564,run=nginx-2

	NAME              TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE   LABELS
	service/nginx-2   LoadBalancer   10.102.5.11   172.42.42.201   80:32435/TCP   58s   run=nginx-2

	NAME                      READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
	deployment.apps/nginx-2   2/2     2            2           89s   run=nginx-2

	NAME                                DESIRED   CURRENT   READY   AGE   LABELS
	replicaset.apps/nginx-2-df689f564   2         2         2       89s   pod-template-hash=df689f564,run=nginx-2
	[root@k8s ~]#
	[root@k8s ~]# for i in {1..10};do curl 172.42.42.201;done
	<h1>Hello world from nginx-2-df689f564-kn9c2!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-kn9c2!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-kn9c2!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-p8gv6!</h1>
	<h1>Hello world from nginx-2-df689f564-kn9c2!</h1>
	[root@k8s ~]#
	[root@k8s deployments]# kubectl delete deployment.apps/nginx deployment.apps/nginx-2 service/nginx service/nginx-2
	deployment.apps "nginx" deleted
	deployment.apps "nginx-2" deleted
	service "nginx" deleted
	service "nginx-2" deleted
	[root@k8s deployments]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5h10m
	[root@k8s deployments]#


### Nginx Ingress
[https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md#bare-metal](https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md#bare-metal)
[https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/baremetal.md](https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/baremetal.md)

	[root@k8s ~]# mkdir nginx-ingress
	[root@k8s ~]#
	[root@k8s nginx-ingress]#
	[root@k8s nginx-ingress]# wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

			<output_omitted>

	[root@k8s nginx-ingress]# wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml

			<output_omitted>

	[root@k8s nginx-ingress]#
	[root@k8s nginx-ingress]# ls
	mandatory.yaml  service-nodeport.yaml
	[root@k8s nginx-ingress]#
	[root@k8s nginx-ingress]# kubectl create -f mandatory.yaml
	namespace/ingress-nginx created
	configmap/nginx-configuration created
	configmap/tcp-services created
	configmap/udp-services created
	serviceaccount/nginx-ingress-serviceaccount created
	clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
	role.rbac.authorization.k8s.io/nginx-ingress-role created
	rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
	clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
	deployment.apps/nginx-ingress-controller created
	[root@k8s nginx-ingress]# kubectl create -f service-nodeport.yaml
	service/ingress-nginx created
	[root@k8s nginx-ingress]#
	[root@k8s nginx-ingress]# kubectl get namespaces
	NAME              STATUS   AGE
	default           Active   26h
	ingress-nginx     Active   36s
	kube-node-lease   Active   26h
	kube-public       Active   26h
	kube-system       Active   26h
	metallb-system    Active   21h
	[root@k8s nginx-ingress]# kubectl -n ingress-nginx get all
	NAME                                            READY   STATUS    RESTARTS   AGE
	pod/nginx-ingress-controller-568867bf56-c5mjm   1/1     Running   0          45s

	NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
	service/ingress-nginx   NodePort   10.104.100.86   <none>        80:31552/TCP,443:30369/TCP   34s

	NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/nginx-ingress-controller   1/1     1            1           45s

	NAME                                                  DESIRED   CURRENT   READY   AGE
	replicaset.apps/nginx-ingress-controller-568867bf56   1         1         1       45s
	[root@k8s nginx-ingress]# cd
	[root@k8s ~]# yum -y install haproxy
	Loaded plugins: fastestmirror

		<output_omitted>


	Complete!
	[root@k8s ~]#
	[root@k8s ~]# vim /etc/haproxy/haproxy.cfg
	[root@k8s ~]#
	[root@k8s tes-2]# tail /etc/haproxy/haproxy.cfg
	#---------------------------------------------------------------------
	frontend http_front
	  bind *:80
	  default_backend http_back

	backend http_back
	  balance roundrobin
	  server kworker1 172.42.42.101:31552
	  server kworker2 172.42.42.102:31552

	[root@k8s tes-2]#

	[root@k8s ~]# systemctl restart haproxy
	[root@k8s ~]# systemctl enable haproxy
	Created symlink from /etc/systemd/system/multi-user.target.wants/haproxy.service to /usr/lib/systemd/system/haproxy.service.
	[root@k8s ~]#
	[root@k8s ~]# git clone https://github.com/nursanto/belajarbareng.git

		<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# cd belajarbareng/belajarbareng-4/materials/
	[root@k8s materials]# ls
	haproxy.cfg  ingress-resource-1.yaml  ingress-resource-2.yaml  ingress-resource-3.yaml  nginx-deploy-blue.yaml  nginx-deploy-green.yaml  nginx-deploy-main.yaml
	[root@k8s materials]#
	[root@k8s materials]#
	[root@k8s materials]# kubectl create -f nginx-deploy-main.yaml
	deployment.apps/nginx-deploy-main created
	[root@k8s materials]# kubectl create -f nginx-deploy-green.yaml
	deployment.apps/nginx-deploy-green created
	[root@k8s materials]# kubectl create -f nginx-deploy-blue.yaml
	deployment.apps/nginx-deploy-blue created
	[root@k8s materials]#
	[root@k8s materials]# kubectl get all
	NAME                                      READY   STATUS    RESTARTS   AGE
	pod/nginx-deploy-blue-7979fc74d8-vsdw6    1/1     Running   0          52s
	pod/nginx-deploy-green-7c67575d6c-l5wq6   1/1     Running   0          58s
	pod/nginx-deploy-main-7cc547b6f7-8fvcr    1/1     Running   0          98s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5h32m

	NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/nginx-deploy-blue    1/1     1            1           52s
	deployment.apps/nginx-deploy-green   1/1     1            1           59s
	deployment.apps/nginx-deploy-main    1/1     1            1           99s

	NAME                                            DESIRED   CURRENT   READY   AGE
	replicaset.apps/nginx-deploy-blue-7979fc74d8    1         1         1       52s
	replicaset.apps/nginx-deploy-green-7c67575d6c   1         1         1       58s
	replicaset.apps/nginx-deploy-main-7cc547b6f7    1         1         1       98s
	[root@k8s materials]#
	[root@k8s materials]# kubectl expose deployment.apps/nginx-deploy-main --port 80
	service/nginx-deploy-main exposed
	[root@k8s materials]# kubectl create -f ingress-resource-1.yaml
	ingress.networking.k8s.io/ingress-resource-1 created
	[root@k8s materials]# kubectl get svc,ing --show-labels
	NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE     LABELS
	service/kubernetes          ClusterIP   10.96.0.1        <none>        443/TCP   5h34m   component=apiserver,provider=kubernetes
	service/nginx-deploy-main   ClusterIP   10.111.177.240   <none>        80/TCP    59s     run=nginx

	NAME                                    HOSTS               ADDRESS   PORTS   AGE   LABELS
	ingress.extensions/ingress-resource-1   nginx.example.lab             80      51s   <none>
	[root@k8s materials]#
	[root@k8s materials]# cat /etc/hosts
	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

	172.42.42.100 kmaster.example.com kmaster
	172.42.42.101 kworker1.example.com kworker1
	172.42.42.102 kworker2.example.com kworker2

	192.168.26.51 nginx.example.lab
	192.168.26.51 green.nginx.example.lab
	192.168.26.51 blue.nginx.example.lab
	[root@k8s materials]#
	[root@k8s materials]# curl nginx.example.lab
	<!DOCTYPE html>
	<html>
	<head>
	<title>Welcome to nginx!</title>

		<output_omitted>

	[root@k8s materials]#
	[root@k8s materials]# kubectl get ingresses
	NAME                 HOSTS               ADDRESS   PORTS   AGE
	ingress-resource-1   nginx.example.lab             80      6m47s
	[root@k8s materials]# kubectl delete ingresses ingress-resource-1
	ingress.extensions "ingress-resource-1" deleted
	[root@k8s materials]#
	[root@k8s materials]# kubectl create -f ingress-resource-2.yaml
	ingress.networking.k8s.io/ingress-resource-2 created
	[root@k8s materials]#
	[root@k8s materials]# kubectl get ingresses ingress-resource-2
	NAME                 HOSTS                                                              ADDRESS   PORTS   AGE
	ingress-resource-2   nginx.example.lab,blue.nginx.example.lab,green.nginx.example.lab             80      2m16s
	[root@k8s materials]# curl blue.nginx.example.lab
	<html>
	<head><title>502 Bad Gateway</title></head>
	<body>
	<center><h1>502 Bad Gateway</h1></center>
	<hr><center>nginx/1.17.5</center>
	</body>
	</html>
	[root@k8s materials]# curl green.nginx.example.lab
	<html>
	<head><title>502 Bad Gateway</title></head>
	<body>
	<center><h1>502 Bad Gateway</h1></center>
	<hr><center>nginx/1.17.5</center>
	</body>
	</html>
	[root@k8s materials]#
	[root@k8s materials]# kubectl describe ingresses ingress-resource-2
	Name:             ingress-resource-2
	Namespace:        default
	Address:
	Default backend:  default-http-backend:80 (<none>)
	Rules:
	  Host                     Path  Backends
	  ----                     ----  --------
	  nginx.example.lab
	                              nginx-deploy-main:80 (192.168.33.199:80)
	  blue.nginx.example.lab
	                              nginx-deploy-blue:80 (<none>)
	  green.nginx.example.lab
	                              nginx-deploy-green:80 (<none>)
	Annotations:
	Events:
	  Type    Reason          Age        From                      Message
	  ----    ------          ----       ----                      -------
	  Normal  AddedOrUpdated  <invalid>  nginx-ingress-controller  Configuration for default/ingress-resource-2 was added or updated
	  Normal  AddedOrUpdated  <invalid>  nginx-ingress-controller  Configuration for default/ingress-resource-2 was added or updated
	[root@k8s materials]#
	[root@k8s materials]# kubectl get deployments,svc --show-labels
	NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
	deployment.apps/nginx-deploy-blue    1/1     1            1           19m   run=nginx
	deployment.apps/nginx-deploy-green   1/1     1            1           20m   run=nginx
	deployment.apps/nginx-deploy-main    1/1     1            1           20m   run=nginx

	NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE     LABELS
	service/kubernetes          ClusterIP   10.96.0.1        <none>        443/TCP   5h51m   component=apiserver,provider=kubernetes
	service/nginx-deploy-main   ClusterIP   10.111.177.240   <none>        80/TCP    17m     run=nginx
	[root@k8s materials]# kubectl expose deployment.apps/nginx-deploy-green --port 80
	service/nginx-deploy-green exposed
	[root@k8s materials]# kubectl expose deployment.apps/nginx-deploy-blue --port 80
	service/nginx-deploy-blue exposed
	[root@k8s materials]# kubectl get deployments,svc --show-labels
	NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
	deployment.apps/nginx-deploy-blue    1/1     1            1           20m   run=nginx
	deployment.apps/nginx-deploy-green   1/1     1            1           20m   run=nginx
	deployment.apps/nginx-deploy-main    1/1     1            1           21m   run=nginx

	NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE     LABELS
	service/kubernetes           ClusterIP   10.96.0.1        <none>        443/TCP   5h52m   component=apiserver,provider=kubernetes
	service/nginx-deploy-blue    ClusterIP   10.110.212.156   <none>        80/TCP    10s     run=nginx
	service/nginx-deploy-green   ClusterIP   10.98.244.79     <none>        80/TCP    16s     run=nginx
	service/nginx-deploy-main    ClusterIP   10.111.177.240   <none>        80/TCP    18m     run=nginx
	[root@k8s materials]#
	[root@k8s materials]# curl blue.nginx.example.lab
	<h1>I am <font color=blue>BLUE</font></h1>
	[root@k8s materials]# curl green.nginx.example.lab
	<h1>I am <font color=green>GREEN</font></h1>
	[root@k8s materials]#
	[root@k8s materials]# kubectl get ingresses
	NAME                 HOSTS                                                              ADDRESS   PORTS   AGE
	ingress-resource-2   nginx.example.lab,blue.nginx.example.lab,green.nginx.example.lab             80      5m4s
	[root@k8s materials]# kubectl delete ingresses ingress-resource-2
	ingress.extensions "ingress-resource-2" deleted
	[root@k8s materials]#

	[root@k8s materials]# kubectl create -f ingress-resource-3.yaml
	ingress.extensions/ingress-resource-3 created
	[root@k8s materials]# kubectl describe ingresses. ingress-resource-3
	Name:             ingress-resource-3
	Namespace:        default
	Address:          10.104.100.86
	Default backend:  default-http-backend:80 (<none>)
	Rules:
	  Host               Path  Backends
	  ----               ----  --------
	  nginx.example.lab
	                     /        nginx-deploy-main:80 (192.168.33.199:80)
	                     /blue    nginx-deploy-blue:80 (192.168.136.72:80)
	                     /green   nginx-deploy-green:80 (192.168.136.71:80)
	Annotations:
	  kubernetes.io/ingress.class:                 nginx
	  nginx.ingress.kubernetes.io/rewrite-target:  /
	Events:
	  Type    Reason  Age        From                      Message
	  ----    ------  ----       ----                      -------
	  Normal  CREATE  <invalid>  nginx-ingress-controller  Ingress default/ingress-resource-3
	  Normal  UPDATE  <invalid>  nginx-ingress-controller  Ingress default/ingress-resource-3
	[root@k8s materials]#
	[root@k8s materials]# curl nginx.example.lab/blue
	<h1>I am <font color=blue>BLUE</font></h1>
	[root@k8s materials]# curl nginx.example.lab/green
	<h1>I am <font color=green>GREEN</font></h1>
	[root@k8s materials]#







