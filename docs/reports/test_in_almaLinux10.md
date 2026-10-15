

I created a Virtual machine in VirtualBox with a hard disk of 21GB, because I created one with


Check required free space, it must have 15GB free, get sure in the "Requirements"
sections in the documentation. 

```code
df -h

```


Set static IP

```sh
# Check interface
nmcli con show
# Set values
sudo nmcli con mod enp0s3 ipv4.addresses 192.168.1.8/24
sudo nmcli con mod enp0s3 ipv4.gateway 192.168.1.254
sudo nmcli con mod enp0s3 ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli con mod enp0s3 ipv4.method manual
# apply changes
sudo nmcli con up enp0s3

curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"
```

Install docker, [source](https://reintech.io/blog/installing-docker-on-almalinux-9)

Prepare to install a docker

```sh
sudo dnf update -y

sudo dnf install -y kernel-modules-extra dnf-plugins-core tar

reboot
```

Docker installation Offline
```bash

```



Docker installation Online

```bash
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

sudo systemctl start docker

sudo systemctl status docker

docker --version
```

Set rootless

```bash
sudo usermod -aG docker $USER

newgrp docker

sudo docker run --rm --name temp-hello-world hello-world
```

Install T51 dependencies


```bash
sudo dnf install -y git nc

sudo timedatectl set-timezone America/Mexico_City

timedatectl show --property=Timezone --value | sudo tee /etc/timezone

# Check
ls /etc/localtime && cat /etc/timezone
# Expected
#   /etc/localtime
#   America/Mexico_City

```




## Optionals

Change the hostname, in my case by default gives me a long and ugly one by default.

```shell
# Optional 
sudo hostnamectl set-hostname <NEW>
# Replace in  the old name with the new one
sudo nano /etc/hosts
# Check
hostname
```


Configure Docker Daemon Options
```sh
sudo mkdir -p /etc/docker
cp /etc/docker/daemon.json

sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF


sudo systemctl restart docker
```