# How to setup a developer machine

- [How to setup a developer machine](#how-to-setup-a-developer-machine)
  - [Link domains (Optional)](#link-domains-optional)
  - [Approve Jenkins pipelines scrips](#approve-jenkins-pipelines-scrips)
  - [Clone repositories](#clone-repositories)

## Link domains (Optional)

In case of not having a public DNS, for example, we are making tests in a LAN
network or in localhost, we need to add our domain name to our `/etc/hosts`
file. for example.

```bash
MY_ENV=test
DEV_P_ROOT=/home/mario/mine/p/example1-$MY_ENV
HOST_USER=mario1
HOST_P_ROOT=/home/$HOST_USER/my-project
MY_USER=${MY_ENV}User
MY_DOMAIN=example1-${MY_ENV}.com
HOST_IP=192.168.43.8

sudo tee -a /etc/hosts <<EOF

$HOST_IP $MY_DOMAIN
$HOST_IP api.$MY_DOMAIN
$HOST_IP gitea.$MY_DOMAIN
$HOST_IP jenkins.$MY_DOMAIN
$HOST_IP registry.$MY_DOMAIN
$HOST_IP nexus.$MY_DOMAIN

EOF
```

## Approve Jenkins pipelines scrips

By default the Jenkins pipelines are not approved, we need to do it manually.

```shell
firefox -new-tab http://jenkins.$MY_DOMAIN/manage/scriptApproval/
```

## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# local: rm -fv ~/.ssh/${MY_USER}.priv &&  mv -v /home/mario/mine/p/t51/setup/secrets/ssh_key.priv ~/.ssh/${MY_USER}.priv
scp -r -P22 ${HOST_USER}@${MY_DOMAIN}:$HOST_P_ROOT/setup/secrets/ssh_key.priv ~/.ssh/${MY_USER}.priv

cat >> ~/.ssh/config <<EOF

Host gitea.${MY_DOMAIN}
    HostName gitea.${MY_DOMAIN}
    Port 222
    User git
    IdentityFile ~/.ssh/${MY_USER}.priv

EOF

# Now, We should be able to auth to the Gitea server

ssh -T git@gitea.$MY_DOMAIN

```


Now we can clone the repositories

```shell
git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51devops.git $DEV_P_ROOT

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51mig-db.git $DEV_P_ROOT/app/db/source

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51back.git $DEV_P_ROOT/app/back/source

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51front.git $DEV_P_ROOT/app/front/source

# local: mv /home/mario/mine/p/t51/.env $DEV_P_ROOT/.env
scp -r -P22 ${HOST_USER}@${MY_DOMAIN}:$HOST_P_ROOT/.env $DEV_P_ROOT/.env

# Checks

test -f $DEV_P_ROOT/.env && echo "OK" || echo "ERROR, file not found." && \
test -f $DEV_P_ROOT/app/back/source/pom.xml && echo "OK" || echo "ERROR, file not found." && \
test -f $DEV_P_ROOT/app/db/source/liquibase.properties && echo "OK" || echo "ERROR, file not found." && \
test -f $DEV_P_ROOT/app/front/source/package.json && echo "OK" || echo "ERROR, file not found."

```


