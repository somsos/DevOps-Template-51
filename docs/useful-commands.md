# Useful Commands

- [Useful Commands](#useful-commands)
  - [TL;DR](#tldr)
  - [build base-db-utils:latest image](#build-base-db-utilslatest-image)
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
```


<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->


## build base-db-utils:latest image

```sh
test -f .env && source .env || echo ".env file not found" && \
test -z "$IMAGE_DB_MIG_BASE" && echo "ERROR, required var not found" || echo "$IMAGE_DB_MIG_BASE" && \
test -z "$BUILDX_BUILDER" && echo "ERROR, required var not found" || echo "$BUILDX_BUILDER" && \
test -z "$NETWORK_NAME" && echo "ERROR, required var not found" || echo "$NETWORK_NAME"

docker buildx build --build-arg IMAGE_DB_MIG_BASE=liquibase:5.0.1-alpine -f ./app/db/base_db_utils.dockerfile --load -t base_db_utils:latest ./app/db
docker compose --progress plain build --build-arg IMAGE_DB_MIG_BASE=$IMAGE_DB_MIG_BASE db_utils

docker run --rm --entrypoint sh db_utils:latest -c 'find / -iname "*postgresql*.jar" 2>/dev/null'
# OUTPUT expected
# /liquibase/lib/postgresql.jar

```



## Create a file to create a repo in gitea

```bash
R_D="/home/mario/mine/p/t51"

S_D="app/back/source/" F_N="t51back.tar.xz"
S_D="app/front/source/" F_N="t51front.tar.xz"
S_D="app/db/source/" F_N="t51mig-db.tar.xz"
F_N="t51devops.tar.xz"



cd $R_D/$S_D
mkdir ../temp/
#Compress
tar --exclude='.git' --exclude='*/target' --exclude='.vscode' -cJf ../temp/$F_N .


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
  docker container prune
  docker builder prune -af
  # CAUTION: his will make download again the images.
  docker image prune -af
  docker buildx prune -af
  docker buildx rm t51-builder

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


