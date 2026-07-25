# How to setup a developer machine

- [How to setup a developer machine](#how-to-setup-a-developer-machine)
  - [Link domains (Optional)](#link-domains-optional)
  - [Approve Jenkins pipelines scrips](#approve-jenkins-pipelines-scrips)
  - [Clone repositories](#clone-repositories)

## Link domains (Optional)

In case of not having a public DNS, for example, we are making tests in a LAN
network or in localhost, we need to add our domain name to our `/etc/hosts`
file. for example.

```yml
MY_DOMAIN=example1-qa.com
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
http://jenkins.$MY_DOMAIN/manage/scriptApproval/
```

## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# The user you use to auth to the host
HOST_USER=mario1
# The user you inserted in the install.sh script
MY_USER=myUser
# The domain you inserted in the install.sh script and goes to your server
MY_DOMAIN=example1-qa.com
scp -r -P22 ${HOST_USER}@${MY_DOMAIN}:~/my-project/setup/secrets/ssh_key.priv ~/.ssh/${MY_USER}.priv

cat >> ~/.ssh/config <<EOF

Host gitea.${MY_DOMAIN}
    HostName gitea.${MY_DOMAIN}
    Port 222
    User git
    IdentityFile ~/.ssh/${MY_USER}.priv

EOF
```

We should be able to auth to the Gitea server

```shell
MY_DOMAIN=example1-qa.com
ssh -T git@gitea.$MY_DOMAIN
# OUTPUT: Hi there, $MY_DOMAIN You've successfully authenticated ...
```

Now we can clone the repositories

```shell
# The user you inserted in the install.sh script
MY_USER=myUser
# The domain you inserted in the install.sh script and goes to your server
MY_DOMAIN=example1-qa.com

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51devops.git ~/my-project/

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51mig-db.git ~/my-project/app/db/source

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51back.git ~/my-project/app/back/source

git clone ssh://git@gitea.${MY_DOMAIN}:222/${MY_USER}/t51front.git ~/my-project/app/front/source
```
