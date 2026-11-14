# How to develop as a DevOps



- [How to develop as a DevOps](#how-to-develop-as-a-devops)
  - [build base-db-utils:latest image](#build-base-db-utilslatest-image)
  - [How to uninstall setup](#how-to-uninstall-setup)
  - [How is --code.tar.xz-- and --t51devops.tar.xz-- created](#how-is---codetarxz---and---t51devopstarxz---created)
  - [How is --offlineDeps.tar.xz...-- file created](#how-is---offlinedepstarxz---file-created)
    - [Extraction](#extraction)
    - [Todos los archivos y carpetas](#todos-los-archivos-y-carpetas)
    - [How to create a file IMAGE\_...tar](#how-to-create-a-file-image_tar)
  - [How is pre\_initialized\_nexus\_mvn\_npm.tar.xz created](#how-is-pre_initialized_nexus_mvn_npmtarxz-created)
  - [Create compressed file for create a repo in gitea](#create-compressed-file-for-create-a-repo-in-gitea)





## build base-db-utils:latest image

```sh
test -f .env && source .env || echo ".env file not found" && \
test -z "$IMAGE_DB_MIG_BASE" && echo "ERROR, required var not found" || echo "$IMAGE_DB_MIG_BASE" && \
test -z "$NETWORK_NAME" && echo "ERROR, required var not found" || echo "$NETWORK_NAME"

# It's commented because I removed buildx
#docker buildx build --build-arg IMAGE_DB_MIG_BASE=liquibase:5.0.1-alpine -f ./app/db/base_db_utils.dockerfile --load -t base_db_utils:latest ./app/db
docker compose --progress plain build --build-arg IMAGE_DB_MIG_BASE=$IMAGE_DB_MIG_BASE db_utils

docker run --rm --entrypoint sh db_utils:latest -c 'find / -iname "*postgresql*.jar" 2>/dev/null'
# OUTPUT expected
# /liquibase/lib/postgresql.jar

```







<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->










## How to uninstall setup

```shell

function t51uninstall {
  set -x

  docker compose --profile all down

  docker volume rm t51_t51DB_vol1

  cd /home/mario/mine/p/t51/

  rm -fv ./.env

  rm -rfv setup/secrets/registry.password setup/secrets/ssh_key.priv setup/secrets/ssh_key.pub setup/gitea/vol-config-dir/app.ini

  sudo rm -rfv setup/jenkins/vol-jenkins_home/ | tail -n5 && git restore setup/jenkins/vol-jenkins_home
  rm -rfv setup/gitea/vol-data | tail -n5 && git restore setup/gitea/vol-data
  rm -rfv setup/nexus/vol-data | tail -n5 && git restore setup/nexus/vol-data/0vol-data.md


  # In case of having these errors:
  #   - "Error response from daemon: RWLayer of container ... is unexpectedly nill"
  docker container prune -f
  docker builder prune -af
  # CAUTION: his will make download again the images.
  docker image prune -af
  #docker buildx prune -af

  result=$(docker images -qa 2>/dev/null)

  if [ -z "$result" ]; then
      echo "No images found"
  else
      echo "Images found"
      docker images -qa | xargs docker rmi
  fi

  # delete the added host
  #sudo nano ~/.ssh/config
  #sudo nano ~/.ssh/known_hosts
  #sudo nano /etc/hosts

  # restart
  sudo systemctl stop docker containerd.service docker.socket docker.service
  sudo systemctl start containerd.service docker.socket docker.service docker

  set +x
}

t51uninstall

# Description: Running "docker compose up ..." gives this error.
# Most probable causes
#   - docker metadata corruption
#   - interrupted container creation
#   - a container references an invalid image layer
#   - Incompatible Docker version state

# docker buildx ls
```








## How is --code.tar.xz-- and --t51devops.tar.xz-- created

Both are created the same way, the only difference is that one has the .git
folder and the other one doesn't.

```bash

function create_top_tar {
    set -x
    T51_SOURCE_FILES="/home/mario/mine/p/empty_t51"
    TARGET_1="/home/mario/mine/p/t51/dep_data/toUpload"
    TARGET_2="/home/mario/mine/p/t51/setup/gitea/initial_repos"
    if [[ "$1" != "code.tar.xz" && "$1" != "t51devops.tar.xz" ]]; then
         echo "[ERROR] first arg must be code.tar.xz or  t51devops.tar.xz"
        return 1
    fi
    if [ ! -f $T51_SOURCE_FILES/.env.example ]; then
        echo "error: .env.example file not found"
        return 1
    fi

    cd $T51_SOURCE_FILES

    git pull origin main

    if [ "$1" == "t51devops.tar.xz" ]; then
        test -d $TARGET_2 || (echo "error: $TARGET_2 folder not found" &&  exit 1)
        rm -fv $TARGET_2/$1
        tar --exclude='.git' --exclude='t51devops.tar.xz' -cJf $TARGET_2/$1 .
    fi

    if [ "$1" == "code.tar.xz" ]; then
        test -d $TARGET_1 || (echo "error: $TARGET_1 folder not found" &&  exit 1)
        rm -fv $TARGET_1/$1
        tar -cJf $TARGET_1/$1 .
    fi
    set +x
}

create_top_tar "t51devops.tar.xz"

create_top_tar "code.tar.xz"





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
docker save --output ./IMAGE_MVN.tar maven:3.10.0-eclipse-temurin-25-alpine
docker save --output ./IMAGE_JENKINS.tar jenkins/jenkins:2.586-jdk25
docker save --output ./IMAGE_GITEA.tar gitea/gitea:28.2-rootless
docker save --output ./IMAGE_JAVA.tar eclipse-temurin:25-jre-alpine-3.24
docker save --output ./IMAGE_NODE.tar node:24.22.0-trixie-slim
docker save --output ./IMAGE_NGINX.tar nginx:1.30.6-alpine3.24-slim
docker save --output ./IMAGE_REVERSE_PROXY.tar nginxproxy/nginx-proxy:1.11.6-alpine
docker save --output ./IMAGE_ACME_COMPANION.tar nginxproxy/acme-companion:2.8
docker save --output ./IMAGE_HTTPD.tar httpd:2
docker save --output ./IMAGE_NEXUS.tar sonatype/nexus3:3.96.4-alpine
docker save --output ./IMAGE_CURL.tar curlimages/curl:8.23.0
docker save --output ./IMAGE_DB.tar postgres:18.6-trixie
docker save --output ./IMAGE_DB_MIG_BASE.tar liquibase:5.0.1-alpine
docker save --output ./IMAGE_DB_MIG.tar base_db_utils:latest
docker save --output ./IMAGE_T51JENKINS.tar t51-jenkins:latest
#docker save --output ./IMAGE_T51DB_UTILS.tar db_utils:latest # a new one is generated every deploy, just change the liquibase scripts

# Download the files following the guide https://docs.docker.com/engine/install/ubuntu/#install-from-a-package
# and save them in docker_installer.
# Avoid the file docker-buildx-plugin_<version>_<arch>.deb, because it's not
# required.
# In my case that I downloaded to install it in Ubuntu24.
cd ./dep_data/docker_installer_ubuntu24
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/containerd.io_2.4.2-3~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce_29.9.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce-cli_29.9.3-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-compose-plugin_5.7.0-1~ubuntu.24.04~noble_amd64.deb


cd ./dep_data/docker_installer_debian13
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/containerd.io_2.4.2-3~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-ce_29.9.3-1~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-ce-cli_29.9.3-1~debian.13~trixie_amd64.deb
wget https://download.docker.com/linux/debian/dists/trixie/pool/stable/amd64/docker-compose-plugin_5.7.0-1~debian.13~trixie_amd64.deb



cd ./dep_data/docker_installer_alma10
sudo dnf download --resolve --alldeps --destdir ./rpms container-selinux
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/containerd.io-2.4.2-3.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-ce-29.9.3-1.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-ce-cli-29.9.3-1.el10.x86_64.rpm
wget https://download.docker.com/linux/rhel/10/x86_64/stable/Packages/docker-compose-plugin-5.7.0-1.el10.x86_64.rpm




cd ./dep_data/docker_installer_fedora44
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/containerd.io-2.4.2-3.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-ce-29.9.3-1.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-ce-cli-29.9.3-1.fc44.x86_64.rpm
wget https://download.docker.com/linux/fedora/44/x86_64/stable/Packages/docker-compose-plugin-5.7.0-1.fc44.x86_64.rpm



# cd ./dep_data/docker_installer_suse
# wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/containerd.io-1.7.24-3.1.s390x.rpm
# wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-ce-27.4.1-1.s390x.rpm
# wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-ce-cli-27.4.1-1.s390x.rpm
# wget https://download.docker.com/linux/sles/15/s390x/stable/Packages/docker-compose-plugin-2.6.0-3.s390x.rpm



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
mkdir ../temp/
tar cJf - ./* | split -b 1900M - ../temp/offlineDeps.tar.xz.
mv ../temp/* ./toUpload
rmdir ../temp
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









<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->








## Create compressed file for create a repo in gitea

```bash
  R_D="/home/mario/mine/p/empty_t51"
# R_D="/home/mario/mine/p/t51"

S_D="app/back/source/" F_N="t51back.tar.xz"
S_D="app/front/source/" F_N="t51front.tar.xz"
S_D="app/db/source/" F_N="t51mig-db.tar.xz"
F_N="t51devops.tar.xz"



cd $R_D/$S_D
mkdir ../temp/
#Compress
tar --exclude='.git' --exclude='*/target' --exclude='.vscode' --exclude='t51devops.tar.xz' --exclude='README.backup.md' -cJf ../temp/$F_N .


# Check Uncompress
# Note: the files must not be inside a root folder, the root folder have the files
# for example
cd ../temp/
tar -tzf $F_N | grep ".env.example"
# adapter  common  pom-spring-boot.xml  pom.xml  product  README.md  t51back.tar.xz  user
```


