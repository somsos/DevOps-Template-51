# 0dep_data/ folder


- [0dep\_data/ folder](#0dep_data-folder)
  - [How is --code.tar.xz-- and --t51devops.tar.xz-- created](#how-is---codetarxz---and---t51devopstarxz---created)
  - [How is --offlineDeps.tar.xz...-- file created](#how-is---offlinedepstarxz---file-created)
    - [Extraction](#extraction)
    - [Todos los archivos y carpetas](#todos-los-archivos-y-carpetas)
    - [How to create a file IMAGE\_...tar](#how-to-create-a-file-image_tar)
  - [How is pre\_initialized\_nexus\_mvn\_npm.tar.xz created](#how-is-pre_initialized_nexus_mvn_npmtarxz-created)



## How is --code.tar.xz-- and --t51devops.tar.xz-- created

Both are created the same way, the only difference is that one has the .git
folder and the other one doesn't.

```bash
8
T51_TAR_1="code.tar.xz"
T51_TAR_2="t51devops.tar.xz"

cd $T51_SOURCE_FILES

git pull origin main

rm -fvr ../temp/ && mkdir -v ../temp/
test -f .env.example && echo "OK" || echo "SOMETHING IS WRONG"

tar -cJf ../temp/$T51_TAR_1 .
#     OR
tar --exclude='.git' --exclude='t51devops.tar.xz' -cJf ../temp/$T51_TAR_2 .


# To check the uncompressed file, the files must not be inside a root folder,
# the root folder have the files, for example.
cd ../temp/
tar -xJf $T51_TAR -C .
test -d ./.git/ && echo "OK" || echo "SOMETHING IS WRONG"

```

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->


## How is --offlineDeps.tar.xz...-- file created

```shell
cd ./dep_data
test -f ./0dep_data.md && echo "[OK] Continue" || echo "WARN: seems the wrong path"
# IMPORTANT: compare it with the ".env.example" file, it must be all the "IMAGE_***" variables
docker save --output ./IMAGE_MVN.tar maven:3.9.9-eclipse-temurin-21-alpine
docker save --output ./IMAGE_JENKINS.tar jenkins/jenkins:2.555.1-lts-jdk25
docker save --output ./IMAGE_T51JENKINS.tar t51-jenkins:latest
docker save --output ./IMAGE_GITEA.tar docker.gitea.com/gitea:1.26.1-rootless
docker save --output ./IMAGE_JAVA.tar eclipse-temurin:21-alpine
docker save --output ./IMAGE_NODE.tar node:25.7-alpine3.23
docker save --output ./IMAGE_NGINX.tar nginx:stable-alpine3.23
docker save --output ./IMAGE_REVERSE_PROXY.tar nginxproxy/nginx-proxy:1.10-alpine
docker save --output ./IMAGE_ACME_COMPANION.tar nginxproxy/acme-companion:2.6
docker save --output ./IMAGE_HTTPD.tar httpd:2
docker save --output ./IMAGE_NEXUS.tar sonatype/nexus3:3.93.0-alpine
docker save --output ./IMAGE_CURL.tar curlimages/curl:8.20.0
docker save --output ./IMAGE_T51DB_UTILS.tar db_utils:latest
docker save --output ./IMAGE_DB.tar postgres:17.6-alpine3.22
docker save --output ./IMAGE_DB_MIG.tar liquibase:4.33-alpine

# Download the files following the guide https://docs.docker.com/engine/install/ubuntu/#install-from-a-package
# and save them in docker_installer.
# Avoid the file docker-buildx-plugin_<version>_<arch>.deb, because it's not
# required.
# In my case that I downloaded to install it in Ubuntu24.
cd ./dep_data/docker_installer_ubuntu
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

cd ./dep_data/docker_installer_debian
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/containerd.io_2.3.6-1~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-ce_29.8.2-1~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-ce-cli_29.8.2-1~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-compose-plugin_5.6.0-1~debian.13~trixie_amd64.deb


cd ./dep_data/docker_installer_alma10
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/containerd.io-2.3.6-1.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-ce-29.8.2-1.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-ce-cli-29.8.2-1.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-compose-plugin-5.6.0-1.el10.x86_64.rpm




cd ./dep_data/docker_installer_fedora
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-compose-plugin-5.6.0-1.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-ce-cli-29.8.2-1.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/containerd.io-2.3.6-1.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-compose-plugin-5.6.0-1.fc44.x86_64.rpm




cd ./dep_data/docker_installer_suse
wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/containerd.io-1.7.24-3.1.s390x.rpm
wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-ce-27.4.1-1.s390x.rpm
wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-ce-cli-27.4.1-1.s390x.rpm
wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-compose-plugin-2.6.0-3.s390x.rpm



# And to create the pre_initialized_nexus_mvn_npm.tar.xz file, just compress
# the  nexus volume in a desired state.
cd ./setup/nexus/vol-data
test -f ./etc/nexus.properties && echo "[OK] Continue" || echo "WARN: seems the wrong path"
tar czf ../../../dep_data/pre_initialized_nexus_mvn_npm-2.tar.gz .

# It's IMPORTANT to use the path "./*" because otherwise it will keep the paths
# in the compressed file, making it confusing for who uncompress it, so this
# way the files will be in the root.
cd ./dep_data
test -f ./0dep_data.md && echo "[OK] Continue" || echo "WARN: seems the wrong path"

# Compress
tar cJf - ./* | split -b 1900M - ./offlineDeps.tar.xz.
```

### Extraction

```sh
cat offlineDeps.tar.xz.a* | tar xJf - -C .
```



### Todos los archivos y carpetas

```yml
./docker_installer_ubuntu/
    containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
    docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
    docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
    docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
./docker_installer_fedora/
    containerd.io-2.3.6-1.fc44.x86_64.rpm
    docker-ce-29.8.2-1.fc44.x86_64.rpm
    docker-ce-cli-29.8.2-1.fc44.x86_64.rpm
    docker-compose-plugin-5.6.0-1.fc44.x86_64.rpm
./docker_installer_debian/
    ...
./docker_installer_alma/
    ...
./pre_initialized_nexus_mvn_npm.tar.xz
./IMAGE_DB.tar
./IMAGE_DB_MIG.tar
./IMAGE_ACME_COMPANION.tar
./IMAGE_CURL.tar
./IMAGE_GITEA.tar
./IMAGE_HTTPD.tar
./IMAGE_JAVA.tar
./IMAGE_JENKINS.tar
./IMAGE_MVN.tar
./IMAGE_NEXUS.tar
./IMAGE_NGINX.tar
./IMAGE_NODE.tar
./IMAGE_REGISTRY.tar
./IMAGE_REVERSE_PROXY.tar
./IMAGE_T51DB_UTILS.tar
./IMAGE_T51JENKINS.tar
```


### How to create a file IMAGE_...tar

Just use this command  


```sh
docker save --output <path/file.tar> <IMAGE_NAME>`
```


<!-- 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-->

## How is pre_initialized_nexus_mvn_npm.tar.xz created

First we need to go to nexus services and make sure or change that admin user
has the default values. So the install.sh script can change the credentials, for
the ones defined by the user.

```sh
DEFAULT_USER="admin"
DEFAULT_PASS="admin123"
```


```sh
T51_ROOT="/home/mario/mine/p/t51"

cd $T51_ROOT/setup/nexus/vol-data/

tar -cJf $T51_ROOT/dep_data/pre_initialized_nexus_mvn_npm.tar.xz .

```
