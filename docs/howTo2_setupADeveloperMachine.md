# Offline install

- [Offline install](#offline-install)
  - [Clone repositories](#clone-repositories)
  - [Approve scrips](#approve-scrips)


## Clone repositories

I'm using ssh public-private keys as auth process, so we need to copy the
private key to the PC we want to clone from.

```shell
# the domain can be different in this case it's "gitea.yopi-test.com"
scp -r -P22 mario1@192.168.1.8:/p1/setup/secrets/ssh_key.priv ~/.ssh/yopi1.priv

cat >> ~/.ssh/config <<EOF

Host gitea.yopi-test.com
    HostName gitea.yopi-test.com
    Port 222
    User git
    IdentityFile ~/.ssh/yopi1.priv

EOF
```

We should be able to auth to the Gitea server

```shell
ssh -T git@gitea.yopi-test.com
# OUTPUT: Hi there, XXXXX You've successfully authenticated ...
```

Now we can clone the repositories

```shell
git clone ssh://git@gitea.yopi-test.com:222/yopi1/t51devops.git /home/mario/mine/yopi1

git clone ssh://git@gitea.yopi-test.com:222/yopi1/t51mig-db.git /home/mario/mine/yopi1/app/db/source

git clone ssh://git@gitea.yopi-test.com:222/yopi1/t51back.git /home/mario/mine/yopi1/app/back/source

git clone ssh://git@gitea.yopi-test.com:222/yopi1/t51front.git /home/mario/mine/yopi1/app/front/source
```

## Approve scrips

http://jenkins.yopi-test.com/manage/scriptApproval/

