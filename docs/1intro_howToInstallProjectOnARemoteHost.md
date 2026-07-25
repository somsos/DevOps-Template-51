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

## Introduction

As the idea is to have a self-hosted DevOps setup, so the most likely scenario is
to use it on a remote server with linux, thought a SSH connection, in my case, I
use to create a VPS (Virtual private servers) on any cloud supplier as AWS,
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
DEV_PC> HOST_IP=192.168.50.8
DEV_PC> HOST_USER=mario1

# If the project is downloaded we can avoid the cloning with...
# DEV_PC> scp -r -P22 ./dep_data/empty_t51.tar.gz $HOST_USER@$HOST_IP:~/my-project

DEV_PC> ssh $HOST_USER@$HOST_IP
HOST> git clone https://github.com/somsos/DevOps-Template-51 ~/my-project
```


## Offline install

### Download heavy dependencies

We follow the same steps as docker official in the guide 
[install from a packages](https://docs.docker.com/engine/install/ubuntu/#install-from-a-package),
this is a copy and paste, for as quick reference.

1, Option A, Download the pre-downloaded dependencies from this link
```shell
cd ~/my-project
wget -O ~/my-project/dep_data/dep_data.tar.gzaa https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/dep_data.tar.gzaa
wget -O ~/my-project/dep_data/dep_data.tar.gzab https://github.com/somsos/DevOps-Template-51/releases/download/V0.10/dep_data.tar.gzab
```

1, Option B, Or if one already downloaded the files, we run this commands in the
machine of the developer.
```shell
HOST_IP=192.168.50.8
HOST_USER=mario1
scp -r -P22 ./dep_data.tar.gzaa $HOST_USER@$HOST_IP:~/my-project/dep_data
scp -r -P22 ./dep_data.tar.gzab $HOST_USER@$HOST_IP:~/my-project/dep_data
```

2, Uncompress, executing in the remote host.

```shell
cd ~/my-project/dep_data/
test -f ./0dep_data.md && echo "[OK] Continue" || echo "WARN: seems the wrong path"
cat dep_data.tar.* | tar xzf - -C .
```

### Install docker offline

If you want to test without internet this is the moment to disconnect.

```shell
# Just as checking if we really want to test it without internet.
wget -qT 3 --spider https://www.google.com && echo "There's internet" || echo "NO INTERNET"

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
docker run hello-world
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


## Install docker online

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


## Install and start project

```shell
cd ~/my-project
bash ./install.sh
```

Check created services

```shell
Gitea     http://gitea.tina-qa.com
Jenkins   http://jenkins.tina-qa.com
Nexus     http://nexus.tina-qa.com
Backend   http://api.tina-qa.com/swagger-ui/index.html
Registry  http://registry.tina-qa.com
Frontend  http://tina-qa.com
Database  psql postgresql://${MY_USER}:$DB_PASS@$HOST_IP:5001/${MY_USER}1db
```
