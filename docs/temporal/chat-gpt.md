# chat-gpt

Do you see why the TRIGGERING_REPO variable is not getting set by generic-webhook-trigger plugin?

Plugin conf

Post content parameters:
    Variable: TRIGGERING_REPO
    Expression: $.repository.name
    type: JSONPath, XPath (both don't set it)

Request

```bash

curl -i -X POST \
    --data '{"repository": { "name": "Hi-There" }}' \
    http://localhost:3001/generic-webhook-trigger/invoke?token=71c27113071788c2f7874f58a584d1138a003693

Response
{
   "jobs" : {
      "template51" : {
         "id" : 20,
         "regexpFilterExpression" : "",
         "regexpFilterText" : "",
         "resolvedVariables" : {
            "TRIGGERING_REPO" : ""
         },
         "triggered" : true,
         "url" : "queue/item/20/"
      }
   },
   "message" : "Triggered jobs."
}
```

Build Steps: Execute shell

```bash
#!/bin/bash
set -e

# Request (testing this variable is created by "Generic Webhook Trigger plugin"
# when gets the webhook request)
# TRIGGERING_REPO='template51-frontend'


# This scripts run in jenkins, the rea

# Declarations

BRANCH="main"   # CAUTION: Keep sync with .env file

DATE="$(date +"%Y-%m-%d_%H.%M.%S")"

DEVOPS_DIR="devops_$DATE"

DEVOPS_REPO="ssh://git@host.docker.internal:222/user1/template51_devops.git"



# Executions

## Validation
: "${TRIGGERING_REPO:?Variable TRIGGERING_REPO is not set}"
if [[ "$TRIGGERING_REPO" != "template51-backend" && "$TRIGGERING_REPO" != "template51-frontend" ]]; then
  echo "TRIGGERING_REPO variable expected to be template51-frontend template51-backend, it was '$TRIGGERING_REPO'"
  exit 1
fi





## Logic

echo "ENVIRONMENT: $BRANCH"

eval "$(ssh-agent -s)"

git clone  --depth=1 --single-branch --branch $BRANCH $DEVOPS_REPO $DEVOPS_DIR

cd $DEVOPS_DIR

bash ./JenkinsScript-build-and-deploy.sh $TRIGGERING_REPO
```

Behave: the job is triggered but the variable is not set


## Multiple docker-compose with shared dependencies

We can use multiple docker-compose files with the
following command.

```shell
docker compose \
  -f docker-compose-base.yml \
  -f docker-compose-app.yml \
  -f docker-compose-devops.yml \
  ...
```

This is useful to share network and other

But I already have this structure

project
   docker-compose-devops.yml
   app
      db
      back
      front
      docker-compose-app.yml
   devops
      jenkins
      gitea
      reverse-proxy
      secrets
      docker-compose-devops.yml

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

----

<!--

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

-->

## How to test nexus_configuration from zero

docker compose down nexus

rm -rf ./setup/nexus/vol-data && mkdir -p ./setup/nexus/vol-data

tar -xf ./setup/nexus/nexus-pre-initialized.tar.xz -C ./setup/nexus/vol-data

docker compose up -d --wait nexus

docker compose run -ti --entrypoint sh --rm nexus_configurator

container> sh /nexus-entrypoint.sh

container> less /tmp/docker_hosted_creation.log


## How to test the nexus static file upload with credentials and anonymous download

```shell
# Upload without credentials
curl -i -X PUT --upload-file workspace/0_static/badge_success.svg http://nexus.tina-qa.com:8081/repository/public-files/images/test.svg

# Upload with credentials (green image)
curl -i -u "tina1:tina123p" -X PUT --upload-file workspace/0_static/badge_success.svg http://nexus.tina-qa.com:8081/repository/public-files/images/test.svg

# Upload with credentials (red image)
curl -i -u "tina1:tina123p" -X PUT --upload-file workspace/0_static/badge_failing.svg http://nexus.tina-qa.com:8081/repository/public-files/images/test.svg

# Download image
curl -i http://nexus.tina-qa.com:8081/repository/public-files/images/test.svg

```


## How to test the nexus docker registry

```shell
docker login tina-qa.com:5000 -u tina1
docker tag SOME_IMAGE:TAG tina-qa.com:8082/SOME_-_IMAGE:TAG
docker push tina-qa.com:8082/SOME_-_IMAGE:TAG
```






## nginx-reverse-proxy: Multiple sub-domains for one container

Reading the documentation, it seems that this image does not support the feature of multiple ports for just one container, and even if it could, I prefer not to use the automatic configuration anymore; I think a static configuration would be better for fewer bad surprises and future more complex features like observability and notifications.

Could you help me to replace my automatic-reverse-proxy (nginxproxy/nginx-proxy:1 10-alpine) for a plain Nginx container with a static configuration? First refactor, and then add this feature of redirecting 2 different subdomains to the same container.

Questions
- in `conf.d/default.conf` Can I separate it in things more like to not require
  much maintaining, like the map and proxy_set_header commands, and those that might
  require more attention as the upstream and server commands

IMPORTANT consideration: the domain tina-qa.com it's just a test
domain, it must be taken from .env file, so I think the configuration must be
generated on the `install.sh` script or use a wildcard.

I see this info.

Services that I want the same behavior, 
- http://gitea.tina-qa.com
- http://jenkins.tina-qa.com
- http://nexus.tina-qa.com
- http://api.tina-qa.com
- http://tina-qa.com":

`nginx:1.31.2-alpine3.23` I would like to use a specific image version, to avoid
unexpected automatic upgrades

I see this auto-generated configuration in `setup/reverse-proxy/conf.d/default.conf`

```yml
# nginx-proxy version : 1.10.2
# Networks available to the container labeled "com.github.nginx-proxy.nginx-proxy.nginx" or the one running docker-gen
# (which are assumed to match the networks available to the container running nginx):
#     t51Net
map $proxy_add_x_forwarded_for $proxy_x_forwarded_for {
    default $proxy_add_x_forwarded_for;
    '' $remote_addr;
}
# If we receive X-Forwarded-Proto, pass it through; otherwise, pass along the
# scheme used to connect to this server
map $http_x_forwarded_proto $proxy_x_forwarded_proto {
    default $http_x_forwarded_proto;
    '' $scheme;
}
map $http_x_forwarded_host $proxy_x_forwarded_host {
    default $http_x_forwarded_host;
    '' $host;
}
# If we receive X-Forwarded-Port, pass it through; otherwise, pass along the
# server port the client connected to
map $http_x_forwarded_port $_proxy_x_forwarded_port {
    default $http_x_forwarded_port;
}
map $_proxy_x_forwarded_port $proxy_x_forwarded_port {
    default $_proxy_x_forwarded_port;
    '' $server_port;
}
# Include the port in the Host header sent to the container if it is non-standard
map $server_port $host_port {
    default :$server_port;
    80 '';
    443 '';
}
# If the request from the downstream client has an "Upgrade:" header (set to any
# non-empty value), pass "Connection: upgrade" to the upstream (backend) server.
# Otherwise, the value for the "Connection" header depends on whether the user
# has enabled keepalive to the upstream server.
map $http_upgrade $proxy_connection {
    default upgrade;
    '' $proxy_connection_noupgrade;
}
map $upstream_keepalive $proxy_connection_noupgrade {
    # Preserve nginx's default behavior (send "Connection: close").
    default close;
    # Use an empty string to cancel nginx's default behavior.
    true '';
}
# Abuse the map directive (see <https://stackoverflow.com/q/14433309>) to ensure
# that $upstream_keepalive is always defined.  This is necessary because:
#   - The $proxy_connection variable is indirectly derived from
#     $upstream_keepalive, so $upstream_keepalive must be defined whenever
#     $proxy_connection is resolved.
#   - The $proxy_connection variable is used in a proxy_set_header directive in
#     the http block, so it is always fully resolved for every request -- even
#     those where proxy_pass is not used (e.g., unknown virtual host).
map "" $upstream_keepalive {
    # The value here should not matter because it should always be overridden in
    # a location block (see the "location" template) for all requests where the
    # value actually matters.
    default false;
}
# Apply fix for very long server names
server_names_hash_bucket_size 128;
# Default dhparam
ssl_dhparam /etc/nginx/dhparam/dhparam.pem;
# Set appropriate X-Forwarded-Ssl header based on $proxy_x_forwarded_proto
map $proxy_x_forwarded_proto $proxy_x_forwarded_ssl {
    default off;
    https on;
}
gzip_types text/plain text/css application/javascript application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
log_format vhost escape=default '$host $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$upstream_addr"';
access_log off;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305';
    ssl_prefer_server_ciphers off;
error_log /dev/stderr;
resolver 127.0.0.11;
# HTTP 1.1 support
proxy_http_version 1.1;
proxy_set_header Host $host$host_port;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_x_forwarded_for;
proxy_set_header X-Forwarded-Host $proxy_x_forwarded_host;
proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
proxy_set_header X-Forwarded-Ssl $proxy_x_forwarded_ssl;
proxy_set_header X-Forwarded-Port $proxy_x_forwarded_port;
proxy_set_header X-Original-URI $request_uri;
# Mitigate httpoxy attack (see README for details)
proxy_set_header Proxy "";
server {
    server_name _; # This is just an invalid value which will never trigger on a real hostname.
    server_tokens off;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    listen 443 ssl;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;
    # No default certificate found, so reject SSL handshake;
    ssl_reject_handshake on;
    location ^~ / {
        return 503;
    }
}
# api.tina-qa.com/
upstream api.tina-qa.com {
    # Container: t51back
    #     networks:
    #         t51Net (reachable)
    #     IPv4 address: 172.30.0.102
    #     IPv6 address: (none usable)
    #     exposed ports (first ten): 8080/tcp
    #     default port: 8080
    #     using port: 8080
    server 172.30.0.102:8080;
    keepalive 2;
}
server {
    server_name api.tina-qa.com;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    location /.well-known/acme-challenge/ {
        auth_basic off;
        auth_request off;
        allow all;
        root /usr/share/nginx/html;
        try_files $uri =404;
        break;
    }
    listen 443 ssl;
    # No certificate for this vhost nor default certificate found, so reject SSL handshake.
    ssl_reject_handshake on;
    location / {
        proxy_pass http://api.tina-qa.com;
        set $upstream_keepalive true;
    }
}
# gitea.tina-qa.com/
upstream gitea.tina-qa.com {
    # Container: gitea
    #     networks:
    #         t51Net (reachable)
    #     IPv4 address: 172.30.0.201
    #     IPv6 address: (none usable)
    #     exposed ports (first ten): 2222/tcp 3000/tcp
    #     default port: 80
    #     using port: 3000
    server 172.30.0.201:3000;
    keepalive 2;
}
server {
    server_name gitea.tina-qa.com;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    location /.well-known/acme-challenge/ {
        auth_basic off;
        auth_request off;
        allow all;
        root /usr/share/nginx/html;
        try_files $uri =404;
        break;
    }
    listen 443 ssl;
    # No certificate for this vhost nor default certificate found, so reject SSL handshake.
    ssl_reject_handshake on;
    location / {
        proxy_pass http://gitea.tina-qa.com;
        set $upstream_keepalive true;
    }
}
# jenkins.tina-qa.com/
upstream jenkins.tina-qa.com {
    # Container: jenkins
    #     networks:
    #         t51Net (reachable)
    #     IPv4 address: 172.30.0.202
    #     IPv6 address: (none usable)
    #     exposed ports (first ten): 8080/tcp 50000/tcp
    #     default port: 80
    #     using port: 8080
    server 172.30.0.202:8080;
    keepalive 2;
}
server {
    server_name jenkins.tina-qa.com;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    location /.well-known/acme-challenge/ {
        auth_basic off;
        auth_request off;
        allow all;
        root /usr/share/nginx/html;
        try_files $uri =404;
        break;
    }
    listen 443 ssl;
    # No certificate for this vhost nor default certificate found, so reject SSL handshake.
    ssl_reject_handshake on;
    location / {
        proxy_pass http://jenkins.tina-qa.com;
        set $upstream_keepalive true;
    }
}
# nexus.tina-qa.com/
upstream nexus.tina-qa.com {
    # Container: nexus
    #     networks:
    #         t51Net (reachable)
    #     IPv4 address: 172.30.0.215
    #     IPv6 address: (none usable)
    #     exposed ports (first ten): 5000/tcp 8081/tcp
    #     default port: 80
    #     using port: 8081
    server 172.30.0.215:8081;
    keepalive 2;
}
server {
    server_name nexus.tina-qa.com;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    location /.well-known/acme-challenge/ {
        auth_basic off;
        auth_request off;
        allow all;
        root /usr/share/nginx/html;
        try_files $uri =404;
        break;
    }
    listen 443 ssl;
    # No certificate for this vhost nor default certificate found, so reject SSL handshake.
    ssl_reject_handshake on;
    location / {
        proxy_pass http://nexus.tina-qa.com;
        set $upstream_keepalive true;
    }
}
# tina-qa.com/
upstream tina-qa.com {
    # Container: t51front
    #     networks:
    #         t51Net (reachable)
    #     IPv4 address: 172.30.0.103
    #     IPv6 address: (none usable)
    #     exposed ports (first ten): 80/tcp
    #     default port: 80
    #     using port: 80
    server 172.30.0.103:80;
    keepalive 2;
}
server {
    server_name tina-qa.com;
    access_log /var/log/nginx/access.log vhost;
    http2 on;
    listen 80;
    location /.well-known/acme-challenge/ {
        auth_basic off;
        auth_request off;
        allow all;
        root /usr/share/nginx/html;
        try_files $uri =404;
        break;
    }
    listen 443 ssl;
    # No certificate for this vhost nor default certificate found, so reject SSL handshake.
    ssl_reject_handshake on;
    location / {
        proxy_pass http://tina-qa.com;
        set $upstream_keepalive true;
    }
}

```

## Create compressed file split in chunks

```shell
# Create compressed files
tar czf - /home/mario/mine/t51/dep_data | split -b 2000M - /home/mario/mine/t51/dep_data/dep_data.tar.gz

# Uncompress compressed files
cat /path/to/output/prefix.tar.gz.* | tar xzf /p1/dep_data/dep_data.tar.xz -C /p1
```


