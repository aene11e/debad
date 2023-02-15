#!bin/bash
clear
echo "Hello, ${whoami}. Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
echo "Telepites:[Y,n]"
valasz=""
read valasz
if [$valasz -eq "Y"]
then
  read -p "Rendszerfrissites [ENTER]"
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  read -p "Telepites [ENTER]"
  apt-get install tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades update-notifier-common rkhunter ntp samba smbclient winbind krb5.config krb5.user -y
fi
rm /etc/samba/smb.conf
rm /etc/krb5.conf
