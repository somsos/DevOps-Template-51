# Test in Debian

- [Test in Debian](#test-in-debian)
  - [Install Network and t51 dependencies](#install-network-and-t51-dependencies)
  - [Useful commands](#useful-commands)
  - [Setup network](#setup-network)



## Install Network and t51 dependencies

```sh
apt install network-manager git netcat-openbsd curl iptables sudo

usermod -aG sudo mario1 # re-start the session to see the change applied

sudo timedatectl set-timezone America/Mexico_City

timedatectl show --property=Timezone --value | sudo tee /etc/timezone


```

<!-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Below commands wew used for setup the VirtualBox Debian machine
-->



## Useful commands

```sh
# Turn off the machine
systemctl reboot
systemctl poweroff

## Setup repositories
tee /etc/apt/sources.list.d/debian.sources > /dev/null <<'EOF'
Types: deb
URIs: https://deb.debian.org/debian
Suites: trixie trixie-updates
Components: main non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF


# Update system
apt update
```



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



## Setup network

```sh
# Set a network interface
cp /etc/network/interfaces /etc/network/interfaces.backup

nano /etc/network/interfaces
# CHANGE
auto lo
iface lo inet loopback

# REMOVE OR DELETE
allow-hotplug enp0s3
iface enp0s3 inet dhcp
iface enp0s3 inet6 auto

nano /etc/NetworkManager/NetworkManager.conf
# CHANGE
managed=false
# TO
managed=true

systemctl restart NetworkManager

# Set static IP
nmcli device status
ip -br link


nmcli con add type ethernet \
  con-name cable \
  ifname enp0s3 \
  ipv4.method manual \
  ipv4.addresses 192.168.1.8/24 \
  ipv4.gateway 192.168.1.254 \
  ipv4.dns "192.168.1.254 1.1.1.1" \
  ipv6.method disabled \
  connection.autoconnect yes

nmcli con up cable


# In case of mistake
#     nmcli connection delete cable

nmcli con show
nmcli con up cable

curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"
```




























