#!bin/bash
clear
echo "Hello, ${whoami}. Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
read -p "Telepites:[Y,n]" valasz
if [ $valasz = "Y" ]
then
  read -p "Rendszerfrissites [ENTER]"
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  read -p "Telepites [ENTER]"
  apt-get install -y tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades apt-get install cabextract libmspack0  rkhunter ntp samba smbclient winbind krb5.config krb5.user
  wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb"
  dpkg -i ttf-mscorefonts-installer_3.6_all.deb 
fi
rm /etc/samba/smb.conf
rm /etc/krb5.conf
