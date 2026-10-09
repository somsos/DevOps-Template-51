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
# the root path folder project in the developer machine
DEV_P_ROOT=/home/mario/mine/p/example1-test
# the root path folder project in the host
HOST_P_ROOT=/home/mario1/my-project
# The user you use to auth to the host
HOST_USER=mario1
# The user you inserted in the install.sh script
MY_USER=myTestUser
# The domain you inserted in the install.sh script and goes to your server
MY_DOMAIN=example1-test.com
# Temp: 10.222.58.8, 192.168.1.8
HOST_IP=192.168.50.8

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

cd $DEV_P_ROOT

scp -r -P22 ${HOST_USER}@${MY_DOMAIN}:$HOST_P_ROOT/.env $DEV_P_ROOT/.env

# Checks

test -f $DEV_P_ROOT/.env && echo "OK" || echo "ERROR, file not found."

test -f $DEV_P_ROOT/app/back/source/pom.xml && echo "OK" || echo "ERROR, file not found."

test -f $DEV_P_ROOT/app/db/source/liquibase.properties && echo "OK" || echo "ERROR, file not found."

test -f $DEV_P_ROOT/app/front/source/package.json && echo "OK" || echo "ERROR, file not found."


```


