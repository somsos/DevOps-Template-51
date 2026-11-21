


The same as AlmaLinux10

Set static IP

```sh
# Check interface
nmcli con show

# WiFi
sudo nmcli con mod "Wired connection 1" ipv4.addresses 192.168.1.8/24
sudo nmcli con mod "Wired connection 1" ipv4.gateway 192.168.1.254

# CellPedorrro
sudo nmcli con mod "Wired connection 1" ipv4.addresses 192.168.43.8/24
sudo nmcli con mod "Wired connection 1" ipv4.gateway 192.168.43.254


sudo nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli con mod "Wired connection 1" ipv4.method manual
# apply changes
sudo nmcli con up "Wired connection 1"

curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"
```


Install required packages

```sh
# Create offline packages
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
mkdir -p ./rpms
sudo dnf download --resolve --alldeps --destdir /rpms docker-ce docker-ce-cli containerd.io docker-compose-plugin


# Use offline packages
sudo dnf install -y --disablerepo='*' ~/docker-offline/*.rpm
```


Others

```sh
sudo dnf remove -y docker-buildx-plugin
```