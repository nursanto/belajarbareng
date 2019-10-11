# Docker Fundamental
![mierebus](./materials/mie.jpg "mierebus")

## Table of Contents
* [Docker Overview](#Docker-Overview)
* [Building Container Images](#Building-Container-Images)
* [Storing and Distributing Images](#Storing-and-Distributing-Images)
* [Managing Containers](#Managing-Containers)
* [Docker Compose](#Docker-Compose)


## Docker Overview
	[root@docker ~]# yum -y install docker
	Loaded plugins: fastestmirror
	Loading mirror speeds from cached hostfile
	 * base: centos.usonyx.net
	 * extras: mirror.newmediaexpress.com
	 * updates: mirror.newmediaexpress.com
	Resolving Dependencies
	--> Running transaction check
	...output omitted...
	[root@docker ~]# 
	[root@docker ~]# systemctl start docker && systemctl enable docker
	Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
	[root@docker ~]# docker version
	Client:
	 Version:         1.13.1
	 API version:     1.26
	 Package version: docker-1.13.1-103.git7f2769b.el7.centos.x86_64
	 Go version:      go1.10.3
	 Git commit:      7f2769b/1.13.1
	 Built:           Sun Sep 15 14:06:47 2019
	 OS/Arch:         linux/amd64

	Server:
	 Version:         1.13.1
	 API version:     1.26 (minimum version 1.12)
	 Package version: docker-1.13.1-103.git7f2769b.el7.centos.x86_64
	 Go version:      go1.10.3
	 Git commit:      7f2769b/1.13.1
	 Built:           Sun Sep 15 14:06:47 2019
	 OS/Arch:         linux/amd64
	 Experimental:    false
	[root@docker ~]#
	[root@docker ~]#
	[root@docker ~]# curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
	                                 Dload  Upload   Total   Spent    Left  Speed
	100   617    0   617    0     0   1004      0 --:--:-- --:--:-- --:--:--  1004
	100 11.2M  100 11.2M    0     0  1535k      0  0:00:07  0:00:07 --:--:-- 2323k
	[root@docker ~]# chmod +x /usr/local/bin/docker-compose
	[root@docker ~]# docker-compose --version
	docker-compose version 1.23.2, build 1110ad01
	[root@docker ~]#
	[root@docker ~]# docker container run hello-world
	Unable to find image 'hello-world:latest' locally
	Trying to pull repository docker.io/library/hello-world ...
	latest: Pulling from docker.io/library/hello-world
	1b930d010525: Pull complete
	Digest: sha256:b8ba256769a0ac28dd126d584e0a2011cd2877f3f76e093a7ae560f2a5301c00
	Status: Downloaded newer image for docker.io/hello-world:latest

	Hello from Docker!
	This message shows that your installation appears to be working correctly.

	To generate this message, Docker took the following steps:
	 1. The Docker client contacted the Docker daemon.
	 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
	    (amd64)
	 3. The Docker daemon created a new container from that image which runs the
	    executable that produces the output you are currently reading.
	 4. The Docker daemon streamed that output to the Docker client, which sent it
	    to your terminal.

	To try something more ambitious, you can run an Ubuntu container with:
	 $ docker run -it ubuntu bash

	Share images, automate workflows, and more with a free Docker ID:
	 https://hub.docker.com/

	For more examples and ideas, visit:
	 https://docs.docker.com/get-started/

	[root@docker ~]#
	[root@docker ~]# docker image pull nginx
	Using default tag: latest
	Trying to pull repository docker.io/library/nginx ...
	latest: Pulling from docker.io/library/nginx
	b8f262c62ec6: Pull complete
	e9218e8f93b1: Pull complete
	7acba7289aa3: Pull complete
	Digest: sha256:aeded0f2a861747f43a01cf1018cf9efe2bdd02afd57d2b11fcc7fcadc16ccd1
	Status: Downloaded newer image for docker.io/nginx:latest
	[root@docker ~]#
	[root@docker ~]# docker image ls
	REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
	docker.io/nginx         latest              f949e7d76d63        7 days ago          126 MB
	docker.io/hello-world   latest              fce289e99eb9        9 months ago        1.84 kB
	[root@docker ~]#
	[root@docker ~]#
	[root@docker ~]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
	dda109e244d1        hello-world         "/hello"            2 minutes ago       Exited (0) 2 minutes ago                       friendly_mcclintock
	[root@docker ~]# docker container run -d --name nginx-test -p 8080:80 nginx
	adef80e110efeb1245cf5598186278079111022a6531a26c330bfe9d730ca627
	[root@docker ~]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS                  NAMES
	adef80e110ef        nginx               "nginx -g 'daemon ..."   4 seconds ago       Up 3 seconds               0.0.0.0:8080->80/tcp   nginx-test
	dda109e244d1        hello-world         "/hello"                 2 minutes ago       Exited (0) 2 minutes ago                          friendly_mcclintock
	[root@docker ~]#
	[root@docker ~]# docker container stop nginx-test
	nginx-test
	[root@docker ~]# docker container rm nginx-test
	nginx-test
	[root@docker ~]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
	dda109e244d1        hello-world         "/hello"            3 minutes ago       Exited (0) 3 minutes ago                       friendly_mcclintock
	[root@docker ~]#

## Building Container Images
	[root@docker ~]# git clone https://github.com/nursanto/belajarbareng-1_docker-fundamental.git
	Cloning into 'belajarbareng-1_docker-fundamental'...
	remote: Enumerating objects: 21, done.
	remote: Counting objects: 100% (21/21), done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 21 (delta 0), reused 0 (delta 0), pack-reused 0
	Unpacking objects: 100% (21/21), done.
	[root@docker ~]#
	[root@docker dockerfile-example]# docker image ls
	REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
	docker.io/nginx         latest              f949e7d76d63        7 days ago          126 MB
	docker.io/hello-world   latest              fce289e99eb9        9 months ago        1.84 kB
	[root@docker dockerfile-example]# 
	[root@docker dockerfile-example]# docker image build --tag local:dockerfile-example .
	Sending build context to Docker daemon 64.51 kB
	Step 1/10 : FROM alpine:latest
	Trying to pull repository docker.io/library/alpine ...
	latest: Pulling from docker.io/library/alpine
	9d48c3bd43c5: Pull complete
	Digest: sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb
	Status: Downloaded newer image for docker.io/alpine:latest
	 ---> 961769676411
	Step 2/10 : LABEL maintainer "Russ McKendrick <russ@mckendrick.io>"
	 ---> Running in e63a0b7444a2
	 ---> 6c0f46285bd0
	Removing intermediate container e63a0b7444a2
	Step 3/10 : LABEL description "This example Dockerfile installs NGINX."
	 ---> Running in 17bbe306e1e0
	 ---> 36622f913485
	Removing intermediate container 17bbe306e1e0
	Step 4/10 : RUN apk add --update nginx &&         rm -rf /var/cache/apk/* &&         mkdir -p /tmp/nginx/
	 ---> Running in 5611446c4735
	fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/main/x86_64/APKINDEX.tar.gz
	fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/community/x86_64/APKINDEX.tar.gz
	(1/2) Installing pcre (8.43-r0)
	(2/2) Installing nginx (1.16.1-r0)
	Executing nginx-1.16.1-r0.pre-install
	Executing busybox-1.30.1-r2.trigger
	OK: 7 MiB in 16 packages
	 ---> 53b5d520896e
	Removing intermediate container 5611446c4735
	Step 5/10 : COPY files/nginx.conf /etc/nginx/nginx.conf
	 ---> e27db9a74eab
	Removing intermediate container 08a0ec860945
	Step 6/10 : COPY files/default.conf /etc/nginx/conf.d/default.conf
	 ---> 55f3ba141971
	Removing intermediate container da4269cdb3f1
	Step 7/10 : ADD files/html.tar.gz /usr/share/nginx/
	 ---> c50893b2f914
	Removing intermediate container ec29cdb20ef4
	Step 8/10 : EXPOSE 80/tcp
	 ---> Running in d7ba8da6d209
	 ---> e873f26d7439
	Removing intermediate container d7ba8da6d209
	Step 9/10 : ENTRYPOINT nginx
	 ---> Running in a9950773bb83
	 ---> 1fc5bd23d814
	Removing intermediate container a9950773bb83
	Step 10/10 : CMD -g daemon off;
	 ---> Running in 9d5687b582eb
	 ---> ac3ac1d8e861
	Removing intermediate container 9d5687b582eb
	Successfully built ac3ac1d8e861
	[root@docker dockerfile-example]#
	[root@docker dockerfile-example]# docker image ls
	REPOSITORY              TAG                  IMAGE ID            CREATED              SIZE
	local                   dockerfile-example   ac3ac1d8e861        About a minute ago   7.18 MB
	docker.io/nginx         latest               f949e7d76d63        7 days ago           126 MB
	docker.io/alpine        latest               961769676411        6 weeks ago          5.58 MB
	docker.io/hello-world   latest               fce289e99eb9        9 months ago         1.84 kB
	[root@docker dockerfile-example]#
	[root@docker dockerfile-example]# docker image pull alpine:latest
	Trying to pull repository docker.io/library/alpine ...
	latest: Pulling from docker.io/library/alpine
	Digest: sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb
	Status: Image is up to date for docker.io/alpine:latest
	[root@docker dockerfile-example]#
	[root@docker dockerfile-example]# docker container run -it --name alpine-test alpine /bin/sh
	/ # apk update
	fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/main/x86_64/APKINDEX.tar.gz
	fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/community/x86_64/APKINDEX.tar.gz
	v3.10.2-80-g68e4e4a13a [http://dl-cdn.alpinelinux.org/alpine/v3.10/main]
	v3.10.2-83-g64319a6606 [http://dl-cdn.alpinelinux.org/alpine/v3.10/community]
	OK: 10336 distinct packages available
	/ # apk upgrade
	(1/2) Upgrading libcrypto1.1 (1.1.1c-r0 -> 1.1.1d-r0)
	(2/2) Upgrading libssl1.1 (1.1.1c-r0 -> 1.1.1d-r0)
	OK: 6 MiB in 14 packages
	/ #
	/ # apk add --update nginx
	(1/2) Installing pcre (8.43-r0)
	(2/2) Installing nginx (1.16.1-r0)
	Executing nginx-1.16.1-r0.pre-install
	Executing busybox-1.30.1-r2.trigger
	OK: 7 MiB in 16 packages
	/ # rm -rf /var/cache/apk/*
	/ # mkdir -p /tmp/nginx/
	/ # exit
	[root@docker dockerfile-example]# docker ps
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
	[root@docker dockerfile-example]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                      PORTS               NAMES
	858effc9756d        alpine              "/bin/sh"           About a minute ago   Exited (0) 11 seconds ago                       alpine-test
	dda109e244d1        hello-world         "/hello"            50 minutes ago       Exited (0) 50 minutes ago                       friendly_mcclintock
	[root@docker dockerfile-example]# docker container commit alpine-test local:broken-container
	sha256:15d4596935d4416151229fb90a07fed5387bbf2495e96315b79bd4a0609ec36b
	[root@docker dockerfile-example]#
	[root@docker dockerfile-example]# docker image ls
	REPOSITORY              TAG                  IMAGE ID            CREATED             SIZE
	local                   broken-container     15d4596935d4        8 seconds ago       10.2 MB
	local                   dockerfile-example   ac3ac1d8e861        8 minutes ago       7.18 MB
	docker.io/nginx         latest               f949e7d76d63        7 days ago          126 MB
	docker.io/alpine        latest               961769676411        6 weeks ago         5.58 MB
	docker.io/hello-world   latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker dockerfile-example]# docker image save -o broken-container.tar local:broken-container
	[root@docker dockerfile-example]# ls broken-container.tar
	broken-container.tar
	[root@docker dockerfile-example]#

## Storing and Distributing Images
	[root@docker materials]#
	[root@docker materials]# docker image pull registry:2
	Trying to pull repository docker.io/library/registry ...
	2: Pulling from docker.io/library/registry
	c87736221ed0: Pull complete
	1cc8e0bb44df: Pull complete
	54d33bcb37f5: Pull complete
	e8afc091c171: Pull complete
	b4541f6d3db6: Pull complete
	Digest: sha256:8004747f1e8cd820a148fb7499d71a76d45ff66bac6a29129bfdbfdc0154d146
	Status: Downloaded newer image for docker.io/registry:2
	[root@docker materials]# docker image ls
	REPOSITORY              TAG                  IMAGE ID            CREATED             SIZE
	local                   broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                   dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx         latest               f949e7d76d63        7 days ago          126 MB
	docker.io/alpine        latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry      2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world   latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]# docker container run -d -p 5000:5000 --name registry registry:2
	16181814c1d1ce4a0246768c0510b7554a8de55f5212903f4f1559f0d109de31
	[root@docker materials]# docker ps
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   6 seconds ago       Up 5 seconds        0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]# docker image ls
	REPOSITORY              TAG                  IMAGE ID            CREATED             SIZE
	local                   broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                   dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx         latest               f949e7d76d63        7 days ago          126 MB
	docker.io/alpine        latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry      2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world   latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]# docker image pull alpine
	Using default tag: latest
	Trying to pull repository docker.io/library/alpine ...
	latest: Pulling from docker.io/library/alpine
	Digest: sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb
	Status: Image is up to date for docker.io/alpine:latest
	[root@docker materials]# docker image tag alpine localhost:5000/localalpine
	[root@docker materials]# docker image ls
	REPOSITORY                   TAG                  IMAGE ID            CREATED             SIZE
	local                        broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                        dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx              latest               f949e7d76d63        7 days ago          126 MB
	docker.io/alpine             latest               961769676411        6 weeks ago         5.58 MB
	localhost:5000/localalpine   latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry           2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world        latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]# docker image push localhost:5000/localalpine
	The push refers to a repository [localhost:5000/localalpine]
	03901b4a2ea8: Pushed
	latest: digest: sha256:acd3ca9941a85e8ed16515bfc5328e4e2f8c128caa72959a58a127b7801ee01f size: 528
	[root@docker materials]# docker image ls
	REPOSITORY                   TAG                  IMAGE ID            CREATED             SIZE
	local                        broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                        dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx              latest               f949e7d76d63        7 days ago          126 MB
	localhost:5000/localalpine   latest               961769676411        6 weeks ago         5.58 MB
	docker.io/alpine             latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry           2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world        latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                         PORTS                    NAMES
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   4 minutes ago       Up 4 minutes                   0.0.0.0:5000->5000/tcp   registry
	858effc9756d        961769676411        "/bin/sh"                About an hour ago   Exited (0) About an hour ago                            alpine-test
	dda109e244d1        hello-world         "/hello"                 2 hours ago         Exited (0) 2 hours ago                                  friendly_mcclintock
	[root@docker materials]# docker rm alpine-test friendly_mcclintock
	alpine-test
	friendly_mcclintock
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   4 minutes ago       Up 4 minutes        0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]# docker image ls
	REPOSITORY                   TAG                  IMAGE ID            CREATED             SIZE
	local                        broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                        dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx              latest               f949e7d76d63        7 days ago          126 MB
	localhost:5000/localalpine   latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry           2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world        latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]# docker image rm alpine localhost:5000/localalpine
	Untagged: localhost:5000/localalpine:latest
	Error response from daemon: No such image: alpine:latest
	[root@docker materials]#
	[root@docker materials]# docker image ls
	REPOSITORY              TAG                  IMAGE ID            CREATED             SIZE
	local                   broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                   dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx         latest               f949e7d76d63        7 days ago          126 MB
	docker.io/registry      2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world   latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker image pull localhost:5000/localalpine
	Using default tag: latest
	Trying to pull repository localhost:5000/localalpine ...
	latest: Pulling from localhost:5000/localalpine
	Digest: sha256:acd3ca9941a85e8ed16515bfc5328e4e2f8c128caa72959a58a127b7801ee01f
	Status: Downloaded newer image for localhost:5000/localalpine:latest
	[root@docker materials]# docker image ls
	REPOSITORY                   TAG                  IMAGE ID            CREATED             SIZE
	local                        broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                        dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx              latest               f949e7d76d63        7 days ago          126 MB
	localhost:5000/localalpine   latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry           2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world        latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]#
	
## Managing Containers
	[root@docker materials]# docker ps
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   7 minutes ago       Up 7 minutes        0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   7 minutes ago       Up 7 minutes        0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker image ls
	REPOSITORY                   TAG                  IMAGE ID            CREATED             SIZE
	local                        broken-container     15d4596935d4        About an hour ago   10.2 MB
	local                        dockerfile-example   ac3ac1d8e861        About an hour ago   7.18 MB
	docker.io/nginx              latest               f949e7d76d63        7 days ago          126 MB
	localhost:5000/localalpine   latest               961769676411        6 weeks ago         5.58 MB
	docker.io/registry           2                    f32a97de94e1        6 months ago        25.8 MB
	docker.io/hello-world        latest               fce289e99eb9        9 months ago        1.84 kB
	[root@docker materials]#
	[root@docker materials]# docker container run -d --name nginx-test -p 8080:80 nginx
	f18f409ce3310922f796907c6a01600d10c08d0deb9b1f6762dacc535979a920
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	f18f409ce331        nginx               "nginx -g 'daemon ..."   6 seconds ago       Up 5 seconds        0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   10 minutes ago      Up 10 minutes       0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]# docker container run --name nginx-foreground -p 9090:80 nginx
	10.3.138.109 - - [02/Oct/2019:08:31:50 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:50 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:51 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:51 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	^C[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                      PORTS                    NAMES
	5cf85f671040        nginx               "nginx -g 'daemon ..."   About a minute ago   Exited (0) 37 seconds ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   2 minutes ago        Up 2 minutes                0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   12 minutes ago       Up 12 minutes               0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker container run --name nginx-foreground -p 9090:80 nginx
	10.3.138.109 - - [02/Oct/2019:08:31:50 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:50 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:51 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:51 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:31:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	^C[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                      PORTS                    NAMES
	5cf85f671040        nginx               "nginx -g 'daemon ..."   About a minute ago   Exited (0) 37 seconds ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   2 minutes ago        Up 2 minutes                0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   12 minutes ago       Up 12 minutes               0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker container attach nginx-test
	10.3.138.109 - - [02/Oct/2019:08:33:41 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:33:49 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	^C[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                          PORTS                    NAMES
	5cf85f671040        nginx               "nginx -g 'daemon ..."   2 minutes ago       Exited (0) About a minute ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   3 minutes ago       Exited (0) 2 seconds ago                                 nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   13 minutes ago      Up 13 minutes                   0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker container start nginx-test
	nginx-test
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS                    NAMES
	5cf85f671040        nginx               "nginx -g 'daemon ..."   3 minutes ago       Exited (0) 2 minutes ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   4 minutes ago       Up 2 seconds               0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   14 minutes ago      Up 14 minutes              0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker container attach --sig-proxy=false nginx-test
	10.3.138.109 - - [02/Oct/2019:08:36:28 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:36:32 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	^C
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS                    NAMES
	5cf85f671040        nginx               "nginx -g 'daemon ..."   5 minutes ago       Exited (0) 4 minutes ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   6 minutes ago       Up About a minute          0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   16 minutes ago      Up 16 minutes              0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]# docker container exec nginx-test cat /etc/debian_version
	10.1
	[root@docker materials]# docker container exec nginx-test cat /etc/hosts
	127.0.0.1       localhost
	::1     localhost ip6-localhost ip6-loopback
	fe00::0 ip6-localnet
	ff00::0 ip6-mcastprefix
	ff02::1 ip6-allnodes
	ff02::2 ip6-allrouters
	172.17.0.3      f18f409ce331
	[root@docker materials]# docker container exec -i -t nginx-test /bin/bash
	root@f18f409ce331:/#
	root@f18f409ce331:/# ls
	bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
	root@f18f409ce331:/# ip a
	bash: ip: command not found
	root@f18f409ce331:/# exit
	exit
	[root@docker materials]#
	[root@docker materials]# docker container logs --tail 5 nginx-test
	10.3.138.109 - - [02/Oct/2019:08:31:56 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:33:41 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:33:49 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:36:28 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:36:32 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker container logs -f nginx-test
	10.3.138.109 - - [02/Oct/2019:08:31:56 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:33:41 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:33:49 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:36:28 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	10.3.138.109 - - [02/Oct/2019:08:36:32 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36" "-"
	^C
	[root@docker materials]#
	[root@docker materials]# docker container top nginx-test
	UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
	root                13175               13158               0                   15:34               ?                   00:00:00            nginx: master process nginx -g daemon off;
	101                 13200               13175               0                   15:34               ?                   00:00:00            nginx: worker process
	[root@docker materials]#
	[root@docker materials]# docker container stats nginx-test
	CONTAINER           CPU %               MEM USAGE / LIMIT       MEM %               NET I/O             BLOCK I/O           PIDS
	nginx-test          0.00%               1.414 MiB / 3.701 GiB   0.04%               3.05 kB / 2.21 kB   0 B / 0 B           2
	^C
	[root@docker materials]#
	[root@docker materials]# docker container update --cpu-shares 512 --memory 128M nginx-test
	Error response from daemon: Cannot update container f18f409ce3310922f796907c6a01600d10c08d0deb9b1f6762dacc535979a920: Memory limit should be smaller than already set memoryswap limit, update the memoryswap at the same time
	[root@docker materials]# docker container inspect nginx-test | grep -i memory
	            "Memory": 0,
	            "KernelMemory": 0,
	            "MemoryReservation": 0,
	            "MemorySwap": 0,
	            "MemorySwappiness": -1,
	[root@docker materials]# docker container update --cpu-shares 512 --memory 128M --memory-swap 256M nginx-test
	nginx-test
	[root@docker materials]#
	[root@docker materials]# docker container inspect nginx-test | grep -i memory
	            "Memory": 134217728,
	            "KernelMemory": 0,
	            "MemoryReservation": 0,
	            "MemorySwap": 268435456,
	            "MemorySwappiness": -1,
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker container stats nginx-test -a
	CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
	nginx-test          0.00%               1.414 MiB / 128 MiB   1.10%               3.05 kB / 2.21 kB   0 B / 0 B           2
	^C
	[root@docker materials]#

	[root@docker materials]#
	[root@docker materials]# docker image pull redis:alpine
	Trying to pull repository docker.io/library/redis ...
	alpine: Pulling from docker.io/library/redis
	9d48c3bd43c5: Already exists
	6bcae78f4e99: Pull complete
	8cb2d2938e96: Pull complete
	f766c018f90a: Pull complete
	4820560d234d: Pull complete
	f4869f14d10b: Pull complete
	Digest: sha256:d9ea76b14d4771c7cd0c199de603f3d9b1ea246c0cbaae02b86783e1c1dcc3d1
	Status: Downloaded newer image for docker.io/redis:alpine
	[root@docker materials]# docker image pull russmckendrick/moby-counter
	Using default tag: latest
	Trying to pull repository docker.io/russmckendrick/moby-counter ...
	latest: Pulling from docker.io/russmckendrick/moby-counter
	ff3a5c916c92: Pull complete
	0384617ecf25: Pull complete
	3e2743173da8: Pull complete
	40c2a5cd7772: Pull complete
	e00657f4abd2: Pull complete
	32312bfbca18: Pull complete
	Digest: sha256:d0f51203130cb934a2910c2e0d577e68b7ab17962ce01918d37d7de9686553cc
	Status: Downloaded newer image for docker.io/russmckendrick/moby-counter:latest
	[root@docker materials]# docker network create moby-counter
	8836ff4be670f60411e6c36a7799136b6ae02f151b28420e36be049953df2db4
	[root@docker materials]# docker container run -d --name redis --network moby-counter redis:alpine
	9e1f35bb699ad202b3840e2a14e02050793e5fd2aa6d060a9bbd291c9507a65d
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS                    NAMES
	9e1f35bb699a        redis:alpine        "docker-entrypoint..."   11 seconds ago      Up 10 seconds               6379/tcp                 redis
	5cf85f671040        nginx               "nginx -g 'daemon ..."   28 minutes ago      Exited (0) 28 minutes ago                            nginx-foreground
	f18f409ce331        nginx               "nginx -g 'daemon ..."   30 minutes ago      Up 25 minutes               0.0.0.0:8080->80/tcp     nginx-test
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   40 minutes ago      Up 40 minutes               0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker rm -f nginx-test nginx-foreground
	nginx-test
	nginx-foreground
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
	9e1f35bb699a        redis:alpine        "docker-entrypoint..."   42 seconds ago      Up 41 seconds       6379/tcp                 redis
	16181814c1d1        registry:2          "/entrypoint.sh /e..."   40 minutes ago      Up 40 minutes       0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker container run -d --name moby-counter --network moby-counter -p 8080:80 russmckendrick/moby-counter
	ce79e13bbd5508237fea177412fae81b197fc902d4cbea33616e899781137f5a
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE                         COMMAND                  CREATED              STATUS              PORTS                    NAMES
	ce79e13bbd55        russmckendrick/moby-counter   "node index.js"          3 seconds ago        Up 2 seconds        0.0.0.0:8080->80/tcp     moby-counter
	9e1f35bb699a        redis:alpine                  "docker-entrypoint..."   About a minute ago   Up About a minute   6379/tcp                 redis
	16181814c1d1        registry:2                    "/entrypoint.sh /e..."   41 minutes ago       Up 41 minutes       0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker container exec moby-counter ping -c 3 redis
	PING redis (172.18.0.2): 56 data bytes
	64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.147 ms
	64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.103 ms
	64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.096 ms

	--- redis ping statistics ---
	3 packets transmitted, 3 packets received, 0% packet loss
	round-trip min/avg/max = 0.096/0.115/0.147 ms
	[root@docker materials]# docker container exec moby-counter cat /etc/hosts
	127.0.0.1       localhost
	::1     localhost ip6-localhost ip6-loopback
	fe00::0 ip6-localnet
	ff00::0 ip6-mcastprefix
	ff02::1 ip6-allnodes
	ff02::2 ip6-allrouters
	172.18.0.3      ce79e13bbd55
	[root@docker materials]# docker container exec moby-counter cat /etc/resolv.conf
	search lab
	nameserver 127.0.0.11
	options ndots:0
	[root@docker materials]# docker container exec moby-counter nslookup redis 127.0.0.11
	Server:    127.0.0.11
	Address 1: 127.0.0.11

	Name:      redis
	Address 1: 172.18.0.2 redis.moby-counter
	[root@docker materials]#
	[root@docker materials]#
	[root@docker materials]# docker network create moby-counter2
	5a28d166314888b8b13925f1f6bc8f86cf56ac8ced8d4f10cd86166025915e62
	[root@docker materials]# docker run -itd --name moby-counter2 --network moby-counter2 -p 9090:80 russmckendrick/moby-counter
	960412226de3723683dd4e8d06b3d018d48e85397a83c42933cc76c9d7551130
	[root@docker materials]# docker container exec moby-counter2 ping -c 3 redis
	ping: bad address 'redis'
	[root@docker materials]# docker container exec moby-counter2 cat /etc/resolv.conf
	search lab
	nameserver 127.0.0.11
	options ndots:0
	[root@docker materials]# docker container exec moby-counter2 nslookup redis 127.0.0.11
	Server:    127.0.0.11
	nslookup: can't resolve 'redis': Try again
	Address 1: 127.0.0.11

	[root@docker materials]# 
	[root@docker materials]# docker container run -d --name redis2 --network moby-counter2 --network-alias redis redis:alpine
	35d78a26bdd6777c7dce5b10f0c68729ad47774188ea616cd06104815b684d10
	[root@docker materials]# docker container exec moby-counter2 nslookup redis 127.0.0.11
	Server:    127.0.0.11
	Address 1: 127.0.0.11

	Name:      redis
	Address 1: 172.19.0.3 redis2.moby-counter2
	[root@docker materials]#
	[root@docker materials]# docker network ls
	NETWORK ID          NAME                DRIVER              SCOPE
	7a01f523a703        bridge              bridge              local
	b463f3e60ef5        host                host                local
	8836ff4be670        moby-counter        bridge              local
	5a28d1663148        moby-counter2       bridge              local
	b918cab501c6        none                null                local
	[root@docker materials]# docker network inspect moby-counter
	[
	    {
	        "Name": "moby-counter",
	        "Id": "8836ff4be670f60411e6c36a7799136b6ae02f151b28420e36be049953df2db4",
	        "Created": "2019-10-02T15:59:42.325526458+07:00",
	        "Scope": "local",
	        "Driver": "bridge",
	        "EnableIPv6": false,
	        "IPAM": {
	            "Driver": "default",
	            "Options": {},
	            "Config": [
	                {
	                    "Subnet": "172.18.0.0/16",
	                    "Gateway": "172.18.0.1"
	                }
	            ]
	        },
	        "Internal": false,
	        "Attachable": false,
	        "Containers": {
	            "9e1f35bb699ad202b3840e2a14e02050793e5fd2aa6d060a9bbd291c9507a65d": {
	                "Name": "redis",
	                "EndpointID": "9f9af505f08654934b6c906d3ee18dc80cc5910c599f996fb9d8dc02c7158db8",
	                "MacAddress": "02:42:ac:12:00:02",
	                "IPv4Address": "172.18.0.2/16",
	                "IPv6Address": ""
	            },
	            "ce79e13bbd5508237fea177412fae81b197fc902d4cbea33616e899781137f5a": {
	                "Name": "moby-counter",
	                "EndpointID": "5af52b3697ba527711fc11b2fa31ff732ecd583318b422ec02063ad237361f1c",
	                "MacAddress": "02:42:ac:12:00:03",
	                "IPv4Address": "172.18.0.3/16",
	                "IPv6Address": ""
	            }
	        },
	        "Options": {},
	        "Labels": {}
	    }
	]
	[root@docker materials]# docker container stop moby-counter2 redis2
	moby-counter2
	redis2
	[root@docker materials]# docker container prune
	WARNING! This will remove all stopped containers.
	Are you sure you want to continue? [y/N] y
	Deleted Containers:
	35d78a26bdd6777c7dce5b10f0c68729ad47774188ea616cd06104815b684d10
	960412226de3723683dd4e8d06b3d018d48e85397a83c42933cc76c9d7551130

	Total reclaimed space: 0 B
	[root@docker materials]# docker network prune
	WARNING! This will remove all networks not used by at least one container.
	Are you sure you want to continue? [y/N] y
	Deleted Networks:
	moby-counter2

	[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                    NAMES
	ce79e13bbd55        russmckendrick/moby-counter   "node index.js"          15 minutes ago      Up 15 minutes       0.0.0.0:8080->80/tcp     moby-counter
	9e1f35bb699a        redis:alpine                  "docker-entrypoint..."   16 minutes ago      Up 16 minutes       6379/tcp                 redis
	16181814c1d1        registry:2                    "/entrypoint.sh /e..."   56 minutes ago      Up 56 minutes       0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]# docker container stop redis
	redis
	[root@docker materials]# docker container rm redis
	redis
	[root@docker materials]#
	[root@docker materials]# docker container run -d --name redis --network moby-counter redis:alpine
	a7075d8c83146f4b302e12bb99b0404989a59dabb8860c6ce1cf4d3269151f06
	[root@docker materials]#
	[root@docker materials]# docker container stop redis
	redis
	[root@docker materials]# docker container rm redis
	redis
	[root@docker materials]# docker volume ls
	DRIVER              VOLUME NAME
	local               2eba93e45ee7a94d6542ab902ee8d155a615749a2476ce73d9c49a1904d2321e
	local               ad41673d65ebf855cac58c3f29714227bf87fff0589dc2389bd5bf2263042c2c
	local               b2f0b2aab1f33660f295544200608f68efd13ebe9856210c8d8e5e47f002f860
	local               fa2c0675ca41560d619d1faa3f2bfb1b94c2c7ac2b0d626356e101ab24da6d19
	[root@docker materials]# docker container run -d --name redis -v fa2c0675ca41560d619d1faa3f2bfb1b94c2c7ac2b0d626356e101ab24da6d19:/data --network moby-counter redis:alpine
	7f99b147b7174a37b04821d244dbdc306992f3bc9668d34064a43ea2d32dd744
	[root@docker materials]#
	[root@docker materials]# docker ps -a
	CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                    NAMES
	7f99b147b717        redis:alpine                  "docker-entrypoint..."   20 seconds ago      Up 18 seconds       6379/tcp                 redis
	ce79e13bbd55        russmckendrick/moby-counter   "node index.js"          19 minutes ago      Up 19 minutes       0.0.0.0:8080->80/tcp     moby-counter
	16181814c1d1        registry:2                    "/entrypoint.sh /e..."   About an hour ago   Up About an hour    0.0.0.0:5000->5000/tcp   registry
	[root@docker materials]#
	[root@docker materials]# docker container exec redis ls -lhat /data
	total 4K
	drwxr-xr-x    1 root     root          17 Oct  2 09:20 ..
	drwxr-xr-x    2 redis    redis         22 Oct  2 09:17 .
	-rw-r--r--    1 redis    redis        199 Oct  2 09:17 dump.rdb
	[root@docker materials]# docker volume create redis_data
	redis_data
	[root@docker materials]# 
	[root@docker materials]# docker container stop redis
	redis
	[root@docker materials]# docker container rm redis
	redis
	[root@docker materials]# docker container run -d --name redis -v redis_data:/data --network moby-counter redis:alpine
	8b846bed1479dd01bfa77eedd870e573f70e48c253c38b5f0f258d7c616db835
	[root@docker materials]#
	[root@docker materials]# docker volume ls
	DRIVER              VOLUME NAME
	local               2eba93e45ee7a94d6542ab902ee8d155a615749a2476ce73d9c49a1904d2321e
	local               ad41673d65ebf855cac58c3f29714227bf87fff0589dc2389bd5bf2263042c2c
	local               b2f0b2aab1f33660f295544200608f68efd13ebe9856210c8d8e5e47f002f860
	local               fa2c0675ca41560d619d1faa3f2bfb1b94c2c7ac2b0d626356e101ab24da6d19
	local               redis_data
	[root@docker materials]# docker volume inspect redis_data
	[
	    {
	        "Driver": "local",
	        "Labels": {},
	        "Mountpoint": "/var/lib/docker/volumes/redis_data/_data",
	        "Name": "redis_data",
	        "Options": {},
	        "Scope": "local"
	    }
	]
	[root@docker materials]# docker container stop redis moby-counter
	redis
	moby-counter
	[root@docker materials]# docker container prune
	WARNING! This will remove all stopped containers.
	Are you sure you want to continue? [y/N] y
	Deleted Containers:
	8b846bed1479dd01bfa77eedd870e573f70e48c253c38b5f0f258d7c616db835
	ce79e13bbd5508237fea177412fae81b197fc902d4cbea33616e899781137f5a

	Total reclaimed space: 0 B
	[root@docker materials]# docker network prune
	WARNING! This will remove all networks not used by at least one container.
	Are you sure you want to continue? [y/N] y
	Deleted Networks:
	moby-counter

	[root@docker materials]# docker volume prune
	WARNING! This will remove all volumes not used by at least one container.
	Are you sure you want to continue? [y/N] y
	Deleted Volumes:
	fa2c0675ca41560d619d1faa3f2bfb1b94c2c7ac2b0d626356e101ab24da6d19
	b2f0b2aab1f33660f295544200608f68efd13ebe9856210c8d8e5e47f002f860
	2eba93e45ee7a94d6542ab902ee8d155a615749a2476ce73d9c49a1904d2321e
	redis_data

	Total reclaimed space: 622 B
	[root@docker materials]#

## Docker Compose
	[root@docker materials]# cd mobycounter/
	[root@docker mobycounter]# ls
	docker-compose.yml
	[root@docker mobycounter]# docker-compose up
	Creating network "mobycounter_default" with the default driver
	Creating volume "mobycounter_redis_data" with default driver
	Creating mobycounter_redis_1 ... done
	Creating mobycounter_mobycounter_1 ... done
	Attaching to mobycounter_redis_1, mobycounter_mobycounter_1
	redis_1        | 1:C 02 Oct 2019 09:33:19.053 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
	redis_1        | 1:C 02 Oct 2019 09:33:19.053 # Redis version=5.0.6, bits=64, commit=00000000, modified=0, pid=1, just started
	redis_1        | 1:C 02 Oct 2019 09:33:19.053 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
	redis_1        | 1:M 02 Oct 2019 09:33:19.056 * Running mode=standalone, port=6379.
	redis_1        | 1:M 02 Oct 2019 09:33:19.056 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
	redis_1        | 1:M 02 Oct 2019 09:33:19.056 # Server initialized
	redis_1        | 1:M 02 Oct 2019 09:33:19.056 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
	redis_1        | 1:M 02 Oct 2019 09:33:19.056 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
	redis_1        | 1:M 02 Oct 2019 09:33:19.057 * Ready to accept connections
	mobycounter_1  | using redis server
	mobycounter_1  | -------------------------------------------
	mobycounter_1  | have host: redis
	mobycounter_1  | have port: 6379
	mobycounter_1  | server listening on port: 80
	mobycounter_1  | Connection made to the Redis server
	redis_1        | 1:M 02 Oct 2019 09:33:59.301 * DB saved on disk
	redis_1        | 1:M 02 Oct 2019 09:34:00.076 * DB saved on disk
	redis_1        | 1:M 02 Oct 2019 09:34:00.899 * DB saved on disk
	redis_1        | 1:M 02 Oct 2019 09:34:01.639 * DB saved on disk
	^CERROR: Aborting.
	[root@docker mobycounter]# docker ps
	CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                    NAMES
	a515cf3a0c9f        russmckendrick/moby-counter   "node index.js"          2 minutes ago       Up 2 minutes        0.0.0.0:8080->80/tcp     mobycounter_mobycounter_1
	8cc2d6d20251        redis:alpine                  "docker-entrypoint..."   2 minutes ago       Up 2 minutes        6379/tcp                 mobycounter_redis_1
	16181814c1d1        registry:2                    "/entrypoint.sh /e..."   About an hour ago   Up About an hour    0.0.0.0:5000->5000/tcp   registry
	[root@docker mobycounter]#
	[root@docker mobycounter]#
	[root@docker mobycounter]#
	[root@docker example-voting-app]#
	[root@docker example-voting-app]# docker rm -f registry
	registry
	[root@docker example-voting-app]# docker ps -a
	CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                  NAMES
	a515cf3a0c9f        russmckendrick/moby-counter   "node index.js"          16 minutes ago      Up 16 minutes       0.0.0.0:8080->80/tcp   mobycounter_mobycounter_1
	8cc2d6d20251        redis:alpine                  "docker-entrypoint..."   16 minutes ago      Up 16 minutes       6379/tcp               mobycounter_redis_1
	[root@docker example-voting-app]#
	[root@docker example-voting-app]# docker-compose up -d
	Starting db                          ... done
	Starting example-voting-app_vote_1   ... done
	Starting example-voting-app_worker_1 ... done
	Starting example-voting-app_result_1 ... done
	Starting redis                       ... done
	[root@docker example-voting-app]#
	[root@docker example-voting-app]# docker-compose ps
	           Name                          Command               State                      Ports
	-------------------------------------------------------------------------------------------------------------------
	db                            docker-entrypoint.sh postgres    Up      5432/tcp
	example-voting-app_result_1   nodemon --debug server.js        Up      0.0.0.0:5858->5858/tcp, 0.0.0.0:5001->80/tcp
	example-voting-app_vote_1     python app.py                    Up      0.0.0.0:5000->80/tcp
	example-voting-app_worker_1   /bin/sh -c dotnet src/Work ...   Up
	redis                         docker-entrypoint.sh redis ...   Up      0.0.0.0:32770->6379/tcp
	[root@docker example-voting-app]# docker-compose config
	networks:
	  back-tier: {}
	  front-tier: {}
	services:
	  db:
	    container_name: db
	    image: postgres:9.4
	    networks:
	      back-tier: null
	    volumes:
	    - db-data:/var/lib/postgresql/data:rw
	  redis:
	    container_name: redis
	    image: redis:alpine
	    networks:
	      back-tier: null
	    ports:
	    - 6379/tcp
	  result:
	    build:
	      context: /root/belajarbareng-1_docker-fundamental/materials/example-voting-app/result
	    command: nodemon --debug server.js
	    networks:
	      back-tier: null
	      front-tier: null
	    ports:
	    - 5001:80/tcp
	    - 5858:5858/tcp
	    volumes:
	    - /root/belajarbareng-1_docker-fundamental/materials/example-voting-app/result:/app:rw
	  vote:
	    build:
	      context: /root/belajarbareng-1_docker-fundamental/materials/example-voting-app/vote
	    command: python app.py
	    networks:
	      back-tier: null
	      front-tier: null
	    ports:
	    - 5000:80/tcp
	    volumes:
	    - /root/belajarbareng-1_docker-fundamental/materials/example-voting-app/vote:/app:rw
	  worker:
	    build:
	      context: /root/belajarbareng-1_docker-fundamental/materials/example-voting-app/worker
	    networks:
	      back-tier: null
	version: '3.0'
	volumes:
	  db-data: {}

	[root@docker example-voting-app]# docker-compose config -q
	[root@docker example-voting-app]# docker-compose top
	db
	  UID      PID    PPID    C    STIME   TTY     TIME                            CMD
	----------------------------------------------------------------------------------------------------------
	polkitd   17995   17974   0    16:51   ?     00:00:00   postgres
	polkitd   18324   17995   0    16:51   ?     00:00:00   postgres: checkpointer process
	polkitd   18325   17995   0    16:51   ?     00:00:00   postgres: writer process
	polkitd   18326   17995   0    16:51   ?     00:00:00   postgres: wal writer process
	polkitd   18327   17995   0    16:51   ?     00:00:00   postgres: autovacuum launcher process
	polkitd   18328   17995   0    16:51   ?     00:00:00   postgres: stats collector process
	polkitd   18400   17995   22   16:51   ?     00:00:48   postgres: postgres postgres 172.20.0.3(54996) idle
	polkitd   18428   17995   0    16:51   ?     00:00:00   postgres: postgres postgres 172.20.0.4(41026) idle

	example-voting-app_result_1
	UID     PID    PPID    C   STIME   TTY     TIME                          CMD
	-------------------------------------------------------------------------------------------------
	root   18159   18124   0   16:51   ?     00:00:00   node /usr/local/bin/nodemon --debug server.js
	root   18411   18159   0   16:51   ?     00:00:00   sh -c node --debug server.js
	root   18412   18411   0   16:51   ?     00:00:01   node --debug server.js

	example-voting-app_vote_1
	UID     PID    PPID    C   STIME   TTY     TIME                    CMD
	-------------------------------------------------------------------------------------
	root   18151   18069   0   16:51   ?     00:00:00   python app.py
	root   18396   18151   1   16:51   ?     00:00:02   /usr/local/bin/python /app/app.py

	example-voting-app_worker_1
	UID     PID    PPID    C    STIME   TTY     TIME                       CMD
	--------------------------------------------------------------------------------------------
	root   18150   18048   0    16:51   ?     00:00:00   /bin/sh -c dotnet src/Worker/Worker.dll
	root   18366   18150   99   16:51   ?     00:03:56   dotnet src/Worker/Worker.dll

	redis
	  UID      PID    PPID    C    STIME   TTY     TIME         CMD
	--------------------------------------------------------------------
	polkitd   18153   18066   10   16:51   ?     00:00:23   redis-server
	[root@docker example-voting-app]# docker-compose top db
	db
	  UID      PID    PPID    C    STIME   TTY     TIME                            CMD
	----------------------------------------------------------------------------------------------------------
	polkitd   17995   17974   0    16:51   ?     00:00:00   postgres
	polkitd   18324   17995   0    16:51   ?     00:00:00   postgres: checkpointer process
	polkitd   18325   17995   0    16:51   ?     00:00:00   postgres: writer process
	polkitd   18326   17995   0    16:51   ?     00:00:00   postgres: wal writer process
	polkitd   18327   17995   0    16:51   ?     00:00:00   postgres: autovacuum launcher process
	polkitd   18328   17995   0    16:51   ?     00:00:00   postgres: stats collector process
	polkitd   18400   17995   22   16:51   ?     00:00:50   postgres: postgres postgres 172.20.0.3(54996) idle
	polkitd   18428   17995   0    16:51   ?     00:00:00   postgres: postgres postgres 172.20.0.4(41026) idle
	[root@docker example-voting-app]# docker-compose logs
	Attaching to example-voting-app_worker_1, db, redis, example-voting-app_vote_1, example-voting-app_result_1
	redis     | 1:C 02 Oct 2019 09:50:33.960 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
	redis     | 1:C 02 Oct 2019 09:50:33.960 # Redis version=5.0.6, bits=64, commit=00000000, modified=0, pid=1, just started
	redis     | 1:C 02 Oct 2019 09:50:33.960 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
	redis     | 1:M 02 Oct 2019 09:50:33.962 * Running mode=standalone, port=6379.
	redis     | 1:M 02 Oct 2019 09:50:33.962 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
	redis     | 1:M 02 Oct 2019 09:50:33.962 # Server initialized
	redis     | 1:M 02 Oct 2019 09:50:33.962 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
	redis     | 1:M 02 Oct 2019 09:50:33.962 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
	redis     | 1:M 02 Oct 2019 09:50:33.962 * Ready to accept connections
	redis     | 1:C 02 Oct 2019 09:51:09.260 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
	redis     | 1:C 02 Oct 2019 09:51:09.260 # Redis version=5.0.6, bits=64, commit=00000000, modified=0, pid=1, just started
	redis     | 1:C 02 Oct 2019 09:51:09.260 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
	redis     | 1:M 02 Oct 2019 09:51:09.262 * Running mode=standalone, port=6379.
	redis     | 1:M 02 Oct 2019 09:51:09.262 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
	redis     | 1:M 02 Oct 2019 09:51:09.262 # Server initialized
	redis     | 1:M 02 Oct 2019 09:51:09.262 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
	redis     | 1:M 02 Oct 2019 09:51:09.262 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
	redis     | 1:M 02 Oct 2019 09:51:09.262 * Ready to accept connections
	worker_1  | Connected to db
	worker_1  | Connecting to redis
	worker_1  | Found redis at 172.20.0.2
	worker_1  | Connected to db
	worker_1  | Connecting to redis
	worker_1  | Found redis at 172.20.0.5
	worker_1  | Processing vote for 'a' by 'c83dd7161838dc64'
	worker_1  | Processing vote for 'b' by 'c83dd7161838dc64'
	worker_1  | Processing vote for 'b' by 'c83dd7161838dc64'
	db        | LOG:  database system was shut down at 2019-10-02 09:48:23 UTC
	db        | LOG:  MultiXact member wraparound protections are now enabled
	db        | LOG:  database system is ready to accept connections
	db        | LOG:  autovacuum launcher started
	db        | LOG:  database system was interrupted; last known up at 2019-10-02 09:50:34 UTC
	db        | LOG:  database system was not properly shut down; automatic recovery in progress
	db        | LOG:  record with zero length at 0/16BA110
	db        | LOG:  redo is not required
	db        | LOG:  MultiXact member wraparound protections are now enabled
	db        | LOG:  database system is ready to accept connections
	db        | LOG:  autovacuum launcher started
	db        | ERROR:  duplicate key value violates unique constraint "votes_id_key"
	db        | DETAIL:  Key (id)=(c83dd7161838dc64) already exists.
	db        | STATEMENT:  INSERT INTO votes (id, vote) VALUES ($1, $2)
	db        | ERROR:  duplicate key value violates unique constraint "votes_id_key"
	db        | DETAIL:  Key (id)=(c83dd7161838dc64) already exists.
	db        | STATEMENT:  INSERT INTO votes (id, vote) VALUES ($1, $2)
	vote_1    |  * Serving Flask app "app" (lazy loading)
	vote_1    |  * Environment: production
	vote_1    |    WARNING: This is a development server. Do not use it in a production deployment.
	vote_1    |    Use a production WSGI server instead.
	vote_1    |  * Debug mode: on
	vote_1    |  * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
	vote_1    |  * Restarting with stat
	vote_1    |  * Debugger is active!
	vote_1    |  * Debugger PIN: 718-555-443
	vote_1    |  * Serving Flask app "app" (lazy loading)
	vote_1    |  * Environment: production
	vote_1    |    WARNING: This is a development server. Do not use it in a production deployment.
	vote_1    |    Use a production WSGI server instead.
	vote_1    |  * Debug mode: on
	vote_1    |  * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
	vote_1    |  * Restarting with stat
	vote_1    |  * Debugger is active!
	vote_1    |  * Debugger PIN: 718-555-443
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:51:29] "GET / HTTP/1.1" 200 -
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:51:29] "GET /static/stylesheets/style.css HTTP/1.1" 200 -
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:51:30] "GET /favicon.ico HTTP/1.1" 404 -
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:52:03] "POST / HTTP/1.1" 200 -
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:52:11] "POST / HTTP/1.1" 200 -
	vote_1    | 10.3.138.109 - - [02/Oct/2019 09:52:23] "POST / HTTP/1.1" 200 -
	result_1  | [nodemon] 1.19.3
	result_1  | [nodemon] to restart at any time, enter `rs`
	result_1  | [nodemon] watching dir(s): *.*
	result_1  | [nodemon] watching extensions: js,mjs,json
	result_1  | [nodemon] starting `node --debug server.js`
	result_1  | [nodemon] running an unsupported version of node v5.11.0
	result_1  | [nodemon] nodemon may not work as expected - please consider upgrading to LTS
	result_1  | Debugger listening on port 5858
	result_1  | Wed, 02 Oct 2019 09:50:35 GMT body-parser deprecated bodyParser: use individual json/urlencoded middlewares at server.js:67:9
	result_1  | Wed, 02 Oct 2019 09:50:35 GMT body-parser deprecated undefined extended: provide extended option at ../node_modules/body-parser/index.js:105:29
	result_1  | App running on port 80
	result_1  | Connected to db
	result_1  | [nodemon] 1.19.3
	result_1  | [nodemon] to restart at any time, enter `rs`
	result_1  | [nodemon] watching dir(s): *.*
	result_1  | [nodemon] watching extensions: js,mjs,json
	result_1  | [nodemon] starting `node --debug server.js`
	result_1  | [nodemon] running an unsupported version of node v5.11.0
	result_1  | [nodemon] nodemon may not work as expected - please consider upgrading to LTS
	result_1  | Debugger listening on port 5858
	result_1  | Wed, 02 Oct 2019 09:51:10 GMT body-parser deprecated bodyParser: use individual json/urlencoded middlewares at server.js:67:9
	result_1  | Wed, 02 Oct 2019 09:51:10 GMT body-parser deprecated undefined extended: provide extended option at ../node_modules/body-parser/index.js:105:29
	result_1  | App running on port 80
	result_1  | Connected to db
	[root@docker example-voting-app]# docker-compose events

	^CERROR: Aborting.
	[root@docker example-voting-app]# docker-compose exec worker ping -c 3 db
	PING db (172.20.0.2): 56 data bytes
	64 bytes from 172.20.0.2: icmp_seq=0 ttl=64 time=0.080 ms
	64 bytes from 172.20.0.2: icmp_seq=1 ttl=64 time=0.084 ms
	64 bytes from 172.20.0.2: icmp_seq=2 ttl=64 time=0.085 ms
	--- db ping statistics ---
	3 packets transmitted, 3 packets received, 0% packet loss
	round-trip min/avg/max/stddev = 0.080/0.083/0.085/0.000 ms
	[root@docker example-voting-app]# docker-compose up -d --scale worker=3
	redis is up-to-date
	Starting example-voting-app_worker_1 ...
	example-voting-app_vote_1 is up-to-date
	example-voting-app_result_1 is up-to-date
	Starting example-voting-app_worker_1 ... done
	Creating example-voting-app_worker_2 ... done
	Creating example-voting-app_worker_3 ... done
	[root@docker example-voting-app]# docker-compose up -d --scale vote=3
	redis is up-to-date
	example-voting-app_result_1 is up-to-date
	WARNING: The "vote" service specifies a port on the host. If multiple containers for this service are created on a single host, the port will clash.
	Starting example-voting-app_vote_1                ... done
	Stopping and removing example-voting-app_worker_2 ...
	Stopping and removing example-voting-app_worker_3 ...
	db is up-to-date
	Creating example-voting-app_vote_2                ... error
	Creating example-voting-app_vote_3                ... error

	ERROR: for example-voting-app_vote_2  Cannot start service vote: driver failed programming external connectivity on endpoint example-voting-app_vote_2 (9efe5b34452daStopping and removing example-voting-app_worker_2 ... done
	Stopping and removing example-voting-app_worker_3 ... done
	ERROR: for example-voting-app_vote_3  Cannot start service vote: driver failed programming external connectivity on endpoint example-voting-app_vote_3 (0f6a625ef2237781bc8d10d1d66fd4df28d55cf9e3c15d960e049a621815c6d2): Bind for 0.0.0.0:5000 failed: port is already allocated
	Starting example-voting-app_worker_1              ... done

	ERROR: for vote  Cannot start service vote: driver failed programming external connectivity on endpoint example-voting-app_vote_2 (9efe5b34452da37bd409fac2f26415f92cf06383f20e35bf8e389f95ee616222): Bind for 0.0.0.0:5000 failed: port is already allocated
	ERROR: Encountered errors while bringing up the project.
	[root@docker example-voting-app]# docker-compose ps
	           Name                          Command                State                        Ports
	----------------------------------------------------------------------------------------------------------------------
	db                            docker-entrypoint.sh postgres    Up         5432/tcp
	example-voting-app_result_1   nodemon --debug server.js        Up         0.0.0.0:5858->5858/tcp, 0.0.0.0:5001->80/tcp
	example-voting-app_vote_1     python app.py                    Up         0.0.0.0:5000->80/tcp
	example-voting-app_vote_2     python app.py                    Exit 128
	example-voting-app_vote_3     python app.py                    Exit 128
	example-voting-app_worker_1   /bin/sh -c dotnet src/Work ...   Up
	redis                         docker-entrypoint.sh redis ...   Up         0.0.0.0:32770->6379/tcp
	[root@docker example-voting-app]#
	[root@docker example-voting-app]#
	[root@docker example-voting-app]# docker-compose kill
	Killing example-voting-app_worker_1 ... done
	Killing db                          ... done
	Killing redis                       ... done
	Killing example-voting-app_vote_1   ... done
	Killing example-voting-app_result_1 ... done
	[root@docker example-voting-app]# docker-compose rm
	Going to remove example-voting-app_vote_3, example-voting-app_vote_2, example-voting-app_worker_1, db, redis, example-voting-app_vote_1, example-voting-app_result_1
	Are you sure? [yN] y
	Removing example-voting-app_vote_3   ... done
	Removing example-voting-app_vote_2   ... done
	Removing example-voting-app_worker_1 ... done
	Removing db                          ... done
	Removing redis                       ... done
	Removing example-voting-app_vote_1   ... done
	Removing example-voting-app_result_1 ... done
	[root@docker example-voting-app]#
	[root@docker example-voting-app]#
	[root@docker example-voting-app]#
	[root@docker example-voting-app]#
	[root@docker example-voting-app]# cd ..
	[root@docker materials]# ls
	dockerfile-example  example-voting-app  mobycounter  prometheus
	[root@docker materials]# cd mobycounter/
	[root@docker mobycounter]# docker-compose kill
	Killing mobycounter_mobycounter_1 ... done
	Killing mobycounter_redis_1       ... done
	[root@docker mobycounter]# docker-compose rm
	Going to remove mobycounter_mobycounter_1, mobycounter_redis_1
	Are you sure? [yN] y
	Removing mobycounter_mobycounter_1 ... done
	Removing mobycounter_redis_1       ... done
	[root@docker mobycounter]#
	[root@docker mobycounter]#
	[root@docker mobycounter]# docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
	[root@docker mobycounter]#