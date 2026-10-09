# Test in openSUSE

## Setup Virtual machine

### Setup user and ssh

```sh
useradd -m mario1

passwd mario1

transactional-update pkg install openssh firewalld

reboot

systemctl enable --now firewalld
systemctl enable --now sshd.service

firewall-cmd --zone=public --permanent --add-service=ssh
firewall-cmd --reload

```

### Setup Static IP


```sh
nmcli -t connection show | grep -i ethernet | cut -d":" -f4
# Or  nmcli device status

sudo nmcli con add type ethernet \
  con-name cable \
  ifname enp0s3 \
  ipv4.method manual \
  ipv4.addresses 192.168.1.8/24 \
  ipv4.gateway 192.168.1.254 \
  ipv4.dns "192.168.1.254 1.1.1.1" \
  ipv6.method disabled \
  connection.autoconnect yes
  
sudo nmcli connection up
```

## Pre T51