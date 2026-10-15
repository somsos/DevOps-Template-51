# Useful Commands

- [Useful Commands](#useful-commands)
  - [TL;DR](#tldr)
  - [HOw to create the code.tar.xz file to upload to the repository](#how-to-create-the-codetarxz-file-to-upload-to-the-repository)
  - [Create a file to create a repo in gitea](#create-a-file-to-create-a-repo-in-gitea)
- [How to uninstall](#how-to-uninstall)


## TL;DR

```shell
# each time the machine starts
sudo systemctl start containerd.service docker.socket docker.service docker
sudo systemctl stop docker containerd.service docker.socket docker.service

docker compose --env-file ./.env -f ./setup/docker-compose-devops.yml config jenkins

docker run hello-world

# To avoid docker starts automatically at the start
sudo systemctl disable docker.service containerd.service docker.socket docker




$ docker run -ti --rm -v ./this-does-not-exists:/tmp/something nginx:stable-alpine3.23 touch /tmp/something/myFile.txt
$ ls -la this-does-not-exists/
drwxr-xr-x  2 root  root  4096 Jun  2 11:18 .
-rw-r--r--  1 root  root     0 Jun  2 11:18 myFile.txt


docker run --rm \
  --user $(id -u):$(id -g) \
  -v ./test-3:/tmp/something \
  nginx:stable-alpine3.23 \
  touch /tmp/something/myFile.txt


#build base-db-utils:latest image
cd ~/mine/t51/app/db
docker build -f base-db-utils.dockerfile -t base_db_utils:latest --build-arg IMAGE_DB_MIG_BASE=liquibase:4.33-alpine .
cd ~/mine/t51/dep_data
docker save --output ./IMAGE_BASE_DB_UTILS.tar base_db_utils:latest

```


<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->


## HOw to create the code.tar.xz file to upload to the repository

```bash
T51_SOURCE_FILES="/home/mario/mine/p/empty_t51"
T51_TAR="code.tar.xz"

cd $T51_SOURCE_FILES
git pull origin main

mkdir ../temp/
rm -v ../temp/$T51_TAR
test -f .env.example && echo "OK" || echo "SOMETHING IS WRONG"
tar -cJf ../temp/$T51_TAR .


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


## Create a file to create a repo in gitea

```bash
R_D="/home/mario/mine/p/t51"

S_D="app/back/source/"
S_D="app/front/source/"
S_D="app/db/source/"

F_N="t51front.tar.xz"
F_N="t51mig-db.tar.xz"
F_N="t51devops.tar.xz"
F_N="t51back.tar.xz"


cd $R_D/$S_D
mkdir ../temp/
#Compress
tar --exclude='.git' --exclude='*/target' -cJf ../temp/$F_N .


# Check Uncompress
# Note: the files must not be inside a root folder, the root folder have the files
# for example
cd ../temp/
tar -xJf $F_N -C .
ls
# adapter  common  pom-spring-boot.xml  pom.xml  product  README.md  t51back.tar.xz  user
```

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

# How to uninstall

```shell
docker compose --profile all down

docker volume rm t51_t51DB_vol1

T51_ROOT="/home/mario/mine/p/t51/"

cd $T51_ROOT

rm -fv ./.env

rm -rfv setup/secrets/registry.password setup/secrets/ssh_key.priv setup/secrets/ssh_key.pub setup/gitea/vol-config-dir/app.ini

sudo rm -rfv setup/jenkins/vol-jenkins_home/ && git restore setup/jenkins/vol-jenkins_home
rm -rfv setup/gitea/vol-data && git restore setup/gitea/vol-data
rm -rfv setup/nexus/vol-data && git restore setup/nexus/vol-data/0vol-data.md

# delete the added host
sudo nano ~/.ssh/config
sudo nano ~/.ssh/known_hosts
sudo nano /etc/hosts





# In case of having these errors:
#   - "Error response from daemon: RWLayer of container ... is unexpectedly nill"
#   - ""
docker container prune
docker builder prune -af
docker images -f dangling=true -q | xargs docker rmi
# CAUTION: his will make download again the images.
docker image prune -af
# Description: Running "docker compose up ..." gives this error.
# Most probable causes
#   - docker metadata corruption
#   - interrupted container creation
#   - a container references an invalid image layer
#   - Incompatible Docker version state

# 
docker buildx prune -af
docker buildx ls
```


