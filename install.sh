#!bin/bash
clear
echo "Hello, ${whoami}. Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo "Telepites:[Y,n]
valasz=""
read valasz
if [$valasz -eq "Y"]
then
  echo "Rendszerfrissites [ENTER]"
  read -p
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  echo "Telepites [ENTER]"
  read -p
  apt-get install tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades update-notifier-common rkhunter ntp samba smbclient winbind krb5.config krb5.user -y
fi
rm /etc/samba/smb.conf
rm /etc/krb5.conf
