## belajarbareng-2 / 24-10-2019 
* where ip pool for service kubernetes store
	## ip pool for pod
	[root@k8s ~]# k get ippool -A
	NAME                  AGE
	default-ipv4-ippool   18h
	[root@k8s ~]#
	[root@k8s ~]# k describe ippool default-ipv4-ippool
	Name:         default-ipv4-ippool
	Namespace:
	Labels:       <none>
	Annotations:  projectcalico.org/metadata: {"uid":"4dde6dd2-3489-44de-b313-a354dcc93f38","creationTimestamp":"2019-10-24T12:54:10Z"}
	API Version:  crd.projectcalico.org/v1
	Kind:         IPPool
	Metadata:
	  Creation Timestamp:  2019-10-24T12:54:10Z
	  Generation:          1
	  Resource Version:    1441
	  Self Link:           /apis/crd.projectcalico.org/v1/ippools/default-ipv4-ippool
	  UID:                 aaf54cc1-7fd7-41a5-b18a-03312ce12d51
	Spec:
	  Block Size:     26
	  Cidr:           192.168.0.0/16
	  Ipip Mode:      Always
	  Nat Outgoing:   true
	  Node Selector:  all()
	  Vxlan Mode:     Never
	Events:           <none>
	[root@k8s ~]#

	## ip pool for cluster ip
	[root@k8s ~]# kubectl get pod/kube-apiserver-kmaster.example.com -n kube-system -o yaml | grep  service-cluster-ip-range
    - --service-cluster-ip-range=10.96.0.0/12
	[root@k8s ~]#

	https://rancher.com/docs/rke/latest/en/config-options/services/

* poweroff worker, pod not replicated to another worker