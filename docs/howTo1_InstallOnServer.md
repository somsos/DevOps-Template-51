# Offline install

- [Offline install](#offline-install)
  - [Requirements](#requirements)
  - [Clone project and copy heavy dependencies](#clone-project-and-copy-heavy-dependencies)
  - [Offline install](#offline-install-1)
    - [Download pre-downloaded dependencies from Mega](#download-pre-downloaded-dependencies-from-mega)
    - [Install docker offline](#install-docker-offline)
  - [Install docker online](#install-docker-online)
  - [Install and start project](#install-and-start-project)
  - [Link domains](#link-domains)
  - [Approve scrips](#approve-scrips)

## Requirements

- openssh-server
- 15GB free space minimum
- Ubuntu Server 24.04 
  - This guide is for Ubuntu 24.04, but was tested also in CachyOS 7.1

## Clone project and copy heavy dependencies

```shell
ssh mario1@192.168.1.8
sudo mkdir -p /p1 && sudo chown -R mario1:mario1 /p1 && cd /p1
git clone https://github.com/somsos/somsos-template51-devops .
    # scp -r -P22 /home/mario/mine/empty_t51 mario1@192.168.1.8:/p1
```


## Offline install

### Download pre-downloaded dependencies from Mega

Download the pre-downloaded dependencies from this link

```shell
wget --quiet -O /p1/dep_data/dep_data.tar.xz https://mega.nz/file/SixW3T6C#zYgECe0Lj5Safwn18taN05rsyLEnKHLx7oSwqab-zX8
tar -xf /p1/dep_data/dep_data.tar.xz -C /p1
```

In a machine with the files already downloaded you can upload them with the
following command.

```shell
scp -r -P22 /home/mario/mine/t51/dep_data mario1@192.168.1.8:/p1
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

## Link domains 

Copy and peste to `/etc/hosts`, for example
```yml
192.168.1.8 yopi-test.com
192.168.1.8 api.yopi-test.com
192.168.1.8 gitea.yopi-test.com
192.168.1.8 jenkins.yopi-test.com
192.168.1.8 registry.yopi-test.com
192.168.1.8 nexus.yopi-test.com
```

Check created services
```yml
"http://gitea.yopi-test.com":                                    Gitea
"http://jenkins.yopi-test.com":                                  Jenkins
"http://registry.yopi-test.com":                                 Registry
"http://nexus.yopi-test.com":                                    Nexus
"http://api.yopi-test.com/swagger-ui/index.html":                Backend
"http://yopi-test.com":                                          Frontend
"psql postgresql://yopi1:<DB_PASS>@192.168.1.8:5001/yopi1db":  Database
```

## Approve scrips

By default the Jenkins pipelines are not approved, we need to do it manually.

http://jenkins.yopi-test.com/manage/scriptApproval/

