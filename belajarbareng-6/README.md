# Belajar Bareng 5

## Table of Contents
* [Jenkins](#Jenkins)
* [Horizontal Pod Autoscaler](#Horizontal-Pod-Autoscaler)


### Jenkins
	helm install jenkins stable/jenkins --values /root/materials/jenkins.value


### Horizontal Pod Autoscaler
	helm install metric-servers stable/metrics-server --values /root/materials/metrics-server.value
	kubectl run php-apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --limits=cpu=500m --expose --port=80
	kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=5
	kubectl get hpa
	kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
	while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done