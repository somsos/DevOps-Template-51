# Test in Debian

- [Test in Debian](#test-in-debian)
  - [Install Network and t51 dependencies](#install-network-and-t51-dependencies)
  - [Useful commands](#useful-commands)
  - [Setup network](#setup-network)



Install dependencies 
```sh
sudo apt update
sudo apt install ca-certificates curl network-manager git netcat-openbsd curl iptables
```


Setup network
```sh
test -f /etc/netplan/50-cloud-init.yaml && echo "OK" || echo "File not found"
sudo cp -v /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.backup

MY_NET=43 # Cell Pedorro
MY_NET=1  # Good one
sudo tee /etc/netplan/50-cloud-init.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [192.168.$MY_NET.8/24]
      routes:
        - to: default
          via: 192.168.$MY_NET.254
      nameservers:
        addresses: [192.168.$MY_NET.254, 1.1.1.1]
EOF

sudo less /etc/netplan/50-cloud-init.yaml

# Cell pedorro

# Checks
sudo netplan try      # reverts automatically if you lose connectivity
ip -br a
ip route
resolvectl status enp0s3


curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"
```




Others
```sh
systemctl reboot
systemctl poweroff
```










































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
# 43
# Check interface
nmcli con show

# Cable
sudo nmcli con mod cable ipv4.addresses 192.168.1.8/24
sudo nmcli con mod cable ipv4.gateway 192.168.1.254

# CellPedorro
sudo nmcli con mod cable ipv4.addresses 192.168.43.8/24
sudo nmcli con mod cable ipv4.gateway 192.168.43.1

#common
sudo nmcli con mod cable ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli con mod cable ipv4.method manual


# apply changes
sudo nmcli con up cable


curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"



# Other way to setup the network
# cp /etc/network/interfaces /etc/network/interfaces.backup
# 
# nano /etc/network/interfaces
# # CHANGE
# auto lo
# iface lo inet loopback
# 
# # REMOVE OR DELETE
# allow-hotplug cable
# iface cable inet dhcp
# iface cable inet6 auto
# 
# nano /etc/NetworkManager/NetworkManager.conf
# # CHANGE
# managed=false
# # TO
# managed=true
# 
# systemctl restart NetworkManager
# 
# # Set static IP
# nmcli device status
# ip -br link

```




























