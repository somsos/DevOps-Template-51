# Install Project On A Remote Host

- [Install Project On A Remote Host](#install-project-on-a-remote-host)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Download using only first-party assets "Offline-mode"](#download-using-only-first-party-assets-offline-mode)
  - [Download by cloning and using dependencies in third-party servers](#download-by-cloning-and-using-dependencies-in-third-party-servers)
  - [Install DevOps Template 51 project](#install-devops-template-51-project)

## Introduction

As the idea is to have a self-hosted DevOps setup, so the most likely scenario is
to use it on a remote server with linux, thought a SSH connection, in my case, I
use to create a VPS (Virtual private servers) on any cloud supplier as AWS,
Google Cloud Platform, Contabo, etc with Ubuntu server 24.4 or similar.

## Requirements

- RAM 4Gb (Nexus uses 2gb)
- Hard drive: 15GB  free space minimum
- Any linux that passes the `setup/install_functions.sh -> check_dependencies` function
  - Tested in Ubuntu Server 24.04 and Arch Linux.
- Docker compose (Tested on version 5.1.4)
- OpenSSH (Tested on version 10.3, OpenSSL 3.6)









<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->






## Download using only first-party assets "Offline-mode"

1, Download code and heavy dependencies

```shell
mkdir -p ~/my-project && cd ~/my-project

wget -O code.tar.gz https://github.com/somsos/DevOps-Template-51/releases/download/0.11/code.tar.gz

tar xzf code.tar.gz -C . && rm ./code.tar.gz

wget -O dep_data/offlineDeps.tar.gzaa https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/offlineDeps.tar.gzaa && wget -O dep_data/offlineDeps.tar.gzab https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/offlineDeps.tar.gzab

cd dep_data/ && cat offlineDeps.tar.gza* | tar xzf - -C . && rm ./offlineDeps.tar.gza*
cd ~/my-project
```

2, Install docker

```shell
# Just as checking if we really want to test it without internet.
wget -qT 3 --spider https://www.google.com && echo "There's internet" || echo "NO INTERNET, CONTINUE"

cd ~/my-project/dep_data/docker_installer/

# Note: The official docker install trough package (offline), it says to install
# also this "./docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb" but
# for this we do not need buildX

sudo dpkg -i ./containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run --rm --name temp-test hello-world
# EXPECTED OUTPUT (it fails because there is no internet, what matters here is 
# checking we have rootless access)
# ... failed to do request: Head "https://registry-1.docker...
```








<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->








## Download by cloning and using dependencies in third-party servers

1, Clone repository

```shell
git clone https://github.com/somsos/DevOps-Template-51 ~/my-project
```

2, Install docker online

The project requires a normal docker install, so as the we can follow the
[official documentation](https://docs.docker.com/engine/install/#installation-procedures-for-supported-platforms).
I put this guide just as a quick reference.

Also do not forget the [post-installation](https://docs.docker.com/engine/install/linux-postinstall/) steps,
so we can use docker without root.

```shell
# COPY AND PASTE OF DOCKER OFFICIAL DOCUMENTATION 2026-07-06

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo groupadd docker
sudo usermod -aG docker $USER
docker run --rm --name temp-test hello-world
```







<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->








## Install DevOps Template 51 project

1, Run install script

```shell
cd ~/my-project

bash ./install.sh <<EOF
test
example1-test.com
myUser
myPass123p
myPass123p
EOF

# Services Created
# http://gitea.example1-test.com
# http://jenkins.example1-test.com/login
# http://nexus.example1-test.com
# http://api.example1-test.com/swagger-ui/index.html
# http://example1-test.com
# http://registry.example1-test.com
# psql -U $MY_USER -h $HOST_IP -p 5001 -d ${MY_USER}1db "\dt"

# Optional (We can run it again just to see the available services more easily)
bash ./install.sh
```

2, Check created services, In my case I usually in my **developing machine** add
temporal domains my local DNS file.

```shell
MY_DOMAIN=example1-test.com
HOST_IP=192.168.1.8
MY_USER=myUser

sudo tee -a /etc/hosts <<EOF

$HOST_IP $MY_DOMAIN
$HOST_IP api.$MY_DOMAIN
$HOST_IP gitea.$MY_DOMAIN
$HOST_IP jenkins.$MY_DOMAIN
$HOST_IP registry.$MY_DOMAIN
$HOST_IP nexus.$MY_DOMAIN

EOF

#Check services

# Gitea
curl -s -o /dev/null -w "%{http_code}\n" http://gitea.$MY_DOMAIN
# Jenkins
curl -s -o /dev/null -w "%{http_code}\n" http://jenkins.$MY_DOMAIN/login
# Nexus
curl -s -o /dev/null -w "%{http_code}\n" http://nexus.$MY_DOMAIN
# Backend
curl -s -o /dev/null -w "%{http_code}\n" http://api.$MY_DOMAIN/swagger-ui/index.html
# Frontend
curl -s -o /dev/null -w "%{http_code}\n" http://$MY_DOMAIN
# Registry
curl -s -o /dev/null -w "%{http_code}\n" http://registry.$MY_DOMAIN
# Database
psql -U $MY_USER -h $HOST_IP -p 5001 -d ${MY_USER}1db "\dt"

```

