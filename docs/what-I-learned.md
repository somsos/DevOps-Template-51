# What I Learned

## TL:DR

- The image `nginxproxy/nginx-proxy:1.10-alpine` wa pretty useful while I was
  creating the setup, because in automatic maps the **sub-domains and ports**,
  I just needed to add 2 environment variables to the container I wanted to expose.
  But it has the limitation of exposing 

- When you create a `dockerfile` make sure you are creating and switching user,
  because by default use root and if create files this files belong to root and
  it's always a headache.

- When a folder does not exist in the container `docker run --rm -v ./not-exists:...`
  the folder `./not-exists` is created by the daemon (which runs as root).
  So thats why `./not-exists` will belong to `root`, the standard way to avoid
  this is by run a `mkdir` before running the Docker command, so the daemon does
  have to create the folder. and using either way `--user $(id -u):$(id -g)` or
  `user: "${UID}:${GID}"`.

- Make the secret management first, if you do it after you will have to test again.

- Keep the files host and volumes the same, because will need DinD, but if they
  are different you will have problems on syncing files.

- If you're using DinD avoid running containers mounting host volumes, either -v
  flag or `volume:` yaml property, It happened me that it was working fine and
  suddenly stopped working, and I had to do the same by building an image,
  because in that case the files are "copied" so there is no problem.

- Adding tags in **liquibase** is at the start not at the end, otherwise the
  rollback will delete also the tag, and that behavior is not useful, check
  the chapter `liquibase.md#${id:mvi48blw}` for details.

- The flag `--force-recreate` in `docker compose up` re-create the container not
  the image, because if we just stop the container and not remove it, the next
  time will preserve the previous state, but if we recreate the container it's
  going to start with a new state, more details in
  `docker_pitfalls#{id:6fn04mh87}`.

- Be careful with the the order of `ARG` and `FROM` in the dockerfile, when the
  arguments go from one stage to another stage, docker-compose.yml using `build.args`
  `docker_pitfalls#id{mcg385nvh502hrc}#`

- In docker we have 2 runtimes, build-time and run-time, and in both we have to
  declare what network use, *it happened me* that I set up with the builder
  container and a nexus container, with this error `Name has no usable address`
  because I could reach it on run-time but not in build-time, so I had to
  add in my docker-compose.yml this property: `services.back.build.network: myNet`
  so I could have access to this network on buildtime.

- To diagnose a nginx problem we can use `nginx -T | grep -A 30 "xxxx"`


- `docker_pitfalls#{id:m6v72xl67}` Docker build and internet BuildKit always
  tries to fetch the metadata/manifest of the base image, e.g. "alpine:1" so if
  we want to build **offline**` we need to **deactivate BuildKit**, e.g. this
  command `docker compose build <X>` will look in the claud but if the claud
     have a problem it will fail vs `DOCKER_BUILDKIT=0 docker compose build <X>`


- `/etc/group VS /etc/passwd` I had the wrong believe that `passwd` file had
  also the groups info, but no, it's divided in two files and the `group` file
  contains info about groups, e.g., `cat /etc/group | grep docker`.

- `official docker registry vs nexus vs static file server`: It's easier to use
  nexus, it has several uses, as a npm, mvn, docker-hosted and static-file-storage,
  so in this nexus service we can have several in just one.


## Error profiles and no such service

I had this error `no such service: nexus` while in my docker-compose I had both,
and both were up. THE PROBLEM was that they didn't share a profile, and that
meant they didn't see each other. 

```shell
docker ps -a --format "table {{.Names}}\t{{.Status}} | grep nexus
nexus                    Up

docker compose run --rm nexus_configurator
no such service: nexus
```

```yml
  nexus:
    profiles: ["devops", "all"] ...

  nexus_configurator:   # docker compose run --rm nexus_configurator
    profiles: ["utils"] ...
```

## Error docker registry and connection reset by peer

Description

```r
# By default Docker only allows HTTP for localhost, other ones just allow HTTPS
# in some configurations. Add localhost:8082 as an insecure registry
```

Error

```shell
docker login localhost:8082 -u tina1
# Error response from daemon: Get "http://localhost:8082/v2/": read tcp [::1]:47016->[::1]:8082: read: connection reset by peer

curl -v http://localhost:8082/v2/
#* Host localhost:8082 was resolved.
#* ...
#* Recv failure: Connection reset by peer
#curl: (56) Recv failure: Connection reset by peer
```

Solution

```shell
sudo nano /etc/docker/daemon.json
# EDIT
# {
#   "insecure-registries": ["localhost:8082"]
# }

# Apply changes by restarting docker
sudo systemctl restart docker
```
