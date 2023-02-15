#!bin/bash
clear
echo "Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
read -p "Telepites:[Y,n] " valasz
if [ $valasz = "Y" ]
then
  read -p "Rendszerfrissites [ENTER] "
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  read -p "Telepites [ENTER] "
  apt-get install -y tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades cabextract libmspack0  rkhunter ntp samba smbclient winbind krb5.config krb5.user
  wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb"
  dpkg -i ttf-mscorefonts-installer_3.6_all.deb 
else
  clear
  echo "--A program kilepett--"
fi
read -p "Az alap Samba és Kerberos conf fájl törlése [ENTER] "
rm /etc/samba/smb.conf
rm /etc/krb5.conf
read -p "Samba-tool Domain beállítások [ENTER] "
samba-tool domain provision --use-rfc2307 --realm=docnetic.net --domain=dc1 --server-role=dc --adminpass=S3cr3tvizsga!!
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
systemctl stop smbd nmbd winbind
systemctl disable smbd nmbd winbind
systemctl unmask samba-ad-dc
systemctl start samba-ad-dc
systemctl enable samba-ad-dc
chmod 750 /var/lib/ntp_signd
samba-tool dns zonecreate 10.0.0.66 66.0.0.10.in-addr.arpa -U administrator 
