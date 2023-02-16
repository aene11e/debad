#!bin/bash
clear
tput setaf 1 && tput bold
echo "Udvozollek a Debian Samba AD telepitovarazslojaban."
echo "Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:"
echo ">  /etc/hostname"
echo ">  /etc/hosts"
echo ">  /etc/network/interfaces"
echo ">  /etc/resolv.conf"
echo "[ver.: Debian 11.6.0]"
tput bold && tput setaf 2 && read -p "Telepites:[Y,n] Teszteles:[y,N] " valasz  && tput sgr0
if [ $valasz = "Y" ]
then
  tput bold && tput setaf 2 && read -p "Rendszerfrissites [ENTER] " && tput sgr0
  apt-get update -o Acquire::ForceIPv4=True && apt-get dist-upgrade -o Acquire::ForceIPv4=True -y
  tput bold && tput setaf 2 && read -p "Telepites [ENTER] " && tput sgr0
  apt-get install -y tree mc isc-dhcp-server openssh-server apache2 htop ufw unattended-upgrades cabextract libmspack0  rkhunter ntp samba smbclient winbind krb5-config krb5-user dnsutils
  wget "http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb"
  dpkg -i ttf-mscorefonts-installer_3.6_all.deb 
  tput bold && tput setaf 2 && read -p "Az alap Samba es Kerberos conf fajl torlese [ENTER] " && tput sgr0
  rm -v /etc/samba/smb.conf
  rm -v /etc/krb5.conf
  tput bold && tput setaf 2 && read -p "Samba-tool Domain beallitasok [ENTER] " && tput sgr0
  samba-tool domain provision --use-rfc2307 --realm=docnetic.net.local --domain=docnetic --server-role=dc --adminpass=S3cr3tvizsga!!
  cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
  systemctl stop smbd nmbd winbind
  systemctl disable smbd nmbd winbind
  systemctl unmask samba-ad-dc
  systemctl start samba-ad-dc
  systemctl enable samba-ad-dc
  chmod 750 /var/lib/ntp_signd
  tput bold && tput setaf 2 && read -p "Reverse Zone letrehozasa [ENTER] " && tput sgr0
  samba-tool dns zonecreate 10.0.0.66 66.0.0.10.in-addr.arpa -U administrator
  ufw allow 53 && ufw allow 88 && ufw allow 80 && ufw allow 443 
else
  clear
  tput bold && tput setaf 1 
  echo "[realms]
  kdc = docnetic.net.local:88 KDC server megjelolese krb5.confban!
  [domain_realm]
    .docnetic.net.local = DOCNETIC.NET.LOCAL
    docnetic.net.local = DOCNETIC.NET.LOCAL
    ------------
    /etc/resolv.conf ellenorzese
    ------------
    " && tput sgr0
  tput bold && tput setaf 2 
  echo "/etc/samba/smb.conf-ba egy /adatok megosztast + kozos mappa, 
  kotegeles + globalhoz inherit acls = yes" && tput sgr0
  tput bold && tput setaf 2 && read -p "Teszteles (NTP) [ENTER] " && tput sgr0
  ntpq -p
  ntpq -c rv
  tput bold && tput setaf 2 && read -p "Teszteles (SRV) [ENTER] " && tput sgr0
  host -t A dc1.docnetic.net.local
  host -t SRV _kerberos._udp.docnetic.net.local
  host -t SRV _ldap_tcp.docnetic.net.local
  tput bold && tput setaf 2 && read -p "Teszteles (AD/KERB) [ENTER] " && tput sgr0
  smbclient -L localhost -U%
  samba-tool domain level show
  kinit administrator
  klist
  echo "--A program kilepett--"
fi
