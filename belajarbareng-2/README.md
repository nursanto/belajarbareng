# Kubernetes Instalation & Resource Management

## Table of Contents
* [Manual Instalation](#Manual-Instalation)
* [Script Installatin](#Script-Installatin)
* [Cluster Check](#Cluster-Check)
* [Deploy Simple Application](#Deploy-Simple-Application)
* [Resource Management](#Resource-Management)

### [Manual Instalation](./manual/)
deploy node using vagrant and install kubernetes cluster manually

|   Role   |         FQDN         |   IP Address  |    OS    |  RAM | CPU |
|----------|----------------------|---------------|----------|------|-----|
|  Master  | kmaster.example.com  | 172.42.42.100 | CentOS 7 |  2G  |  2  |
|  Worker  | kworker1.example.com | 172.42.42.101 | CentOS 7 |  1G  |  1  |
|  Worker  | kworker2.example.com | 172.42.42.102 | CentOS 7 |  1G  |  1  |

### [Script Installatin](./script)
deploy node using vagrant and bootstrap kubernetes installaion


### Cluster Check

	[root@k8s ~]# kubectl cluster-info
	Kubernetes master is running at https://172.42.42.100:6443
	KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

	To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
	[root@k8s ~]#
	[root@k8s ~]# kubectl get nodes
	NAME                   STATUS   ROLES    AGE    VERSION
	kmaster.example.com    Ready    master   157m   v1.16.2
	kworker1.example.com   Ready    <none>   148m   v1.16.2
	kworker2.example.com   Ready    <none>   148m   v1.16.2
	[root@k8s ~]#
	[root@k8s ~]# kubectl get nodes -o wide
	NAME                   STATUS   ROLES    AGE    VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
	kmaster.example.com    Ready    master   157m   v1.16.2   172.42.42.100   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.4
	kworker1.example.com   Ready    <none>   148m   v1.16.2   172.42.42.101   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.4
	kworker2.example.com   Ready    <none>   148m   v1.16.2   172.42.42.102   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://19.3.4
	[root@k8s ~]#
	[root@k8s ~]# kubectl get namespace
	NAME              STATUS   AGE
	default           Active   157m
	kube-node-lease   Active   157m
	kube-public       Active   157m
	kube-system       Active   157m
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   157m
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -A
	NAMESPACE     NAME                                              READY   STATUS    RESTARTS   AGE
	kube-system   pod/calico-kube-controllers-dc6cb64cb-t5k2g       1/1     Running   0          154m
	kube-system   pod/calico-node-29c4j                             1/1     Running   0          149m
	kube-system   pod/calico-node-chnvq                             1/1     Running   0          149m
	kube-system   pod/calico-node-fmf2j                             1/1     Running   0          154m
	kube-system   pod/coredns-5644d7b6d9-n7nnp                      1/1     Running   0          157m
	kube-system   pod/coredns-5644d7b6d9-qbknq                      1/1     Running   0          157m
	kube-system   pod/etcd-kmaster.example.com                      1/1     Running   0          156m
	kube-system   pod/kube-apiserver-kmaster.example.com            1/1     Running   0          156m
	kube-system   pod/kube-controller-manager-kmaster.example.com   1/1     Running   0          156m
	kube-system   pod/kube-proxy-5dhmz                              1/1     Running   0          149m
	kube-system   pod/kube-proxy-fqqbz                              1/1     Running   0          157m
	kube-system   pod/kube-proxy-sxcf6                              1/1     Running   0          149m
	kube-system   pod/kube-scheduler-kmaster.example.com            1/1     Running   0          156m

	NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
	default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  157m
	kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   157m

	NAMESPACE     NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
	kube-system   daemonset.apps/calico-node   3         3         3       3            3           beta.kubernetes.io/os=linux   154m
	kube-system   daemonset.apps/kube-proxy    3         3         3       3            3           beta.kubernetes.io/os=linux   157m

	NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
	kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           154m
	kube-system   deployment.apps/coredns                   2/2     2            2           157m

	NAMESPACE     NAME                                                DESIRED   CURRENT   READY   AGE
	kube-system   replicaset.apps/calico-kube-controllers-dc6cb64cb   1         1         1       154m
	kube-system   replicaset.apps/coredns-5644d7b6d9                  2         2         2       157m
	[root@k8s ~]#

### Deploy Simple Application

	[root@k8s ~]# kubectl run simpleweb --image scottsbaldwin/docker-hello-world  --replicas 2
	kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
	deployment.apps/simpleweb created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                             READY   STATUS    RESTARTS   AGE
	pod/simpleweb-7995447555-tpgss   1/1     Running   0          57s
	pod/simpleweb-7995447555-vkw88   1/1     Running   0          57s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   164m

	NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/simpleweb   2/2     2            2           57s

	NAME                                   DESIRED   CURRENT   READY   AGE
	replicaset.apps/simpleweb-7995447555   2         2         2       57s
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -o wide
	NAME                             READY   STATUS    RESTARTS   AGE     IP               NODE                   NOMINATED NODE   READINESS GATES
	pod/simpleweb-7995447555-tpgss   1/1     Running   0          2m44s   192.168.136.68   kworker2.example.com   <none>           <none>
	pod/simpleweb-7995447555-vkw88   1/1     Running   0          2m44s   192.168.33.194   kworker1.example.com   <none>           <none>

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   165m   <none>

	NAME                        READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                             SELECTOR
	deployment.apps/simpleweb   2/2     2            2           2m44s   simpleweb    scottsbaldwin/docker-hello-world   run=simpleweb

	NAME                                   DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES                             SELECTOR
	replicaset.apps/simpleweb-7995447555   2         2         2       2m44s   simpleweb    scottsbaldwin/docker-hello-world   pod-template-hash=7995447555,run=simpleweb
	[root@k8s ~]#
	[root@k8s ~]# kubectl describe pod/simpleweb-7995447555-vkw88
	Name:         simpleweb-7995447555-vkw88
	Namespace:    default
	Priority:     0
	Node:         kworker1.example.com/172.42.42.101
	Start Time:   Tue, 22 Oct 2019 17:01:04 +0700
	Labels:       pod-template-hash=7995447555
	              run=simpleweb
	Annotations:  cni.projectcalico.org/podIP: 192.168.33.194/32
	Status:       Running
	IP:           192.168.33.194
	IPs:
	  IP:           192.168.33.194
	Controlled By:  ReplicaSet/simpleweb-7995447555
	Containers:
	  simpleweb:
	    Container ID:   docker://e50de87f98d92ea618dca4e6c6ff42fc3b0b23ff90e985195f145cb6c951d1f8
	    Image:          scottsbaldwin/docker-hello-world
	    Image ID:       docker-pullable://scottsbaldwin/docker-hello-world@sha256:5350ad87bf3f7b4188cd9b1161a1c6503ed5e56801dbf3f67c76657aaca91768
	    Port:           <none>
	    Host Port:      <none>
	    State:          Running
	      Started:      Tue, 22 Oct 2019 17:01:25 +0700
	    Ready:          True
	    Restart Count:  0
	    Environment:    <none>
	    Mounts:
	      /var/run/secrets/kubernetes.io/serviceaccount from default-token-l2hvm (ro)
	Conditions:
	  Type              Status
	  Initialized       True
	  Ready             True
	  ContainersReady   True
	  PodScheduled      True
	Volumes:
	  default-token-l2hvm:
	    Type:        Secret (a volume populated by a Secret)
	    SecretName:  default-token-l2hvm
	    Optional:    false
	QoS Class:       BestEffort
	Node-Selectors:  <none>
	Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
	                 node.kubernetes.io/unreachable:NoExecute for 300s
	Events:
	  Type    Reason     Age        From                           Message
	  ----    ------     ----       ----                           -------
	  Normal  Scheduled  <unknown>  default-scheduler              Successfully assigned default/simpleweb-7995447555-vkw88 to kworker1.example.com
	  Normal  Pulling    <invalid>  kubelet, kworker1.example.com  Pulling image "scottsbaldwin/docker-hello-world"
	  Normal  Pulled     <invalid>  kubelet, kworker1.example.com  Successfully pulled image "scottsbaldwin/docker-hello-world"
	  Normal  Created    <invalid>  kubelet, kworker1.example.com  Created container simpleweb
	  Normal  Started    <invalid>  kubelet, kworker1.example.com  Started container simpleweb
	[root@k8s ~]# kubectl describe deployment.apps/simpleweb
	Name:                   simpleweb
	Namespace:              default
	CreationTimestamp:      Tue, 22 Oct 2019 17:01:04 +0700
	Labels:                 run=simpleweb
	Annotations:            deployment.kubernetes.io/revision: 1
	Selector:               run=simpleweb
	Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
	StrategyType:           RollingUpdate
	MinReadySeconds:        0
	RollingUpdateStrategy:  25% max unavailable, 25% max surge
	Pod Template:
	  Labels:  run=simpleweb
	  Containers:
	   simpleweb:
	    Image:        scottsbaldwin/docker-hello-world
	    Port:         <none>
	    Host Port:    <none>
	    Environment:  <none>
	    Mounts:       <none>
	  Volumes:        <none>
	Conditions:
	  Type           Status  Reason
	  ----           ------  ------
	  Available      True    MinimumReplicasAvailable
	  Progressing    True    NewReplicaSetAvailable
	OldReplicaSets:  <none>
	NewReplicaSet:   simpleweb-7995447555 (2/2 replicas created)
	Events:
	  Type    Reason             Age        From                   Message
	  ----    ------             ----       ----                   -------
	  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled up replica set simpleweb-7995447555 to 2
	[root@k8s ~]#
	[root@k8s ~]# kubectl get events
	LAST SEEN   TYPE      REASON              OBJECT                            MESSAGE
	<unknown>   Normal    Scheduled           pod/nginx-6db489d4b7-jhqr8        Successfully assigned default/nginx-6db489d4b7-jhqr8 to kworker1.example.com
	7m37s       Normal    Pulling             pod/nginx-6db489d4b7-jhqr8        Pulling image "nginx"
	6m51s       Normal    Pulled              pod/nginx-6db489d4b7-jhqr8        Successfully pulled image "nginx"
	6m51s       Normal    Created             pod/nginx-6db489d4b7-jhqr8        Created container nginx
	6m51s       Normal    Started             pod/nginx-6db489d4b7-jhqr8        Started container nginx
	5m1s        Normal    Killing             pod/nginx-6db489d4b7-jhqr8        Stopping container nginx
	7m41s       Normal    SuccessfulCreate    replicaset/nginx-6db489d4b7       Created pod: nginx-6db489d4b7-jhqr8
	7m41s       Normal    ScalingReplicaSet   deployment/nginx                  Scaled up replica set nginx-6db489d4b7 to 1
	<unknown>   Normal    Scheduled           pod/simpleweb-7995447555-tpgss    Successfully assigned default/simpleweb-7995447555-tpgss to kworker2.example.com
	3m21s       Normal    Pulling             pod/simpleweb-7995447555-tpgss    Pulling image "scottsbaldwin/docker-hello-world"
	3m31s       Warning   Failed              pod/simpleweb-7995447555-tpgss    Failed to pull image "scottsbaldwin/docker-hello-world": rpc error: code = Unknown desc = error pulling image configuration: Get https://production.cloudflare.docker.com/registry-v2/docker/registry/v2/blobs/sha256/d7/d72dd106d3f8b26f63d256731da5da17f4fe7a8f7bc180c8f176cd757d2cefde/data?verify=1571741472-uPpr%2F4fiyi2ZixtR%2FK5AwxUatZQ%3D: net/http: TLS handshake timeout
	3m31s       Warning   Failed              pod/simpleweb-7995447555-tpgss    Error: ErrImagePull
	3m24s       Normal    SandboxChanged      pod/simpleweb-7995447555-tpgss    Pod sandbox changed, it will be killed and re-created.
	3m22s       Normal    BackOff             pod/simpleweb-7995447555-tpgss    Back-off pulling image "scottsbaldwin/docker-hello-world"
	3m22s       Warning   Failed              pod/simpleweb-7995447555-tpgss    Error: ImagePullBackOff
	3m4s        Normal    Pulled              pod/simpleweb-7995447555-tpgss    Successfully pulled image "scottsbaldwin/docker-hello-world"
	3m4s        Normal    Created             pod/simpleweb-7995447555-tpgss    Created container simpleweb
	3m4s        Normal    Started             pod/simpleweb-7995447555-tpgss    Started container simpleweb
	<unknown>   Normal    Scheduled           pod/simpleweb-7995447555-vkw88    Successfully assigned default/simpleweb-7995447555-vkw88 to kworker1.example.com
	3m48s       Normal    Pulling             pod/simpleweb-7995447555-vkw88    Pulling image "scottsbaldwin/docker-hello-world"
	3m30s       Normal    Pulled              pod/simpleweb-7995447555-vkw88    Successfully pulled image "scottsbaldwin/docker-hello-world"
	3m30s       Normal    Created             pod/simpleweb-7995447555-vkw88    Created container simpleweb
	3m29s       Normal    Started             pod/simpleweb-7995447555-vkw88    Started container simpleweb
	3m50s       Normal    SuccessfulCreate    replicaset/simpleweb-7995447555   Created pod: simpleweb-7995447555-tpgss
	3m50s       Normal    SuccessfulCreate    replicaset/simpleweb-7995447555   Created pod: simpleweb-7995447555-vkw88
	3m50s       Normal    ScalingReplicaSet   deployment/simpleweb              Scaled up replica set simpleweb-7995447555 to 2
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get deployment.apps/simpleweb -o yaml
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  annotations:
	    deployment.kubernetes.io/revision: "1"
	  creationTimestamp: "2019-10-22T10:01:04Z"
	  generation: 1
	  labels:
	    run: simpleweb
	  name: simpleweb
	  namespace: default
	  resourceVersion: "14864"
	  selfLink: /apis/apps/v1/namespaces/default/deployments/simpleweb
	  uid: 472b607a-a7e2-4381-9f2f-9e3d2f96c548
	spec:
	  progressDeadlineSeconds: 600
	  replicas: 2
	  revisionHistoryLimit: 10
	  selector:
	    matchLabels:
	      run: simpleweb
	  strategy:
	    rollingUpdate:
	      maxSurge: 25%
	      maxUnavailable: 25%
	    type: RollingUpdate
	  template:
	    metadata:
	      creationTimestamp: null
	      labels:
	        run: simpleweb
	    spec:
	      containers:
	      - image: scottsbaldwin/docker-hello-world
	        imagePullPolicy: Always
	        name: simpleweb
	        resources: {}
	        terminationMessagePath: /dev/termination-log
	        terminationMessagePolicy: File
	      dnsPolicy: ClusterFirst
	      restartPolicy: Always
	      schedulerName: default-scheduler
	      securityContext: {}
	      terminationGracePeriodSeconds: 30
	status:
	  availableReplicas: 2
	  conditions:
	  - lastTransitionTime: "2019-10-22T10:01:51Z"
	    lastUpdateTime: "2019-10-22T10:01:51Z"
	    message: Deployment has minimum availability.
	    reason: MinimumReplicasAvailable
	    status: "True"
	    type: Available
	  - lastTransitionTime: "2019-10-22T10:01:04Z"
	    lastUpdateTime: "2019-10-22T10:01:51Z"
	    message: ReplicaSet "simpleweb-7995447555" has successfully progressed.
	    reason: NewReplicaSetAvailable
	    status: "True"
	    type: Progressing
	  observedGeneration: 1
	  readyReplicas: 2
	  replicas: 2
	  updatedReplicas: 2
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                             READY   STATUS    RESTARTS   AGE
	pod/simpleweb-7995447555-tpgss   1/1     Running   0          10m
	pod/simpleweb-7995447555-vkw88   1/1     Running   0          10m

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   173m

	NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/simpleweb   2/2     2            2           10m

	NAME                                   DESIRED   CURRENT   READY   AGE
	replicaset.apps/simpleweb-7995447555   2         2         2       10m
	[root@k8s ~]#
	[root@k8s ~]# kubectl expose deployment.apps/simpleweb --port 80
	service/simpleweb exposed
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get endpoints
	NAME         ENDPOINTS                             AGE
	kubernetes   172.42.42.100:6443                    174m
	simpleweb    192.168.136.68:80,192.168.33.194:80   25s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                             READY   STATUS    RESTARTS   AGE
	pod/simpleweb-7995447555-tpgss   1/1     Running   0          11m
	pod/simpleweb-7995447555-vkw88   1/1     Running   0          11m

	NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP   174m
	service/simpleweb    ClusterIP   10.109.19.130   <none>        80/TCP    41s

	NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/simpleweb   2/2     2            2           11m

	NAME                                   DESIRED   CURRENT   READY   AGE
	replicaset.apps/simpleweb-7995447555   2         2         2       11m
	[root@k8s ~]# kubectl describe service/simpleweb
	Name:              simpleweb
	Namespace:         default
	Labels:            run=simpleweb
	Annotations:       <none>
	Selector:          run=simpleweb
	Type:              ClusterIP
	IP:                10.109.19.130
	Port:              <unset>  80/TCP
	TargetPort:        80/TCP
	Endpoints:         192.168.136.68:80,192.168.33.194:80
	Session Affinity:  None
	Events:            <none>
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# ssh kworker1
	root@kworker1's password:
	Last login: Tue Oct 22 10:13:41 2019 from 172.42.42.1
	[root@kworker1 ~]#
	[root@kworker1 ~]# for i in {1..6};do curl 10.109.19.130;done
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	[root@kworker1 ~]#
	[root@kworker1 ~]# exit
	logout
	Connection to kworker1 closed.
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                             READY   STATUS    RESTARTS   AGE
	pod/simpleweb-7995447555-tpgss   1/1     Running   0          24m
	pod/simpleweb-7995447555-vkw88   1/1     Running   0          24m

	NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
	service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        3h7m
	service/simpleweb    NodePort    10.100.219.98   <none>        80:30856/TCP   5s

	NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/simpleweb   2/2     2            2           24m

	NAME                                   DESIRED   CURRENT   READY   AGE
	replicaset.apps/simpleweb-7995447555   2         2         2       24m
	[root@k8s ~]#
	[root@k8s ~]# kubectl get endpoints
	NAME         ENDPOINTS                             AGE
	kubernetes   172.42.42.100:6443                    3h9m
	simpleweb    192.168.136.68:80,192.168.33.194:80   90s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# for i in {1..6};do curl kworker1:30856;done
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-tpgss</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	<h1>Hello webhook world from: simpleweb-7995447555-vkw88</h1>
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete deployment.apps/simpleweb
	deployment.apps "simpleweb" deleted
	[root@k8s ~]# kubectl delete service/simpleweb
	service "simpleweb" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h12m
	[root@k8s ~]#


### Resource Management

	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   22h
	[root@k8s ~]#
	[root@k8s ~]# cat pod-cpu-limit.yaml
	apiVersion: v1
	kind: Pod
	metadata:
	  name: cpu-demo
	spec:
	  containers:
	  - name: cpu-demo-ctr
	    image: vish/stress
	    resources:
	      limits:
	        cpu: "1"
	      requests:
	        cpu: "0.5"
	    args:
	    - -cpus
	    - "2"
	[root@k8s ~]#
	[root@k8s ~]# kubectl create -f pod-cpu-limit.yaml
	pod/cpu-demo created
	[root@k8s ~]# kubectl get all
	NAME           READY   STATUS    RESTARTS   AGE
	pod/cpu-demo   1/1     Running   0          24s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h
	[root@k8s ~]#
	[root@k8s ~]# cat pod-memory-limit.yaml
	apiVersion: v1
	kind: Pod
	metadata:
	  name: memory-demo
	spec:
	  containers:
	  - name: memory-demo-2-ctr
	    image: polinux/stress
	    resources:
	      requests:
	        memory: "50Mi"
	      limits:
	        memory: "100Mi"
	    command: ["stress"]
	    args: ["--vm", "1", "--vm-bytes", "250M", "--vm-hang", "1"]
	[root@k8s ~]#
	[root@k8s ~]# kubectl create -f pod-memory-limit.yaml
	pod/memory-demo created
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME              READY   STATUS      RESTARTS   AGE
	pod/cpu-demo      1/1     Running     0          97s
	pod/memory-demo   0/1     OOMKilled   0          9s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME              READY   STATUS      RESTARTS   AGE
	pod/cpu-demo      1/1     Running     0          97s
	pod/memory-demo   0/1     OOMKilled   0          9s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete -f pod-memory-limit.yaml
	pod "memory-demo" deleted

	[root@k8s ~]#
	[root@k8s ~]# kubectl delete -f pod-cpu-limit.yaml
	pod "cpu-demo" deleted
	[root@k8s ~]#


	[root@k8s ~]# kubectl get namespace
	NAME              STATUS   AGE
	default           Active   7d21h
	kube-node-lease   Active   7d21h
	kube-public       Active   7d21h
	kube-system       Active   7d21h
	nginx-ingress     Active   46h
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl create namespace tes-quota
	namespace/tes-quota created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get namespace
	NAME              STATUS   AGE
	default           Active   7d21h
	kube-node-lease   Active   7d21h
	kube-public       Active   7d21h
	kube-system       Active   7d21h
	nginx-ingress     Active   46h
	tes-quota         Active   4s
	[root@k8s ~]#
	[root@k8s ~]# cat 02-myquota.yaml
	apiVersion: v1
	kind: ResourceQuota
	metadata:
	  name: pod-quota
	spec:
	  hard:
	    pods: "2"
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-myquota.yaml -n tes-quota
	resourcequota/pod-quota created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get quota -n tes-quota
	NAME        CREATED AT
	pod-quota   2019-10-24T02:22:18Z
	[root@k8s ~]# kubectl describe quota pod-quota -n tes-quota
	Name:       pod-quota
	Namespace:  tes-quota
	Resource    Used  Hard
	--------    ----  ----
	pods        0     2
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-create-pod1.yaml -n tes-quota
	pod/quota-pod-1 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME              READY   STATUS    RESTARTS   AGE
	pod/quota-pod-1   1/1     Running   0          60s
	[root@k8s ~]# kubectl describe quota pod-quota -n tes-quota
	Name:       pod-quota
	Namespace:  tes-quota
	Resource    Used  Hard
	--------    ----  ----
	pods        1     2
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-create-pod2.yaml -n tes-quota
	pod/quota-pod-2 created
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME              READY   STATUS    RESTARTS   AGE
	pod/quota-pod-1   1/1     Running   0          102s
	pod/quota-pod-2   1/1     Running   0          14s
	[root@k8s ~]# kubectl describe quota pod-quota -n tes-quota
	Name:       pod-quota
	Namespace:  tes-quota
	Resource    Used  Hard
	--------    ----  ----
	pods        2     2
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-create-pod3.yaml -n tes-quota
	Error from server (Forbidden): error when creating "02-create-pod3.yaml": pods "quota-pod-3" is forbidden: exceeded quota: pod-quota, requested: pods=1, used: pods=2, limited: pods=2
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete pod/quota-pod-1 pod/quota-pod-2  -n tes-quota
	pod "quota-pod-1" deleted
	pod "quota-pod-2" deleted
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete quota pod-quota  -n tes-quota
	resourcequota "pod-quota" deleted
	[root@k8s ~]# kubectl get quota -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]#
	[root@k8s ~]# kubectl get namespace
	NAME              STATUS   AGE
	default           Active   7d21h
	kube-node-lease   Active   7d21h
	kube-public       Active   7d21h
	kube-system       Active   7d21h
	nginx-ingress     Active   46h
	tes-quota         Active   26m
	[root@k8s ~]# kubectl get quota -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]# cat 03-cpu-quota.yaml
	apiVersion: v1
	kind: ResourceQuota
	metadata:
	  name: cpu-quota
	spec:
	  hard:
	    requests.cpu: "250m"
	    limits.cpu: "400m"
	[root@k8s ~]# kubectl apply -f 03-cpu-quota.yaml -n tes-quota
	resourcequota/cpu-quota created
	[root@k8s ~]# kubectl get quota -n tes-quota
	NAME        CREATED AT
	cpu-quota   2019-10-24T02:46:33Z
	[root@k8s ~]# kubectl describe quota cpu-quota -n tes-quota
	Name:         cpu-quota
	Namespace:    tes-quota
	Resource      Used  Hard
	--------      ----  ----
	limits.cpu    0     400m
	requests.cpu  0     250m
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-create-pod1.yaml  -n tes-quota
	pod/cpu-pod-1 created
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME            READY   STATUS    RESTARTS   AGE
	pod/cpu-pod-1   1/1     Running   0          7s
	[root@k8s ~]# kubectl describe quota cpu-quota -n tes-quota
	Name:         cpu-quota
	Namespace:    tes-quota
	Resource      Used  Hard
	--------      ----  ----
	limits.cpu    150m  400m
	requests.cpu  100m  250m
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-create-pod2.yaml -n tes-quota
	pod/cpu-pod-2 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME            READY   STATUS    RESTARTS   AGE
	pod/cpu-pod-1   1/1     Running   0          3m58s
	pod/cpu-pod-2   1/1     Running   0          10s
	[root@k8s ~]# kubectl describe quota cpu-quota -n tes-quota
	Name:         cpu-quota
	Namespace:    tes-quota
	Resource      Used  Hard
	--------      ----  ----
	limits.cpu    400m  400m
	requests.cpu  250m  250m
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-create-pod3.yaml -n tes-quota
	Error from server (Forbidden): error when creating "03-create-pod3.yaml": pods "cpu-pod-3" is forbidden: exceeded quota: cpu-quota, requested: limits.cpu=10m,requests.cpu=10m, used: limits.cpu=400m,requests.cpu=250m, limited: limits.cpu=400m,requests.cpu=250m
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-create-pod3.yaml -n tes-quota
	Error from server (Forbidden): error when creating "03-create-pod3.yaml": pods "cpu-pod-3" is forbidden: exceeded quota: cpu-quota, requested: limits.cpu=10m,requests.cpu=10m, used: limits.cpu=400m,requests.cpu=250m, limited: limits.cpu=400m,requests.cpu=250m
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete pod/cpu-pod-1 pod/cpu-pod-2 -n tes-quota
	pod "cpu-pod-1" deleted
	pod "cpu-pod-2" deleted
	[root@k8s ~]# kubectl delete quota cpu-quota -n tes-quota
	resourcequota "cpu-quota" deleted
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]# kubectl get quota -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]#
	[root@k8s ~]# cat 04-ram-quota.yaml
	apiVersion: v1
	kind: ResourceQuota
	metadata:
	  name: ram-quota
	  namespace: tes-quota
	spec:
	  hard:
	    requests.memory: "250Mi"
	    limits.memory: "400Mi"
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 04-ram-quota.yaml
	resourcequota/ram-quota created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get quota -n tes-quota
	NAME        CREATED AT
	ram-quota   2019-10-24T03:16:12Z
	[root@k8s ~]# kubectl describe quota ram-quota -n tes-quota
	Name:            ram-quota
	Namespace:       tes-quota
	Resource         Used  Hard
	--------         ----  ----
	limits.memory    0     400Mi
	requests.memory  0     250Mi
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 04-create-pod1.yaml
	pod/cpu-pod-1 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME            READY   STATUS    RESTARTS   AGE
	pod/cpu-pod-1   1/1     Running   0          12s
	[root@k8s ~]# kubectl describe quota ram-quota -n tes-quota
	Name:            ram-quota
	Namespace:       tes-quota
	Resource         Used   Hard
	--------         ----   ----
	limits.memory    150Mi  400Mi
	requests.memory  100Mi  250Mi
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 04-create-pod2.yaml
	pod/cpu-pod-2 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl describe quota ram-quota -n tes-quota
	Name:            ram-quota
	Namespace:       tes-quota
	Resource         Used   Hard
	--------         ----   ----
	limits.memory    400Mi  400Mi
	requests.memory  250Mi  250Mi
	[root@k8s ~]# kubectl get all -n tes-quota
	NAME            READY   STATUS    RESTARTS   AGE
	pod/cpu-pod-1   1/1     Running   0          3m42s
	pod/cpu-pod-2   1/1     Running   0          30s
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 04-create-pod3.yaml
	Error from server (Forbidden): error when creating "04-create-pod3.yaml": pods "cpu-pod-3" is forbidden: exceeded quota: ram-quota, requested: limits.memory=150Mi,requests.memory=100Mi, used: limits.memory=400Mi,requests.memory=250Mi, limited: limits.memory=400Mi,requests.memory=250Mi
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete pod/cpu-pod-1 pod/cpu-pod-2 -n tes-quota
	pod "cpu-pod-1" deleted
	pod "cpu-pod-2" deleted
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get quota -n tes-quota
	NAME        CREATED AT
	ram-quota   2019-10-24T03:16:12Z
	[root@k8s ~]# kubectl delete quota ram-quota -n tes-quota
	resourcequota "ram-quota" deleted
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]# kubectl apply -f 05-limit-resource.yaml
	limitrange/cpu-limit created
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get limits -n tes-quota
	NAME        CREATED AT
	cpu-limit   2019-10-24T03:43:59Z
	[root@k8s ~]# kubectl describe limits cpu-limit -n tes-quota
	Name:       cpu-limit
	Namespace:  tes-quota
	Type        Resource  Min  Max  Default Request  Default Limit  Max Limit/Request Ratio
	----        --------  ---  ---  ---------------  -------------  -----------------------
	Container   cpu       -    -    100m             200m           -
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 05-create-pod1.yaml
	pod/cpu-pod-1 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl describe pod/cpu-pod-1 -n tes-quota | egrep "Limits|Requests" -A 1
	    Limits:
	      cpu:  200m
	    Requests:
	      cpu:        100m
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 05-create-pod2.yaml
	pod/cpu-pod-2 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl describe pod/cpu-pod-2 -n tes-quota | egrep "Limits|Requests" -A 1
	    Limits:
	      cpu:  200m
	    Requests:
	      cpu:        109m
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 05-create-pod3.yaml
	pod/cpu-pod-3 created
	[root@k8s ~]#
	[root@k8s ~]# kubectl describe pod/cpu-pod-3 -n tes-quota | egrep "Limits|Requests" -A 1
	    Limits:
	      cpu:  209m
	    Requests:
	      cpu:        209m
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete pod cpu-pod-1 cpu-pod-2 cpu-pod-3  -n tes-quota
	pod "cpu-pod-1" deleted
	pod "cpu-pod-2" deleted
	pod "cpu-pod-3" deleted
	[root@k8s ~]# 
	[root@k8s ~]# kubectl delete limits cpu-limit -n tes-quota
	limitrange "cpu-limit" deleted
	[root@k8s ~]# kubectl get limits -n tes-quota
	No resources found in tes-quota namespace.
	[root@k8s ~]#
