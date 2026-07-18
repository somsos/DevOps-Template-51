# How to setup a developer machine

- [How to setup a developer machine](#how-to-setup-a-developer-machine)
  - [Link domains (Optional)](#link-domains-optional)
  - [Clone repositories](#clone-repositories)

## Link domains (Optional)

In case of not having a public DNS, for example, we are making tests in a LAN
network or in localhost, we need to add our domain name to our `/etc/hosts`
file. for example.

```yml
192.168.1.8 example1-test.com
192.168.1.8 api.example1-test.com
192.168.1.8 gitea.example1-test.com
192.168.1.8 jenkins.example1-test.com
192.168.1.8 registry.example1-test.com
192.168.1.8 nexus.example1-test.com
```

## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# the domain can be different in this case it's "gitea.example1-test.com"
scp -r -P22 user1@example1-test.com:/my-project/setup/secrets/ssh_key.priv ~/.ssh/user1.priv

cat >> ~/.ssh/config <<EOF

Host gitea.example1-test.com
    HostName gitea.example1-test.com
    Port 222
    User git
    IdentityFile ~/.ssh/user1.priv

EOF
```

We should be able to auth to the Gitea server

```shell
ssh -T git@gitea.example1-test.com
# OUTPUT: Hi there, XXXXX You've successfully authenticated ...
```

Now we can clone the repositories

```shell
git clone ssh://git@gitea.example1-test.com:222/user1/t51devops.git ~/my-project/

git clone ssh://git@gitea.example1-test.com:222/user1/t51mig-db.git ~/my-project/app/db/source

git clone ssh://git@gitea.example1-test.com:222/user1/t51back.git ~/my-project/app/back/source

git clone ssh://git@gitea.example1-test.com:222/user1/t51front.git ~/my-project/app/front/source
```
