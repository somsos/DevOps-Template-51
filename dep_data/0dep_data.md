
## How to create the compressed ile

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
docker save --output ./DB_IMAGE.tar postgres:17.6-alpine3.22
docker save --output ./DB_MIG_IMAGE.tar liquibase:4.33-alpine

# Download the files following the guide https://docs.docker.com/engine/install/ubuntu/#install-from-a-package
# and save them in docker_installer.
# Avoid the file docker-buildx-plugin_<version>_<arch>.deb, because it's not
# required.
# In my case that I downloaded to install it in Ubuntu24.
cd ./dep_data/docker_installer
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb

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
tar czf - ./* | split -b 1900M - ./dep_data.tar.gz

cat /path/to/output/prefix.tar.gz.* | tar xzf /p1/dep_data/dep_data.tar.xz -C /p1
```

## Todos los archivos y carpetas

```yml
./docker_installer/
  containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
  docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
pre_initialized_nexus_mvn_npm.tar.xz
DB_IMAGE.tar
DB_MIG_IMAGE.tar
IMAGE_ACME_COMPANION.tar
IMAGE_CURL.tar
IMAGE_GITEA.tar
IMAGE_HTTPD.tar
IMAGE_JAVA.tar
IMAGE_JENKINS.tar
IMAGE_MVN.tar
IMAGE_NEXUS.tar
IMAGE_NGINX.tar
IMAGE_NODE.tar
IMAGE_REGISTRY.tar
IMAGE_REVERSE_PROXY.tar
IMAGE_T51DB_UTILS.tar
IMAGE_T51JENKINS.tar
```


## Imagenes

Tal y como las entrega el comando `docker save --output <path/file.tar> <IMAGE_NAME>`

Em mi caso la ultima vez tuve esta lista de imagenes.

```yml
DB_IMAGE.tar
DB_MIG_IMAGE.tar
IMAGE_ACME_COMPANION.tar
IMAGE_CURL.tar
IMAGE_GITEA.tar
IMAGE_HTTPD.tar
IMAGE_JAVA.tar
IMAGE_JENKINS.tar
IMAGE_NEXUS.tar
IMAGE_NGINX.tar
IMAGE_NODE.tar
IMAGE_REGISTRY.tar
IMAGE_REVERSE_PROXY.tar
```

## docker installer

Se siguio la documentacion oficial para instalacion de ubuntu, en mi caso termine
con estos archivos

```yml
./docker_installer/
  containerd.io_2.2.4-1~ubuntu.24.04~noble_amd64.deb
  docker-ce_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-ce-cli_29.5.3-1~ubuntu.24.04~noble_amd64.deb
  docker-compose-plugin_5.1.4-1~ubuntu.24.04~noble_amd64.deb
```

## mvn and npm dependencies

Se crea un comprimido con el contenido de `setup/nexus/vol-data/*`, (CUIDADO: NO
debe de incluir la carpeta `vol-data` solo su contenido.)

```yml
pre_initialized_nexus_mvn_npm.tar.xz
```
