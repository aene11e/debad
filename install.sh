#!bin/bash
clear
tput setaf 1 bold
echo "Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
tput setaf 2 bold && read -p "Telepites:[Y,n] " valasz  && tput sgr0
if [ $valasz = "Y" ]
then
  tput setaf 2 bold && read -p "Rendszerfrissites [ENTER] " && tput sgr0
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  tput setaf 2 bold && read -p "Telepites [ENTER] " && tput sgr0
  apt-get install -y tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades cabextract libmspack0  rkhunter ntp samba smbclient winbind krb5.config krb5.user
  wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb"
  dpkg -i ttf-mscorefonts-installer_3.6_all.deb 
  tput setaf 2 bold && read -p "Az alap Samba és Kerberos conf fájl törlése [ENTER] " && tput sgr0
  rm /etc/samba/smb.conf
  rm /etc/krb5.conf
  tput setaf 2 bold && read -p "Samba-tool Domain beállítások [ENTER] " && tput sgr0
  samba-tool domain provision --use-rfc2307 --realm=docnetic.net --domain=doc --server-role=dc --adminpass=S3cr3tvizsga!!
  cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
  systemctl stop smbd nmbd winbind
  systemctl disable smbd nmbd winbind
  systemctl unmask samba-ad-dc
  systemctl start samba-ad-dc
  systemctl enable samba-ad-dc
  chmod 750 /var/lib/ntp_signd
  samba-tool dns zonecreate 10.0.0.66 66.0.0.10.in-addr.arpa -U administrator 
else
  clear
  echo "--A program kilepett--"
fi
tput setaf 2 bold && read -p "Teszteles (NTP) [ENTER] " && tput sgr0
ntpq -p
ntpq -c rv
tput setaf 2 bold && read -p "Teszteles (SRV) [ENTER] " && tput sgr0
host -t A dc1.docnetic.net
host -t SRV_kerberos._udp.docnetic.net
host -t SRV_kerberos._ldap.docnetic.net
tput setaf 2 bold && read -p "Teszteles (AD/KERB) [ENTER] " && tput sgr0
smbclient -L localhost -U%
samba-tool domain level show
kinit administrator
klist
