## Set an Static IP

setup-interfaces


## Install docker

[Source](https://wiki.alpinelinux.org/wiki/Docker?__goaway_challenge=cookie&__goaway_id=4549a6cce9273acd258a4ce06a26f2a1&__goaway_referer=https%3A%2F%2Fsearch.brave.com%2F)

apk add docker-cli-compose

setup-apkrepos -c

apk add shadow-subids

apk add docker

sudo addgroup $USER docker




## Install T51 dependencies

```sh
apk update
apk add --no-cache  curl bash ca-certificates sudo git netcat-openbsd tzdata

update-ca-certificates

adduser mario1 wheel
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel


sudo ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
echo "America/Mexico_City" | sudo tee /etc/timezone

# Check
ls /etc/localtime && cat /etc/timezone
# Expected
#   /etc/localtime
#   America/Mexico_City
```