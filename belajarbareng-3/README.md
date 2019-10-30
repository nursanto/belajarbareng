# Belajar Bareng 3

## Table of Contents
* [APIs and Access](#APIs-and-Access)
* [API Objects](#API-Objects)
* [Managing State with Deployments](#Managing-State-with-Deployments)
* [Jobs and Cron Jobs](#Jobs-and-Cron-Jobs)
* [Scheduling](#Scheduling)
* [Volumes and Data](#Volumes-and-Data)


### APIs and Access

	[root@k8s ~]# kubectl cluster-info
	Kubernetes master is running at https://172.42.42.100:6443
	KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

	To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
	[root@k8s ~]#
	[root@k8s ~]# less ~/.kube/config
	[root@k8s ~]# export client=$(grep client-cert ~/.kube/config |cut -d" " -f 6)
	[root@k8s ~]# echo $client
	LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM4akNDQWRxZ0F3SUJBZ0lJYjVnSDA1SUh2S1V3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB4T1RFd01qWXhNelUwTlROYUZ3MHlNREV3TWpVeE16VTBOVFphTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXY3ZWZCcTlzQVpIcW0rWU8KcmJCNmU2RVFIRXV5aVl2LzFXbDl4TFhDdHJTTDNLWmd3RitZalMreHN3UEROMGNkN3k4anp6UGovQnJ2VEUxUgp2YjdHZDhBRW56ZHRRY3htTUVZRGFHbGxMNWtWZ0l4aWk5d2lpaERQTFhOc3RYRE56SU1TcENBTDVrTmZBM2RnCkhsV3F6ZUg0M2xIWGVLdkdoMTlaMFV2dEJxQ2tIK2U3RFZSZStIczZ4bEd0OWxFdDNGa2xnU210OXVsS3htYzAKV1hsMU5FdDl3cTBXV2RVWFJYZHFhNHRORU5weWRMMFF1MjkybFYxNWdyNWc3aTl6dHA0N21MRjVJdFBUdUgrZwpGQVdrZFhXNk5tS2wvT1JSaHNjdFRnK2R3cHU2Sjh4SmgvaWswU1ZEL2pkS1U4cmU2R012TE5YTmdaays1WnhFCmEyVzExd0lEQVFBQm95Y3dKVEFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFLbEZnVTZRb2JIbG04WUZSOWFuSnh1TmQ4enZaYWwwSVJBNwpNYWdWYzZUY0ZBaXByNGpPYU9tdGxEeVhXcmlOQnNyU3kyYlZMNUdXR2UvRXZReG5mSk0xaTk4NFQ4OHlPeUJICldHSjRKQUhxRkEvdFNGUU9BaEVJUXJWUUFRWldZQ2h2N3ZSVkVlV29vNXpycmRjQmdaVXVOYklRdG5FL0tjbVUKM296d0RodUhodldVeHpYa250cGg0cDVKNWVVREZsWEpkRWdDM0RzRkdNZkxoWW9yK202MVNaWVdrbC9oODNscApsUjUwd0xQYldRNm15ZWQwR3lteW5hMStOUmp4d0k4U214WFphT05LdE1wWjRIMjdvaHQvVDZCMDN3RnZMb2tQCmlHZFE5SjBRaWpiZjZKeW1iV3FxZjdMc2N5bTY0RC9ndnJqSVdpditKZVl5TE5Id0kzVT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
	[root@k8s ~]#
	[root@k8s ~]# export key=$(grep client-key-data ~/.kube/config |cut -d " " -f 6)
	[root@k8s ~]# echo $key

	<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# export auth=$(grep certificate-authority-data ~/.kube/config |cut -d " " -f 6)
	[root@k8s ~]# echo $auth

	<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# echo $client | base64 -d - > ./client.pem
	[root@k8s ~]# echo $key | base64 -d - > ./client-key.pem
	[root@k8s ~]# echo $auth | base64 -d - > ./ca.pem
	[root@k8s ~]# kubectl config view
	apiVersion: v1
	clusters:
	- cluster:
	    certificate-authority-data: DATA+OMITTED
	    server: https://172.42.42.100:6443
	  name: kubernetes
	contexts:
	- context:
	    cluster: kubernetes
	    user: kubernetes-admin
	  name: kubernetes-admin@kubernetes
	current-context: kubernetes-admin@kubernetes
	kind: Config
	preferences: {}
	users:
	- name: kubernetes-admin
	  user:
	    client-certificate-data: REDACTED
	    client-key-data: REDACTED
	[root@k8s ~]# kubectl config view |grep server
	    server: https://172.42.42.100:6443
	[root@k8s ~]#
	[root@k8s ~]# curl --cert ./client.pem --key ./client-key.pem --cacert ./ca.pem https://172.42.42.100:6443/api/v1/pods
	{
	  "kind": "PodList",
	  "apiVersion": "v1",
	  "metadata": {
	    "selfLink": "/api/v1/pods",
	    "resourceVersion": "293936"
	  },
	  "items": [
	    {

	<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d22h
	[root@k8s ~]# curl --cert ./client.pem --key ./client-key.pem --cacert ./ca.pem https://172.42.42.100:6443/api/v1/namespaces/default/pods -XPOST -H'Content-Type: application/json' -d@01-curlpod.json
	{
	  "kind": "Pod",
	  "apiVersion": "v1",
	  "metadata": {
	    "name": "curlpod",
	    "namespace": "default",
	    "selfLink": "/api/v1/namespaces/default/pods/curlpod",
	    "uid": "8ef2466c-8f7d-4084-9437-6c4f74866139",
	    "resourceVersion": "294342",
	    "creationTimestamp": "2019-10-29T12:44:20Z",
	    "labels": {
	      "name": "examplepod"
	    }
	  },

	<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME          READY   STATUS    RESTARTS   AGE
	pod/curlpod   1/1     Running   0          35s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d22h
	[root@k8s ~]#
	[root@k8s ~]# kubectl get endpoints
	NAME         ENDPOINTS            AGE
	kubernetes   172.42.42.100:6443   2d22h
	[root@k8s ~]#
	[root@k8s ~]# strace kubectl get endpoints
	execve("/usr/local/bin/kubectl", ["kubectl", "get", "endpoints"], [/* 25 vars */]) = 0

	....
	openat(AT_FDCWD, "/root/.kube/cache/discovery/172.42.42.100_6443/admissionregistration.k8s.io/v1beta1/serverresources.json", O_RDONLY|O_CLOEXEC) = 3

	<output_omitted>

	[root@k8s ~]# cd /root/.kube/cache/discovery/
	[root@k8s ~]# cd /root/.kube/cache/discovery/
	[root@k8s discovery]# ls
	172.42.42.100_6443
	[root@k8s discovery]# cd 172.42.42.100_6443/
	[root@k8s 172.42.42.100_6443]# ls
	admissionregistration.k8s.io  apps                   autoscaling          coordination.k8s.io    extensions         policy                     servergroups.json
	apiextensions.k8s.io          authentication.k8s.io  batch                crd.projectcalico.org  networking.k8s.io  rbac.authorization.k8s.io  storage.k8s.io
	apiregistration.k8s.io        authorization.k8s.io   certificates.k8s.io  events.k8s.io          node.k8s.io        scheduling.k8s.io          v1
	[root@k8s 172.42.42.100_6443]#
	[root@k8s 172.42.42.100_6443]# find .
	.
	./servergroups.json
	./crd.projectcalico.org
	./crd.projectcalico.org/v1
	./crd.projectcalico.org/v1/serverresources.json
	./authentication.k8s.io
	./authentication.k8s.io/v1
	./authentication.k8s.io/v1/serverresources.json
	./authentication.k8s.io/v1beta1

	<output_omitted>

	[root@k8s ~]#
	[root@k8s 172.42.42.100_6443]# python -m json.tool v1/serverresources.json
	{
	    "apiVersion": "v1",
	    "groupVersion": "v1",
	    "kind": "APIResourceList",
	    "resources": [
	        {
	            "kind": "Binding",
	            "name": "bindings",
	            "namespaced": true,
	            "singularName": "",
	            "verbs": [
	                "create"
	            ]
	        },

	<output_omitted>

	[root@k8s ~]#
	[root@k8s 172.42.42.100_6443]# python -m json.tool v1/serverresources.json | grep kind
	    "kind": "APIResourceList",
	            "kind": "Binding",
	            "kind": "ComponentStatus",
	            "kind": "ConfigMap",
	            "kind": "Endpoints",

	<output_omitted>

	[root@k8s ~]#
	[root@k8s 172.42.42.100_6443]# kubectl get all
	NAME          READY   STATUS    RESTARTS   AGE
	pod/curlpod   1/1     Running   0          10m

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d22h
	[root@k8s 172.42.42.100_6443]# kubectl delete pod/curlpod
	pod "curlpod" deleted
	[root@k8s 172.42.42.100_6443]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d22h
	[root@k8s 172.42.42.100_6443]# cd
	[root@k8s ~]#


### API Objects

	[root@k8s ~]# kubectl cluster-info
	Kubernetes master is running at https://172.42.42.100:6443
	KubeDNS is running at https://172.42.42.100:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

	To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
	[root@k8s ~]#
	[root@k8s ~]# kubectl get secrets --all-namespaces
	NAMESPACE         NAME                                             TYPE                                  DATA   AGE
	default           default-token-rnlst                              kubernetes.io/service-account-token   3      2d23h
	kube-node-lease   default-token-6b86l                              kubernetes.io/service-account-token   3      2d23h
	kube-public       default-token-d4nmp                              kubernetes.io/service-account-token   3      2d23h

		<output_omitted>

	[root@k8s ~]# kubectl describe secret default-token-rnlst
	Name:         default-token-rnlst
	Namespace:    default
	Labels:       <none>
	Annotations:  kubernetes.io/service-account.name: default
	              kubernetes.io/service-account.uid: 2fd4362f-0033-4120-b433-8fcc47946c27

	Type:  kubernetes.io/service-account-token

	Data
	====
	ca.crt:     1025 bytes
	namespace:  7 bytes
	token:      eyJhbGciOiJSUzI1NiIsImtpZCI6Inp0bnl2bDdRYjJRcnFwd2d0RzRaR1A1akp6UHFwbUE0QV9Jal9mdXp1SEkifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tcm5sc3QiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjJmZDQzNjJmLTAwMzMtNDEyMC1iNDMzLThmY2M0Nzk0NmMyNyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.jXpe_d_NtX1qTNHB_Hd6FvKsghF-TpEm_ONTlSKq9du2mg0ZCWrd-5RtaiXlCoSK15pCxMMWNr33XSUivTDWTGZ8bmVKi7FxLcNlin1poPpcLaQiC7ylxxaa1ey-03AVv17pE2qkhfxZmKUIOnmXvKgmdveICH_4adobinUokypPUalbeoGIwK_axThj8cvnweufIO22WQ6uCSIC7pLOwB31lIItmd4Qum5ws1pE88vltPQgQ0U-7Uoqqyi4rXwXr5nEWeUmT7HIlK-PrJaqRorOKzK76_yzMn9hytYMXVgHnkph2xjsBWwieh2bHBqSYYbwQ-_vPMjuBVfOnQOWHg
	[root@k8s ~]# 

	[root@k8s ~]# export token=$(kubectl describe secret default-token-rnlst |grep ^token |cut -f7 -d ' ')
	[root@k8s ~]# curl https://172.42.42.100:6443/apis --header "Authorization: Bearer $token" -k
	{
	  "kind": "APIGroupList",
	  "apiVersion": "v1",
	  "groups": [
	    {
	      "name": "apiregistration.k8s.io",
	      "versions": [
	        {
	          "groupVersion": "apiregistration.k8s.io/v1",
	          "version": "v1"
	        },
	        {
	          "groupVersion": "apiregistration.k8s.io/v1beta1",
	          "version": "v1beta1"
	        }
	      ],

		<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# curl https://172.42.42.100:6443/api/v1 --header "Authorization: Bearer $token" -k
	{
	  "kind": "APIResourceList",
	  "groupVersion": "v1",
	  "resources": [
	    {
	      "name": "bindings",
	      "singularName": "",
	      "namespaced": true,
	      "kind": "Binding",
	      "verbs": [
	        "create"
	      ]
	    },

		<output_omitted>

	[root@k8s ~]#
	[root@k8s ~]# curl https://172.42.42.100:6443/api/v1/namespaces --header "Authorization: Bearer $token" -k
	{
	  "kind": "Status",
	  "apiVersion": "v1",
	  "metadata": {

	  },
	  "status": "Failure",
	  "message": "namespaces is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"namespaces\" in API group \"\" at the cluster scope",
	  "reason": "Forbidden",
	  "details": {
	    "kind": "namespaces"
	  },
	  "code": 403
	}[root@k8s ~]#
	[root@k8s ~]# kubectl proxy --api-prefix=/ &
	[1] 8563
	[root@k8s ~]# Starting to serve on 127.0.0.1:8001

	[root@k8s ~]# curl http://127.0.0.1:8001/api/v1/namespaces
	{
	  "kind": "NamespaceList",
	  "apiVersion": "v1",
	  "metadata": {
	    "selfLink": "/api/v1/namespaces",
	    "resourceVersion": "299353"
	  },
	  "items": [
	    {

		<output_omitted>

	[root@k8s ~]#

### Managing State with Deployments

	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-rs-nginx.yaml
	replicaset.apps/frontend created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 READY   STATUS    RESTARTS   AGE
	pod/frontend-p7wnr   1/1     Running   0          47s
	pod/frontend-zf2gb   1/1     Running   0          47s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d

	NAME                       DESIRED   CURRENT   READY   AGE
	replicaset.apps/frontend   2         2         2       47s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete replicaset.apps/frontend --cascade=false
	replicaset.apps "frontend" deleted
	[root@k8s ~]# kubectl get all
	NAME                 READY   STATUS    RESTARTS   AGE
	pod/frontend-p7wnr   1/1     Running   0          85s
	pod/frontend-zf2gb   1/1     Running   0          85s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d
	[root@k8s ~]# kubectl apply -f 02-rs-nginx.yaml
	replicaset.apps/frontend created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 READY   STATUS    RESTARTS   AGE
	pod/frontend-p7wnr   1/1     Running   0          94s
	pod/frontend-zf2gb   1/1     Running   0          94s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d

	NAME                       DESIRED   CURRENT   READY   AGE
	replicaset.apps/frontend   2         2         2       3s
	[root@k8s ~]#
	[root@k8s ~]# kubectl edit pod/frontend-p7wnr
	pod/frontend-p7wnr edited
	[root@k8s ~]#
	[root@k8s ~]# kubectl get pods --show-labels
	NAME             READY   STATUS    RESTARTS   AGE   LABELS
	frontend-p7wnr   1/1     Running   0          14m   tier=IsolatedPod
	frontend-w6tlt   1/1     Running   0          15s   tier=frontend
	frontend-zf2gb   1/1     Running   0          14m   tier=frontend
	[root@k8s ~]# kubectl get all --show-labels
	NAME                 READY   STATUS    RESTARTS   AGE   LABELS
	pod/frontend-p7wnr   1/1     Running   0          14m   tier=IsolatedPod
	pod/frontend-w6tlt   1/1     Running   0          23s   tier=frontend
	pod/frontend-zf2gb   1/1     Running   0          14m   tier=frontend

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    LABELS
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h   component=apiserver,provider=kubernetes

	NAME                       DESIRED   CURRENT   READY   AGE   LABELS
	replicaset.apps/frontend   2         2         2       13m   tier=frontend
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete replicaset.apps/frontend
	replicaset.apps "frontend" deleted
	[root@k8s ~]# 
	[root@k8s ~]# kubectl get all --show-labels
	NAME                 READY   STATUS    RESTARTS   AGE   LABELS
	pod/frontend-p7wnr   1/1     Running   0          18m   tier=IsolatedPod

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    LABELS
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h   component=apiserver,provider=kubernetes
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 02-ds-nginx.yaml
	daemonset.apps/frontend created
	[root@k8s ~]# kubectl get all
	NAME                 READY   STATUS    RESTARTS   AGE
	pod/frontend-5ltgf   1/1     Running   0          17s
	pod/frontend-xscgs   1/1     Running   0          17s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h

	NAME                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
	daemonset.apps/frontend   2         2         2       2            2           <none>          17s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -o wide
	NAME                 READY   STATUS    RESTARTS   AGE   IP               NODE                   NOMINATED NODE   READINESS GATES
	pod/frontend-5ltgf   1/1     Running   0          31s   192.168.33.203   kworker1.example.com   <none>           <none>
	pod/frontend-xscgs   1/1     Running   0          31s   192.168.136.72   kworker2.example.com   <none>           <none>

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h   <none>

	NAME                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE   CONTAINERS   IMAGES   SELECTOR
	daemonset.apps/frontend   2         2         2       2            2           <none>          31s   tes-nginx    nginx    tier=frontend
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d13h
	[root@k8s ~]# kubectl apply -f 02-ds-nginx.yaml
	daemonset.apps/frontend created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all -o wide
	NAME                 READY   STATUS    RESTARTS   AGE   IP               NODE                   NOMINATED NODE   READINESS GATES
	pod/frontend-bvws9   1/1     Running   0          19s   192.168.136.74   kworker2.example.com   <none>           <none>
	pod/frontend-qpxb7   1/1     Running   0          19s   192.168.33.205   kworker1.example.com   <none>           <none>

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE     SELECTOR
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d13h   <none>

	NAME                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE   CONTAINERS   IMAGES              SELECTOR
	daemonset.apps/frontend   2         2         2       2            2           <none>          19s   tes-nginx    nginx:1.17-alpine   tier=frontend
	[root@k8s ~]# kubectl get all --show-labels
	NAME                 READY   STATUS    RESTARTS   AGE   LABELS
	pod/frontend-bvws9   1/1     Running   0          31s   controller-revision-hash=99b57cd88,pod-template-generation=1,tier=frontend
	pod/frontend-qpxb7   1/1     Running   0          31s   controller-revision-hash=99b57cd88,pod-template-generation=1,tier=frontend

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE     LABELS
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d13h   component=apiserver,provider=kubernetes

	NAME                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE   LABELS
	daemonset.apps/frontend   2         2         2       2            2           <none>          31s   tier=frontend
	[root@k8s ~]# kubectl delete daemonset.apps/frontend
	daemonset.apps "frontend" deleted
	[root@k8s ~]# kubectl get all
	NAME                 READY   STATUS        RESTARTS   AGE
	pod/frontend-qpxb7   0/1     Terminating   0          74s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d13h
	[root@k8s ~]#


### Jobs and Cron Jobs
#### Jobs
* Default Run
* Killing Pod Restarts Pod
* completions
* parallelism
* backoffLimit
* activeDeatlineSeconds

	[root@k8s ~]# kubectl apply -f 03-job-1.yaml
	job.batch/helloworld created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS      RESTARTS   AGE
	pod/helloworld-fdgfs   0/1     Completed   0          85s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   1/1           10s        85s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-job-2.yaml
	job.batch/helloworld created
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS    RESTARTS   AGE
	pod/helloworld-r9g2w   1/1     Running   0          7s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   0/1           7s         8s
	[root@k8s ~]# kubectl delete pod/helloworld-r9g2w
	pod "helloworld-r9g2w" deleted

	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS      RESTARTS   AGE
	pod/helloworld-dhgq5   0/1     Completed   0          61s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   1/1           74s        84s
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-job-3.yaml

	job.batch/helloworld created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS      RESTARTS   AGE
	pod/helloworld-6mzxj   0/1     Completed   0          85s
	pod/helloworld-mn5gb   0/1     Completed   0          113s
	pod/helloworld-zpsfv   0/1     Completed   0          2m20s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   3/3           82s        2m20s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-job-4.yaml
	job.batch/helloworld created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS              RESTARTS   AGE
	pod/helloworld-982fw   0/1     ContainerCreating   0          5s
	pod/helloworld-hm6k6   0/1     ContainerCreating   0          5s
	pod/helloworld-wpcgl   0/1     ContainerCreating   0          5s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   0/3           5s         5s
	[root@k8s ~]#
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS      RESTARTS   AGE
	pod/helloworld-982fw   0/1     Completed   0          87s
	pod/helloworld-hm6k6   0/1     Completed   0          87s
	pod/helloworld-wpcgl   0/1     Completed   0          87s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   3/3           33s        87s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-job-5.yaml
	job.batch/helloworld created
	[root@k8s ~]#
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS              RESTARTS   AGE
	pod/helloworld-6g8lb   0/1     Error               0          18s
	pod/helloworld-9khbh   0/1     Error               0          11s
	pod/helloworld-rv4rk   0/1     ContainerCreating   0          1s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   0/1           18s        18s
	[root@k8s ~]#
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#
	[root@k8s ~]# kubectl apply -f 03-job-6.yaml
	job.batch/helloworld created
	[root@k8s ~]# kubectl get all
	NAME                   READY   STATUS        RESTARTS   AGE
	pod/helloworld-nwfv4   1/1     Terminating   0          31s

	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h

	NAME                   COMPLETIONS   DURATION   AGE
	job.batch/helloworld   0/1           31s        32s
	[root@k8s ~]# kubectl describe job.batch/helloworld | tail
	      40
	    Environment:  <none>
	    Mounts:       <none>
	  Volumes:        <none>
	Events:
	  Type     Reason            Age                            From            Message
	  ----     ------            ----                           ----            -------
	  Normal   SuccessfulCreate  <invalid>                      job-controller  Created pod: helloworld-nwfv4
	  Normal   SuccessfulDelete  <invalid>                      job-controller  Deleted pod: helloworld-nwfv4
	  Warning  DeadlineExceeded  <invalid> (x2 over <invalid>)  job-controller  Job was active longer than specified deadline
	[root@k8s ~]# kubectl delete job.batch/helloworld
	job.batch "helloworld" deleted
	[root@k8s ~]# kubectl get all
	NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d14h
	[root@k8s ~]#

#### Cron Jobs
* Default Run
* deleting cronjobs
* failedJobsHistoryLimit
* suspending cron jobs
* concurrencyPloicy
* idempotency

[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h
[root@k8s ~]# vim 04-cronjob-1.yaml
[root@k8s ~]# kubectl apply -f 04-cronjob-1.yaml
cronjob.batch/helloworld-cron created
[root@k8s ~]# kubectl get all
NAME                                   READY   STATUS      RESTARTS   AGE
pod/helloworld-cron-1572416220-vxrfd   0/1     Completed   0          68s
pod/helloworld-cron-1572416280-gmz2n   0/1     Completed   0          8s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h

NAME                                   COMPLETIONS   DURATION   AGE
job.batch/helloworld-cron-1572416220   1/1           8s         68s
job.batch/helloworld-cron-1572416280   1/1           8s         8s

NAME                            SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/helloworld-cron   * * * * *   False     1        13s             96s
[root@k8s ~]# kubectl delete cronjob.batch/helloworld-cron
cronjob.batch "helloworld-cron" deleted
[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h
[root@k8s ~]#
[root@k8s ~]# kubectl apply -f 04-cronjob-2.yaml
cronjob.batch/helloworld-cron created
[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h

NAME                            SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/helloworld-cron   * * * * *   False     0        35s             2m4s
[root@k8s ~]# kubectl delete cronjob.batch/helloworld-cron
cronjob.batch "helloworld-cron" deleted
[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h
[root@k8s ~]#
[root@k8s ~]# kubectl create -f 04-cronjob-3.yaml
cronjob.batch/helloworld-cron created
[root@k8s ~]# kubectl get all
NAME                                   READY   STATUS      RESTARTS   AGE
pod/helloworld-cron-1572417060-j62f9   0/1     Completed   0          90s
pod/helloworld-cron-1572417120-klp5x   0/1     Completed   0          29s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h

NAME                                   COMPLETIONS   DURATION   AGE
job.batch/helloworld-cron-1572417060   1/1           8s         90s
job.batch/helloworld-cron-1572417120   1/1           7s         29s

NAME                            SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/helloworld-cron   * * * * *   False     0        37s             2m17s
[root@k8s ~]# kubectl apply -f 04-cronjob-3-suspend.yaml
NAME                                   READY   STATUS      RESTARTS   AGE
pod/helloworld-cron-1572417180-dqv4q   0/1     Completed   0          2m21s
pod/helloworld-cron-1572417240-zs9nw   0/1     Completed   0          81s
pod/helloworld-cron-1572417300-fh946   0/1     Completed   0          20s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h

NAME                                   COMPLETIONS   DURATION   AGE
job.batch/helloworld-cron-1572417180   1/1           8s         2m21s
job.batch/helloworld-cron-1572417240   1/1           8s         81s
job.batch/helloworld-cron-1572417300   1/1           7s         20s

NAME                            SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/helloworld-cron   * * * * *   True      0        29s             5m9s
[root@k8s ~]#
[root@k8s ~]# kubectl patch cronjob helloworld-cron -p '{"spec":{"suspend":false}}'
cronjob.batch/helloworld-cron patched
[root@k8s ~]# kubectl get all
NAME                                   READY   STATUS      RESTARTS   AGE
pod/helloworld-cron-1572417180-dqv4q   0/1     Completed   0          4m57s
pod/helloworld-cron-1572417240-zs9nw   0/1     Completed   0          3m57s
pod/helloworld-cron-1572417300-fh946   0/1     Completed   0          2m56s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h

NAME                                   COMPLETIONS   DURATION   AGE
job.batch/helloworld-cron-1572417180   1/1           8s         4m57s
job.batch/helloworld-cron-1572417240   1/1           8s         3m57s
job.batch/helloworld-cron-1572417300   1/1           7s         2m56s

NAME                            SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/helloworld-cron   * * * * *   False     0        3m5s            7m45s
[root@k8s ~]# kubectl delete cronjob.batch/helloworld-cron
cronjob.batch "helloworld-cron" deleted
[root@k8s ~]# kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d16h
[root@k8s ~]#



### Scheduling



### Volumes and Data

	#
