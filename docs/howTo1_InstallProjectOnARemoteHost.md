# Install Project On A Remote Host

- [Install Project On A Remote Host](#install-project-on-a-remote-host)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Clone project](#clone-project)
  - [Offline install](#offline-install)
    - [Download heavy dependencies](#download-heavy-dependencies)
    - [Install docker offline](#install-docker-offline)
  - [Install docker online](#install-docker-online)
  - [Install and start project](#install-and-start-project)
  - [Approve Jenkins pipelines scrips](#approve-jenkins-pipelines-scrips)

## Introduction

As the idea is to have a self-hosted DevOps setup, so the most likely scenario is
to use it on a remote server with linux, thought a SSH connection, in my case, I
use to create VPS (Virtual private servers) on any cloud supplier as AWS,
Google Cloud Platform, Contabo, etc with Ubuntu server 24.4 or similar.

## Requirements

- RAM 4Gb (Nexus uses 2gb)
- 15GB free space minimum
- Any linux that passes the `setup/install_functions.sh -> check_dependencies` function
  - Tested in Ubuntu Server 24.04 and Arch Linux.
- Docker compose (Tested on version 5.1.4)
- OpenSSH (Tested on version 10.3, OpenSSL 3.6)

## Clone project

```shell
ssh user1@<HOST_IP>
sudo mkdir -p /p1 && sudo chown -R user1:user1 /p1 && cd /p1
git clone https://github.com/somsos/DevOps-Template-51 .
    # scp -r -P22 /home/mario/mine/empty_t51 user1@<HOST_IP>:/p1
```


## Offline install

### Download heavy dependencies

Download the pre-downloaded dependencies from this link

```shell
# Download
wget --quiet -O /p1/dep_data/dep_data.tar.gzaa https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/dep_data.tar.gzaa
wget --quiet -O /p1/dep_data/dep_data.tar.gzab https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/dep_data.tar.gzab

# Uncompress
cat /p1/dep_data/dep_data.tar.* | tar xzf - -C /p1
```

In a machine with the files already downloaded you can upload them with the
following command.

```shell
scp -r -P22 /home/mario/mine/t51/dep_data user1@<HOST_IP>:/p1
```

### Install docker offline

```shell
cd /p1/dep_data/docker_installer/

# In this point change to a network without internet

sudo dpkg -i ./containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

# To avoid docker starts automatically at the start
        sudo systemctl disable docker.service containerd.service docker.socket docker

        # each time the machine starts
        sudo systemctl start containerd.service docker.socket docker.service docker
        sudo systemctl stop docker containerd.service docker.socket docker.service
```



<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->


## Install docker online

The project requires a normal docker install, so as the we can follow the
[official documentation](https://docs.docker.com/engine/install/#installation-procedures-for-supported-platforms).

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


## Install and start project

```shell
cd /p1
bash ./install.sh
```

Check created services

```yml
"http://gitea.tina-qa.com":                                    Gitea
"http://jenkins.tina-qa.com":                                  Jenkins
"http://nexus.tina-qa.com":                                    Nexus
"http://api.tina-qa.com/swagger-ui/index.html":                Backend
"http://registry.tina-qa.com":                                 Registry
"http://tina-qa.com":                                          Frontend
"psql postgresql://yopi1:<DB_PASS>@<HOST_IP>:5001/yopi1db":  Database
```

## Approve Jenkins pipelines scrips

By default the Jenkins pipelines are not approved, we need to do it manually.

```shell
http://jenkins.tina-qa.com/manage/scriptApproval/
```
