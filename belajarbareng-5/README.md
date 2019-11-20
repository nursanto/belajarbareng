# Belajar Bareng 5

## Table of Contents
* [Helm Chart](#Helm-Chart)
* [Kubernetes Dashboard](Kubernetes-Dashboard)
* [Prometheus](#Prometheus)
* [Grafana](#Grafana)
* [Rancher](#Dynamic-NFS-Provisioner)


### Helm Chart
	[root@k8s ~]# helm create mychart
	Creating mychart
	[root@k8s ~]# tree mychart/
	mychart/
	├── charts
	├── Chart.yaml
	├── templates
	│   ├── deployment.yaml
	│   ├── _helpers.tpl
	│   ├── ingress.yaml
	│   ├── NOTES.txt
	│   ├── serviceaccount.yaml
	│   ├── service.yaml
	│   └── tests
	│       └── test-connection.yaml
	└── values.yaml

	3 directories, 9 files
	[root@k8s ~]#
	[root@k8s ~]# helm install --dry-run --debug ./mychart
	[debug] Created tunnel using local port: '46773'

	[debug] SERVER: "127.0.0.1:46773"

	[debug] Original chart version: ""
	[debug] CHART PATH: /root/mychart

	NAME:   mollified-rat
	REVISION: 1
	RELEASED: Tue Nov 19 21:54:21 2019
	CHART: mychart-0.1.0
	USER-SUPPLIED VALUES:
	{}

	COMPUTED VALUES:
	affinity: {}
	fullnameOverride: ""
	image:
	  pullPolicy: IfNotPresent
	  repository: nginx
	  tag: stable
	imagePullSecrets: []
	ingress:
	  annotations: {}
	  enabled: false
	  hosts:
	  - host: chart-example.local
	    paths: []
	  tls: []
	nameOverride: ""
	nodeSelector: {}
	podSecurityContext: {}
	replicaCount: 1
	resources: {}
	securityContext: {}
	service:
	  port: 80
	  type: ClusterIP
	serviceAccount:
	  create: true
	  name: null
	tolerations: []

	HOOKS:
	---
	# mollified-rat-mychart-test-connection
	apiVersion: v1
	kind: Pod
	metadata:
	  name: "mollified-rat-mychart-test-connection"
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: mollified-rat
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	  annotations:
	    "helm.sh/hook": test-success
	spec:
	  containers:
	    - name: wget
	      image: busybox
	      command: ['wget']
	      args:  ['mollified-rat-mychart:80']
	  restartPolicy: Never
	MANIFEST:

	---
	# Source: mychart/templates/serviceaccount.yaml
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  name: mollified-rat-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: mollified-rat
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	---
	# Source: mychart/templates/service.yaml
	apiVersion: v1
	kind: Service
	metadata:
	  name: mollified-rat-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: mollified-rat
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	spec:
	  type: ClusterIP
	  ports:
	    - port: 80
	      targetPort: http
	      protocol: TCP
	      name: http
	  selector:
	    app.kubernetes.io/name: mychart
	    app.kubernetes.io/instance: mollified-rat
	---
	# Source: mychart/templates/deployment.yaml
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  name: mollified-rat-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: mollified-rat
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	spec:
	  replicas: 1
	  selector:
	    matchLabels:
	      app.kubernetes.io/name: mychart
	      app.kubernetes.io/instance: mollified-rat
	  template:
	    metadata:
	      labels:
	        app.kubernetes.io/name: mychart
	        app.kubernetes.io/instance: mollified-rat
	    spec:
	      serviceAccountName: mollified-rat-mychart
	      securityContext:
	        {}

	      containers:
	        - name: mychart
	          securityContext:
	            {}

	          image: "nginx:stable"
	          imagePullPolicy: IfNotPresent
	          ports:
	            - name: http
	              containerPort: 80
	              protocol: TCP
	          livenessProbe:
	            httpGet:
	              path: /
	              port: http
	          readinessProbe:
	            httpGet:
	              path: /
	              port: http
	          resources:
	            {}
	[root@k8s ~]#
	[root@k8s ~]# helm install --dry-run --debug ./mychart --set service.internalPort=8080
	[debug] Created tunnel using local port: '39634'

	[debug] SERVER: "127.0.0.1:39634"

	[debug] Original chart version: ""
	[debug] CHART PATH: /root/mychart

	NAME:   romping-dachshund
	REVISION: 1
	RELEASED: Tue Nov 19 21:56:13 2019
	CHART: mychart-0.1.0
	USER-SUPPLIED VALUES:
	service:
	  internalPort: 8080

	COMPUTED VALUES:
	affinity: {}
	fullnameOverride: ""
	image:
	  pullPolicy: IfNotPresent
	  repository: nginx
	  tag: stable
	imagePullSecrets: []
	ingress:
	  annotations: {}
	  enabled: false
	  hosts:
	  - host: chart-example.local
	    paths: []
	  tls: []
	nameOverride: ""
	nodeSelector: {}
	podSecurityContext: {}
	replicaCount: 1
	resources: {}
	securityContext: {}
	service:
	  internalPort: 8080
	  port: 80
	  type: ClusterIP
	serviceAccount:
	  create: true
	  name: null
	tolerations: []

	HOOKS:
	---
	# romping-dachshund-mychart-test-connection
	apiVersion: v1
	kind: Pod
	metadata:
	  name: "romping-dachshund-mychart-test-connection"
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: romping-dachshund
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	  annotations:
	    "helm.sh/hook": test-success
	spec:
	  containers:
	    - name: wget
	      image: busybox
	      command: ['wget']
	      args:  ['romping-dachshund-mychart:80']
	  restartPolicy: Never
	MANIFEST:

	---
	# Source: mychart/templates/serviceaccount.yaml
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  name: romping-dachshund-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: romping-dachshund
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	---
	# Source: mychart/templates/service.yaml
	apiVersion: v1
	kind: Service
	metadata:
	  name: romping-dachshund-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: romping-dachshund
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	spec:
	  type: ClusterIP
	  ports:
	    - port: 80
	      targetPort: http
	      protocol: TCP
	      name: http
	  selector:
	    app.kubernetes.io/name: mychart
	    app.kubernetes.io/instance: romping-dachshund
	---
	# Source: mychart/templates/deployment.yaml
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  name: romping-dachshund-mychart
	  labels:
	    app.kubernetes.io/name: mychart
	    helm.sh/chart: mychart-0.1.0
	    app.kubernetes.io/instance: romping-dachshund
	    app.kubernetes.io/version: "1.0"
	    app.kubernetes.io/managed-by: Tiller
	spec:
	  replicas: 1
	  selector:
	    matchLabels:
	      app.kubernetes.io/name: mychart
	      app.kubernetes.io/instance: romping-dachshund
	  template:
	    metadata:
	      labels:
	        app.kubernetes.io/name: mychart
	        app.kubernetes.io/instance: romping-dachshund
	    spec:
	      serviceAccountName: romping-dachshund-mychart
	      securityContext:
	        {}

	      containers:
	        - name: mychart
	          securityContext:
	            {}

	          image: "nginx:stable"
	          imagePullPolicy: IfNotPresent
	          ports:
	            - name: http
	              containerPort: 80
	              protocol: TCP
	          livenessProbe:
	            httpGet:
	              path: /
	              port: http
	          readinessProbe:
	            httpGet:
	              path: /
	              port: http
	          resources:
	            {}
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# helm install --name example ./mychart --set service.type=NodePort
	NAME:   example
	LAST DEPLOYED: Tue Nov 19 21:57:30 2019
	NAMESPACE: default
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/Deployment
	NAME             AGE
	example-mychart  0s

	==> v1/Pod(related)
	NAME                              AGE
	example-mychart-6949b9cc89-kwhgd  0s

	==> v1/Service
	NAME             AGE
	example-mychart  0s

	==> v1/ServiceAccount
	NAME             AGE
	example-mychart  0s


	NOTES:
	1. Get the application URL by running these commands:
	  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
	  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
	  echo http://$NODE_IP:$NODE_PORT

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                                         READY   STATUS    RESTARTS   AGE
	pod/example-mychart-6949b9cc89-kwhgd         1/1     Running   0          49s
	pod/nfs-client-provisioner-7cb848b79-jv9sw   1/1     Running   1          5d1h

	NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
	service/example-mychart   NodePort    10.110.193.79   <none>        80:31247/TCP   49s
	service/kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP        5d5h

	NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/example-mychart          1/1     1            1           49s
	deployment.apps/nfs-client-provisioner   1/1     1            1           5d1h

	NAME                                               DESIRED   CURRENT   READY   AGE
	replicaset.apps/example-mychart-6949b9cc89         1         1         1       49s
	replicaset.apps/nfs-client-provisioner-7cb848b79   1         1         1       5d1h
	[root@k8s ~]#
	[root@k8s ~]# helm ls
	NAME    REVISION        UPDATED                         STATUS          CHART           APP VERSION     NAMESPACE
	example 1               Tue Nov 19 21:57:30 2019        DEPLOYED        mychart-0.1.0   1.0             default
	[root@k8s ~]#
	[root@k8s ~]# head mychart/values.yaml
	...

	replicaCount: 1

	image:
	  repository: nursanto/demo-app
	  tag: v1
	  pullPolicy: IfNotPresent

	...
	[root@k8s ~]#
	[root@k8s ~]# helm upgrade example ./mychart
	Release "example" has been upgraded.
	LAST DEPLOYED: Tue Nov 19 22:02:29 2019
	NAMESPACE: default
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/Deployment
	NAME             AGE
	example-mychart  5m

	==> v1/Pod(related)
	NAME                              AGE
	example-mychart-57958d68c-vfkbt   0s
	example-mychart-6949b9cc89-kwhgd  5m

	==> v1/Service
	NAME             AGE
	example-mychart  5m

	==> v1/ServiceAccount
	NAME             AGE
	example-mychart  5m


	NOTES:
	1. Get the application URL by running these commands:
	  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
	  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
	  echo http://$NODE_IP:$NODE_PORT

	[root@k8s ~]#
	[root@k8s ~]# head mychart/values.yaml
	# Default values for mychart.
	# This is a YAML-formatted file.
	# Declare variables to be passed into your templates.

	replicaCount: 1

	image:
	  repository: nursanto/demo-app
	  tag: v2
	  pullPolicy: IfNotPresent
	[root@k8s ~]#

	[root@k8s ~]# helm upgrade example ./mychart
	Release "example" has been upgraded.
	LAST DEPLOYED: Tue Nov 19 22:04:12 2019
	NAMESPACE: default
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/Deployment
	NAME             AGE
	example-mychart  6m42s

	==> v1/Pod(related)
	NAME                              AGE
	example-mychart-57958d68c-vfkbt   102s
	example-mychart-7f7df6f8b6-ql27g  0s

	==> v1/Service
	NAME             AGE
	example-mychart  6m42s

	==> v1/ServiceAccount
	NAME             AGE
	example-mychart  6m42s


	NOTES:
	1. Get the application URL by running these commands:
	  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
	  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
	  echo http://$NODE_IP:$NODE_PORT

	[root@k8s ~]#
	[root@k8s ~]# helm ls
	NAME    REVISION        UPDATED                         STATUS          CHART           APP VERSION     NAMESPACE
	example 3               Tue Nov 19 22:04:12 2019        DEPLOYED        mychart-0.1.0   1.0             default
	[root@k8s ~]# helm history example
	REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION
	1               Tue Nov 19 21:57:30 2019        SUPERSEDED      mychart-0.1.0   1.0             Install complete
	2               Tue Nov 19 22:02:29 2019        SUPERSEDED      mychart-0.1.0   1.0             Upgrade complete
	3               Tue Nov 19 22:04:12 2019        DEPLOYED        mychart-0.1.0   1.0             Upgrade complete
	[root@k8s ~]#

	[root@k8s ~]# helm rollback example 1
	Rollback was a success.
	[root@k8s ~]#
	[root@k8s ~]# helm history example
	REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION
	1               Tue Nov 19 21:57:30 2019        SUPERSEDED      mychart-0.1.0   1.0             Install complete
	2               Tue Nov 19 22:02:29 2019        SUPERSEDED      mychart-0.1.0   1.0             Upgrade complete
	3               Tue Nov 19 22:04:12 2019        SUPERSEDED      mychart-0.1.0   1.0             Upgrade complete
	4               Tue Nov 19 22:09:00 2019        DEPLOYED        mychart-0.1.0   1.0             Rollback to 1
	[root@k8s ~]#
	[root@k8s ~]# helm package ./mychart
	Successfully packaged chart and saved it to: /root/mychart-0.1.0.tgz
	[root@k8s ~]# 
	[root@k8s ~]# helm ls
	NAME    REVISION        UPDATED                         STATUS          CHART           APP VERSION     NAMESPACE
	example 4               Tue Nov 19 22:09:00 2019        DEPLOYED        mychart-0.1.0   1.0             default
	[root@k8s ~]# helm delete example --purge
	release "example" deleted
	[root@k8s ~]#


### Kubernetes Dashboard
	[root@k8s ~]# wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta6/aio/deploy/recommended.yaml

	<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# kubectl create -f recommended.yaml
	namespace/kubernetes-dashboard created
	serviceaccount/kubernetes-dashboard created
	service/kubernetes-dashboard created
	secret/kubernetes-dashboard-certs created
	secret/kubernetes-dashboard-csrf created
	secret/kubernetes-dashboard-key-holder created
	configmap/kubernetes-dashboard-settings created
	role.rbac.authorization.k8s.io/kubernetes-dashboard created
	clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
	rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
	clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
	deployment.apps/kubernetes-dashboard created
	service/dashboard-metrics-scraper created
	deployment.apps/dashboard-metrics-scraper created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n kubernetes-dashboard
	NAME                                             READY   STATUS    RESTARTS   AGE
	pod/dashboard-metrics-scraper-76585494d8-cnhrh   1/1     Running   0          5m54s
	pod/kubernetes-dashboard-b65488c4-bqtlc          1/1     Running   0          5m54s

	NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
	service/dashboard-metrics-scraper   ClusterIP   10.108.155.41    <none>        8000/TCP   5m54s
	service/kubernetes-dashboard        ClusterIP   10.108.235.193   <none>        443/TCP    5m54s

	NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/dashboard-metrics-scraper   1/1     1            1           5m54s
	deployment.apps/kubernetes-dashboard        1/1     1            1           5m54s

	NAME                                                   DESIRED   CURRENT   READY   AGE
	replicaset.apps/dashboard-metrics-scraper-76585494d8   1         1         1       5m54s
	replicaset.apps/kubernetes-dashboard-b65488c4          1         1         1       5m54s
	[root@k8s ~]#
	[root@k8s ~]# kubectl create serviceaccount dashboard-admin-sa
	serviceaccount/dashboard-admin-sa created
	[root@k8s ~]# 
	[root@k8s ~]# kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
	clusterrolebinding.rbac.authorization.k8s.io/dashboard-admin-sa created
	[root@k8s ~]# kubectl get secrets
	NAME                                 TYPE                                  DATA   AGE
	dashboard-admin-sa-token-9wbsq       kubernetes.io/service-account-token   3      102s
	default-token-qjchw                  kubernetes.io/service-account-token   3      5d6h
	nfs-client-provisioner-token-8pk66   kubernetes.io/service-account-token   3      5d2h
	[root@k8s ~]# kubectl describe secret dashboard-admin-sa-token-9wbsq
	Name:         dashboard-admin-sa-token-9wbsq
	Namespace:    default
	Labels:       <none>
	Annotations:  kubernetes.io/service-account.name: dashboard-admin-sa
	              kubernetes.io/service-account.uid: cc676ba7-58ce-4094-9212-7ec3ef73a92f

	Type:  kubernetes.io/service-account-token

	Data
	====
	token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlpiRTkyNEdOSmhuT3VxcV9rZUlSU3M2MldKa3lsMGtiOUh6ZkEtZ3NUaEkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRhc2hib2FyZC1hZG1pbi1zYS10b2tlbi05d2JzcSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tc2EiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJjYzY3NmJhNy01OGNlLTQwOTQtOTIxMi03ZWMzZWY3M2E5MmYiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQtYWRtaW4tc2EifQ.OypjfBHstAToksl2wXCbU0giIooPKpLCqt6gbxA2vvH2IzwrfMWG7XwjaTmVyNqDjWENNsxPDUftqZ96MlDYacaFa3iqlLzUxm94j1b1sikMTmZWm1Nlyb9Fy6-ua05-c3zTkjOQHAy0LGAPRTkUDtbCzuKYfAiyxAN0tAORr3imR-WtwRcSazAQK1ZALTrDk-5anL63UWDSbi6MLTejXx22hdfijfAg1SQFI_H0vCkP8vQHfM0zB-WWfgPkIBj3cqKF4Dupg9eN59_x1xhl9qLcmBb3vByxTI4LwI_3kMcxtwgdGPlp3YGgyCx92BHi7ZYJv5MP4c9KA9mMgiJC_w
	ca.crt:     1025 bytes
	namespace:  7 bytes
	[root@k8s ~]#
	[root@k8s ~]# helm install --name metrics-server stable/metrics-server --namespace metrics --set args={"--kubelet-insecure-tls=true,--kubelet-preferred-address-types=InternalIP\,Hostname\,ExternalIP"}
	NAME:   metrics-server
	LAST DEPLOYED: Tue Nov 19 22:37:54 2019
	NAMESPACE: metrics
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/ClusterRole
	NAME                                     AGE
	system:metrics-server                    1s
	system:metrics-server-aggregated-reader  1s

	==> v1/ClusterRoleBinding
	NAME                                  AGE
	metrics-server:system:auth-delegator  1s
	system:metrics-server                 1s

	==> v1/Deployment
	NAME            AGE
	metrics-server  1s

	==> v1/Pod(related)
	NAME                             AGE
	metrics-server-86846f4bdf-zjcmn  1s

	==> v1/Service
	NAME            AGE
	metrics-server  1s

	==> v1/ServiceAccount
	NAME            AGE
	metrics-server  1s

	==> v1beta1/APIService
	NAME                    AGE
	v1beta1.metrics.k8s.io  1s

	==> v1beta1/RoleBinding
	NAME                        AGE
	metrics-server-auth-reader  1s


	NOTES:
	The metric server has been deployed.

	In a few minutes you should be able to list metrics using the following
	command:

	  kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n metrics
	NAME                                  READY   STATUS    RESTARTS   AGE
	pod/metrics-server-86846f4bdf-zjcmn   1/1     Running   0          85s

	NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
	service/metrics-server   ClusterIP   10.107.21.139   <none>        443/TCP   85s

	NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/metrics-server   1/1     1            1           85s

	NAME                                        DESIRED   CURRENT   READY   AGE
	replicaset.apps/metrics-server-86846f4bdf   1         1         1       85s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete -f recommended.yaml
	namespace "kubernetes-dashboard" deleted
	serviceaccount "kubernetes-dashboard" deleted
	service "kubernetes-dashboard" deleted
	secret "kubernetes-dashboard-certs" deleted
	secret "kubernetes-dashboard-csrf" deleted
	secret "kubernetes-dashboard-key-holder" deleted
	configmap "kubernetes-dashboard-settings" deleted
	role.rbac.authorization.k8s.io "kubernetes-dashboard" deleted
	clusterrole.rbac.authorization.k8s.io "kubernetes-dashboard" deleted
	rolebinding.rbac.authorization.k8s.io "kubernetes-dashboard" deleted
	clusterrolebinding.rbac.authorization.k8s.io "kubernetes-dashboard" deleted
	deployment.apps "kubernetes-dashboard" deleted
	service "dashboard-metrics-scraper" deleted
	deployment.apps "dashboard-metrics-scraper" deleted
	[root@k8s ~]#


### Prometheus
	[root@k8s ~]# helm search prometheus
	NAME                                    CHART VERSION   APP VERSION     DESCRIPTION
	stable/prometheus                       9.3.1           2.13.1          Prometheus is a monitoring system and time series database.
	stable/prometheus-adapter               1.4.0           v0.5.0          A Helm chart for k8s prometheus adapter
	stable/prometheus-blackbox-exporter     1.5.1           0.15.1          Prometheus Blackbox Exporter

		<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# helm search stable/prometheus -l
	NAME                                    CHART VERSION   APP VERSION     DESCRIPTION
	stable/prometheus                       9.3.1           2.13.1          Prometheus is a monitoring system and time series database.
	stable/prometheus                       9.2.0           2.13.1          Prometheus is a monitoring system and time series database.
	stable/prometheus                       9.1.3           2.11.1          Prometheus is a monitoring system and time series database.

		<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# helm install stable/prometheus --name prometheus --namespace prometheus
	NAME:   prometheus
	LAST DEPLOYED: Wed Nov 20 09:39:37 2019
	NAMESPACE: prometheus
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/ConfigMap
	NAME                     AGE
	prometheus-alertmanager  2s
	prometheus-server        2s

	==> v1/DaemonSet
	NAME                      AGE
	prometheus-node-exporter  1s

	==> v1/Deployment
	NAME                           AGE
	prometheus-alertmanager        1s
	prometheus-kube-state-metrics  1s
	prometheus-pushgateway         1s
	prometheus-server              1s

	==> v1/PersistentVolumeClaim
	NAME                     AGE
	prometheus-alertmanager  2s
	prometheus-server        2s

	==> v1/Pod(related)
	NAME                                           AGE
	prometheus-alertmanager-977545d7b-tfwkg        1s
	prometheus-kube-state-metrics-dd4fcf989-9qrtk  1s
	prometheus-node-exporter-bq5t9                 1s
	prometheus-node-exporter-pngn5                 1s
	prometheus-pushgateway-644868fb9c-pq2kv        1s
	prometheus-server-d6c7dbd-zf44h                1s

	==> v1/Service
	NAME                           AGE
	prometheus-alertmanager        1s
	prometheus-kube-state-metrics  1s
	prometheus-node-exporter       1s
	prometheus-pushgateway         1s
	prometheus-server              1s

	==> v1/ServiceAccount
	NAME                           AGE
	prometheus-alertmanager        2s
	prometheus-kube-state-metrics  2s
	prometheus-node-exporter       2s
	prometheus-pushgateway         2s
	prometheus-server              2s

	==> v1beta1/ClusterRole
	NAME                           AGE
	prometheus-alertmanager        2s
	prometheus-kube-state-metrics  2s
	prometheus-pushgateway         2s
	prometheus-server              2s

	==> v1beta1/ClusterRoleBinding
	NAME                           AGE
	prometheus-alertmanager        1s
	prometheus-kube-state-metrics  1s
	prometheus-pushgateway         1s
	prometheus-server              1s


	NOTES:
	The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
	prometheus-server.prometheus.svc.cluster.local


	Get the Prometheus server URL by running these commands in the same shell:
	  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
	  kubectl --namespace prometheus port-forward $POD_NAME 9090


	The Prometheus alertmanager can be accessed via port 80 on the following DNS name from within your cluster:
	prometheus-alertmanager.prometheus.svc.cluster.local


	Get the Alertmanager URL by running these commands in the same shell:
	  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=alertmanager" -o jsonpath="{.items[0].metadata.name}")
	  kubectl --namespace prometheus port-forward $POD_NAME 9093
	#################################################################################
	######   WARNING: Pod Security Policy has been moved to a global property.  #####
	######            use .Values.podSecurityPolicy.enabled with pod-based      #####
	######            annotations                                               #####
	######            (e.g. .Values.nodeExporter.podSecurityPolicy.annotations) #####
	#################################################################################


	The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
	prometheus-pushgateway.prometheus.svc.cluster.local


	Get the PushGateway URL by running these commands in the same shell:
	  export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
	  kubectl --namespace prometheus port-forward $POD_NAME 9091

	For more information on running Prometheus, visit:
	https://prometheus.io/

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n prometheus
	NAME                                                READY   STATUS    RESTARTS   AGE
	pod/prometheus-alertmanager-977545d7b-tfwkg         2/2     Running   0          100s
	pod/prometheus-kube-state-metrics-dd4fcf989-9qrtk   1/1     Running   0          100s
	pod/prometheus-node-exporter-bq5t9                  1/1     Running   0          100s
	pod/prometheus-node-exporter-pngn5                  1/1     Running   0          100s
	pod/prometheus-pushgateway-644868fb9c-pq2kv         1/1     Running   0          100s
	pod/prometheus-server-d6c7dbd-zf44h                 1/2     Running   0          100s

	NAME                                    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
	service/prometheus-alertmanager         ClusterIP   10.101.251.242   <none>        80/TCP     100s
	service/prometheus-kube-state-metrics   ClusterIP   None             <none>        80/TCP     100s
	service/prometheus-node-exporter        ClusterIP   None             <none>        9100/TCP   100s
	service/prometheus-pushgateway          ClusterIP   10.108.136.123   <none>        9091/TCP   100s
	service/prometheus-server               ClusterIP   10.110.152.183   <none>        80/TCP     100s

	NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
	daemonset.apps/prometheus-node-exporter   2         2         2       2            2           <none>          100s

	NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/prometheus-alertmanager         1/1     1            1           100s
	deployment.apps/prometheus-kube-state-metrics   1/1     1            1           100s
	deployment.apps/prometheus-pushgateway          1/1     1            1           100s
	deployment.apps/prometheus-server               0/1     1            0           100s

	NAME                                                      DESIRED   CURRENT   READY   AGE
	replicaset.apps/prometheus-alertmanager-977545d7b         1         1         1       100s
	replicaset.apps/prometheus-kube-state-metrics-dd4fcf989   1         1         1       100s
	replicaset.apps/prometheus-pushgateway-644868fb9c         1         1         1       100s
	replicaset.apps/prometheus-server-d6c7dbd                 1         1         0       100s
	[root@k8s ~]#
	[root@k8s ~]# kubectl -n prometheus edit service prometheus-server
	service/prometheus-server edited
	[root@k8s ~]# kubectl get service -n prometheus
	NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
	prometheus-alertmanager         ClusterIP   10.101.251.242   <none>        80/TCP         3m19s
	prometheus-kube-state-metrics   ClusterIP   None             <none>        80/TCP         3m19s
	prometheus-node-exporter        ClusterIP   None             <none>        9100/TCP       3m19s
	prometheus-pushgateway          ClusterIP   10.108.136.123   <none>        9091/TCP       3m19s
	prometheus-server               NodePort    10.110.152.183   <none>        80:31983/TCP   3m19s
	[root@k8s ~]# 
	[root@k8s ~]# helm ls
	NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
	metrics-server  1               Wed Nov 20 09:46:39 2019        DEPLOYED        metrics-server-2.8.8    0.3.5           metrics
	prometheus      1               Wed Nov 20 09:39:37 2019        DEPLOYED        prometheus-9.3.1        2.13.1          prometheus
	[root@k8s ~]#

### Grafana
	[root@k8s ~]# helm search grafana
	NAME            CHART VERSION   APP VERSION     DESCRIPTION
	stable/grafana  4.0.3           6.4.2           The leading tool for querying and visualizing time series...
	[root@k8s ~]# helm inspect values stable/grafana > /tmp/grafana-values.yaml
	[root@k8s ~]#
	[root@k8s ~]# vim /tmp/grafana-values.yaml
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# helm install stable/grafana --namespace grafana --name grafana -f /tmp/grafana-values.yaml
	NAME:   grafana
	LAST DEPLOYED: Wed Nov 20 10:39:31 2019
	NAMESPACE: grafana
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/ClusterRole
	NAME                 AGE
	grafana-clusterrole  1s

	==> v1/ClusterRoleBinding
	NAME                        AGE
	grafana-clusterrolebinding  1s

	==> v1/ConfigMap
	NAME          AGE
	grafana       1s
	grafana-test  1s

	==> v1/Deployment
	NAME     AGE
	grafana  1s

	==> v1/Pod(related)
	NAME                      AGE
	grafana-6b59847bf6-c5wmv  1s

	==> v1/Role
	NAME          AGE
	grafana-test  1s

	==> v1/RoleBinding
	NAME          AGE
	grafana-test  1s

	==> v1/Secret
	NAME     AGE
	grafana  1s

	==> v1/Service
	NAME     AGE
	grafana  1s

	==> v1/ServiceAccount
	NAME          AGE
	grafana       1s
	grafana-test  1s

	==> v1beta1/PodSecurityPolicy
	NAME          AGE
	grafana       1s
	grafana-test  1s

	==> v1beta1/Role
	NAME     AGE
	grafana  1s

	==> v1beta1/RoleBinding
	NAME     AGE
	grafana  1s


	NOTES:
	1. Get your 'admin' user password by running:

	   kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

	2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

	   grafana.grafana.svc.cluster.local

	   Get the Grafana URL to visit by running these commands in the same shell:

	     export POD_NAME=$(kubectl get pods --namespace grafana -l "app=grafana,release=grafana" -o jsonpath="{.items[0].metadata.name}")
	     kubectl --namespace grafana port-forward $POD_NAME 3000

	3. Login with the password from step 1 and the username: admin
	#################################################################################
	######   WARNING: Persistence is disabled!!! You will lose your data when   #####
	######            the Grafana pod is terminated.                            #####
	#################################################################################

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n grafana
	NAME                           READY   STATUS    RESTARTS   AGE
	pod/grafana-6b59847bf6-c5wmv   1/1     Running   0          59s

	NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
	service/grafana   ClusterIP   10.108.179.185   <none>        80/TCP    59s

	NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/grafana   1/1     1            1           59s

	NAME                                 DESIRED   CURRENT   READY   AGE
	replicaset.apps/grafana-6b59847bf6   1         1         1       59s
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -n grafana
	NAME                           READY   STATUS    RESTARTS   AGE
	pod/grafana-6b59847bf6-c5wmv   1/1     Running   0          59s

	NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
	service/grafana   ClusterIP   10.108.179.185   <none>        80/TCP    59s

	NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/grafana   1/1     1            1           59s

	NAME                                 DESIRED   CURRENT   READY   AGE
	replicaset.apps/grafana-6b59847bf6   1         1         1       59s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl -n grafana edit service grafana
	service/grafana edited
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl -n grafana get service
	NAME      TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
	grafana   NodePort   10.108.179.185   <none>        80:32340/TCP   118s
	[root@k8s ~]#
	[root@k8s ~]# helm ls
	NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
	grafana         1               Wed Nov 20 10:39:31 2019        DEPLOYED        grafana-4.0.3           6.4.2           grafana
	metrics-server  1               Wed Nov 20 09:46:39 2019        DEPLOYED        metrics-server-2.8.8    0.3.5           metrics
	prometheus      1               Wed Nov 20 09:50:04 2019        DEPLOYED        prometheus-9.3.1        2.13.1          prometheus
	[root@k8s ~]# helm delete --purge grafana
	release "grafana" deleted
	[root@k8s ~]# helm delete --purge prometheus
	release "prometheus" deleted
	[root@k8s ~]#
	[root@k8s ~]# helm delete --purge metrics-server
	release "metrics-server" deleted
	[root@k8s ~]#

### Rancher
	[root@k8s ~]# sudo docker run -d --restart=unless-stopped --name=rancher  -p 8080:80 -p 8443:443 rancher/rancher
	d87179359c73b96e8fc5bf23609ebefb1b20d01fb32abff89f1f29b06549ab61
	[root@k8s ~]# docker ps
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                         NAMES
	d87179359c73        rancher/rancher     "entrypoint.sh"     6 seconds ago       Up 5 seconds        0.0.0.0:8080->80/tcp, 0.0.0.0:8443->443/tcp   rancher
	[root@k8s ~]#

	[root@k8s ~]# kubectl get all -n cattle-system
	NAME                                       READY   STATUS    RESTARTS   AGE
	pod/cattle-cluster-agent-d55c6658c-szccf   1/1     Running   0          3m26s
	pod/cattle-node-agent-7bxmp                1/1     Running   0          24s
	pod/cattle-node-agent-h5rzz                1/1     Running   0          3m21s
	pod/cattle-node-agent-qf98z                1/1     Running   0          3m20s

	NAME                               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
	daemonset.apps/cattle-node-agent   3         3         3       3            3           <none>          6m2s

	NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
	deployment.apps/cattle-cluster-agent   1/1     1            1           6m2s

	NAME                                              DESIRED   CURRENT   READY   AGE
	replicaset.apps/cattle-cluster-agent-566f5cc999   0         0         0       6m2s
	replicaset.apps/cattle-cluster-agent-d55c6658c    1         1         1       3m27s
	[root@k8s ~]#
				
