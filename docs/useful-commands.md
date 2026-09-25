# Useful Commands

- [Useful Commands](#useful-commands)
  - [TL;DR](#tldr)
  - [Create a file to create a repo in gitea](#create-a-file-to-create-a-repo-in-gitea)


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
