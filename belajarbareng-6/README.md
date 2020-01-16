# Belajar Bareng 5

## Table of Contents
* [Jenkins](#Jenkins)
* [Horizontal Pod Autoscaler](#Horizontal-Pod-Autoscaler)


### Jenkins
	docker run -d -p 5000:5000 --restart always --name registry -v docker:/var/lib/registry registry:2
	kubectl create namespace jenkins
	helm install jenkins stable/jenkins --values ./materials/jenkins.value -n jenkins


### Horizontal Pod Autoscaler
	kubectl create namespace metrics-server
	helm install metric-servers stable/metrics-server --values ./materials/metrics-server.value -n metrics-server
	kubectl run php-apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --limits=cpu=500m --expose --port=80
	kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=5
	kubectl get hpa
	kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
	while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done