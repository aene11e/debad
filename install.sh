#!bin/bash
clear
tput setaf 1 bold
echo "Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
echo "[ver.: Debian 11.6.0]"
tput bold setaf 2 && read -p "Telepites:[Y,n] " valasz  && tput sgr0
if [ $valasz = "Y" ]
then
  tput bold setaf 2 && read -p "Rendszerfrissites [ENTER] " && tput sgr0
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  tput bold setaf 2 && read -p "Telepites [ENTER] " && tput sgr0
  apt-get install -y tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades cabextract libmspack0  rkhunter ntp samba smbclient winbind krb5-config krb5-user dnsutils
  wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb"
  dpkg -i ttf-mscorefonts-installer_3.6_all.deb 
  tput bold setaf 2 && read -p "Az alap Samba es Kerberos conf fajl torlese [ENTER] " && tput sgr0
  rm -v /etc/samba/smb.conf
  rm -v /etc/krb5.conf
  tput bold setaf 2 && read -p "Samba-tool Domain beallitasok [ENTER] " && tput sgr0
  samba-tool domain provision --use-rfc2307 --interactive
  cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
  systemctl stop smbd nmbd winbind
  systemctl disable smbd nmbd winbind
  systemctl unmask samba-ad-dc
  systemctl start samba-ad-dc
  systemctl enable samba-ad-dc
  chmod 750 /var/lib/ntp_signd
  tput bold setaf 2 && read -p "Reverse Zone letrehozasa [ENTER] " && tput sgr0
  samba-tool dns zonecreate 10.0.0.66 66.0.0.10.in-addr.arpa -U administrator
  tput bold setaf 1 echo "kdc = mydc.mydomain.com:88 KDC server megjelolese krb5.confban!"
  ufw allow 53 88 80 443 
else
  clear
  echo "--A program kilepett--"
fi
tput bold setaf 2 && read -p "Teszteles (NTP) [ENTER] " && tput sgr0
ntpq -p
ntpq -c rv
tput bold setaf 2 && read -p "Teszteles (SRV) [ENTER] " && tput sgr0
host -t A dc1.docnetic.net
host -t SRV_kerberos._udp.docnetic.net
host -t SRV_kerberos._ldap.docnetic.net
tput bold setaf 2 && read -p "Teszteles (AD/KERB) [ENTER] " && tput sgr0
smbclient -L localhost -U%
samba-tool domain level show
kinit administrator
klist
