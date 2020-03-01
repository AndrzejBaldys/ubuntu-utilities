#!/bin/bash
# $1 hostname
# $2 domain

OLD_FQDN=$(hostname -f)
OLD_DN=$(hostname -d)

echo $1 > hostname.txt
sudo mv hostname.txt /etc/hostname
sudo hostname $(cat /etc/hostname)

if grep -Fq 'domain' /etc/resolvconf/resolv.conf.d/head
then
    sudo sed -i -e "s/$OLD_DN/$2/" /etc/resolvconf/resolv.conf.d/head
else
    echo domain $2 | sudo tee -a /etc/resolvconf/resolv.conf.d/head > /dev/null
fi
sudo resolvconf -u

sudo sed -i -e "s/$OLD_FQDN/$1.$2/" /etc/hosts

sudo reboot -f
