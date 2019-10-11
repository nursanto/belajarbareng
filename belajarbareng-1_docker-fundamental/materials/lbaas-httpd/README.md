## note
	docker run -dit --name my-app1 -p 7001:80 -v /root/lbaas-httpd/web1:/usr/local/apache2/htdocs/ httpd
	docker run -dit --name my-app2 -p 7002:80 -v /root/lbaas-httpd/web2:/usr/local/apache2/htdocs/ httpd
	docker build -t nginxbalancer:001 nginx/
	docker container run -dit --name nginxbalancer -p 7000:80 nginxbalancer:001