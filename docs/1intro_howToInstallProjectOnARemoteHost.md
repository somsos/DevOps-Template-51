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
- glibc (There is a small problem with musl and its DNS resolution)









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
# Check we have 16GB storage available "look for: mounted on: '/' "
df -h

HOST_P_ROOT=/home/$USER/my-project
# Optional: If we downloaded the files in our developer machine.
# DEV-LAP> HOST_USER=mario1
# DEV-LAP> HOST_P_ROOT=/home/$HOST_USER/my-project
# DEV-LAP> DEV_P_ROOT=/home/mario/mine/p/t51
# DEV-LAP> HOST_IP=192.168.1.8
# DEV-LAP> ssh $HOST_USER@$HOST_IP "mkdir -vp $HOST_P_ROOT/dep_data/"
# DEV-LAP> scp $DEV_P_ROOT/dep_data/code.tar.xz $HOST_USER@$HOST_IP:$HOST_P_ROOT/
# DEV-LAP> scp -r $DEV_P_ROOT/dep_data/offlineDeps.tar.xz.a* $HOST_USER@$HOST_IP:$HOST_P_ROOT/dep_data/

rm -rfv $HOST_P_ROOT && mkdir -vp $HOST_P_ROOT && cd $HOST_P_ROOT

curl -L -o $HOST_P_ROOT/code.tar.xz https://github.com/somsos/DevOps-Template-51/releases/download/0.11/code.tar.xz

tar xJf $HOST_P_ROOT/code.tar.xz -C . && rm -v $HOST_P_ROOT/code.tar.xz

curl -L -o dep_data/offlineDeps.tar.gzaa https://github.com/somsos/DevOps-Template-51/releases/download/0.11/offlineDeps.tar.gzaa && curl -L -o dep_data/offlineDeps.tar.gzab https://github.com/somsos/DevOps-Template-51/releases/download/0.11/offlineDeps.tar.gzab

cd $HOST_P_ROOT/dep_data/ && cat offlineDeps.tar.xz.a* | tar xJf - -C . && rm -v $HOST_P_ROOT/dep_data/offlineDeps.tar.xz.a*
```

2, Install docker

```shell
# Just as checking if we really want to test it without internet.
# Temp: 10.222.58.8
# We can cut off access to internet by setting a wrong gateway with...
# (in my case the right one is ...254 )
#   nmcli con show
#   sudo nmcli con mod cable ipv4.gateway 192.168.1.1 
#   sudo nmcli con up cable
curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET, CONTINUE"



# Note: The official docker install trough package (offline), it says to install
# also this "./docker-buildx-plugin_0.34.1-1~ubuntu.24.04~noble_amd64.deb" but
# for this we do not need buildX

# Ubuntu
cd $HOST_P_ROOT/dep_data/docker_installer_ubuntu24
sudo dpkg -i ./containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb \
    ./docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

# Debian
cd $HOST_P_ROOT/dep_data/docker_installer_debian13
dpkg -i ./containerd.io_2.3.6-1~debian.13~trixie_amd64.deb \
  ./docker-ce_29.8.2-1~debian.13~trixie_amd64.deb \
  ./docker-ce-cli_29.8.2-1~debian.13~trixie_amd64.deb \
  ./docker-compose-plugin_5.6.0-1~debian.13~trixie_amd64.deb


# Alma10
cd $HOST_P_ROOT/dep_data/docker_installer_alma10
sudo dnf install ./containerd.io-2.3.6-1.el10.x86_64.rpm \
  ./docker-ce-29.8.2-1.el10.x86_64.rpm \
  ./docker-ce-cli-29.8.2-1.el10.x86_64.rpm \
  ./docker-compose-plugin-5.6.0-1.el10.x86_64.rpm


# Fedora
cd $HOST_P_ROOT/dep_data/docker_installer_fedora44
sudo sudo dnf install ./containerd.io-2.3.6-1.fc44.x86_64.rpm \
    ./docker-ce-29.8.2-1.fc44.x86_64.rpm \
    ./docker-ce-cli-29.8.2-1.fc44.x86_64.rpm \
    ./docker-compose-plugin-5.6.0-1.fc44.x86_64.rpm

# SUSE
cd $HOST_P_ROOT/dep_data/docker_installer_suse2026
sudo transactional-update pkg install \
  ./containerd.io-1.7.24-3.1.s390x.rpm \
  ./docker-ce-27.4.1-1.s390x.rpm \
  ./docker-ce-cli-27.4.1-1.s390x.rpm \
  ./docker-compose-plugin-2.6.0-3.s390x.rpm

# Start Decker
sudo systemctl enable --now docker

sudo systemctl start docker

sudo systemctl status docker

docker --version

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
git clone https://github.com/somsos/DevOps-Template-51 $P_ROOT
```

2, Install docker online

The project requires a normal docker install, so as the we can follow the
[official documentation](https://docs.docker.com/engine/install/#installation-procedures-for-supported-platforms).
I put this guide just as a quick reference.

Also do not forget the [post-installation](https://docs.docker.com/engine/install/linux-postinstall/) steps,
so we can use docker without root.

In Ubuntu server

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
cd $HOST_P_ROOT
MY_ENV=test
MY_DOMAIN=example1-$MY_ENV.com
MY_USER=myTestUser
MY_PASS=myTestUser1p

bash ./install.sh <<EOF
$MY_ENV
$MY_DOMAIN
$MY_USER
$MY_PASS
$MY_PASS
EOF

# Optional (We can run it again just to see the available services more easily)
bash ./install.sh
```

2, Check created services, In my case I usually in my **developing machine** add
temporal domains my local DNS file.

```shell
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
psql -U $MY_USER -h $HOST_IP -p 5001 -d ${MY_USER}1db -c "\dt"

```

Optional, If we have few disk space we can delete de dep_data/IMAGES_* files,
because it happened me, that jenkins pipelines stop working, because there was
less than 1GB available.

```bash
rm -rfv $HOST_P_ROOT/dep_data/

df -h
```



