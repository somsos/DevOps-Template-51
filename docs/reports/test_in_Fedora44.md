


The same as AlmaLinux10

Set static IP

```sh
# Check interface
nmcli con show
# Set values
sudo nmcli con mod "Wired connection 1" ipv4.addresses 192.168.1.8/24
sudo nmcli con mod "Wired connection 1" ipv4.gateway 192.168.1.254
sudo nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli con mod "Wired connection 1" ipv4.method manual
# apply changes
sudo nmcli con up "Wired connection 1"

curl -sSf -m 3 -I https://www.google.com >/dev/null 2>&1 && echo "There's internet" || echo "NO INTERNET"
```