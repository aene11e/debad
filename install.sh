#!bin/bash
clear
tput setaf 1 && tput bold
echo "Udvozollek a Debian Samba AD telepitovarazslojaban.
Gyozodj meg rola ,hogy elvegezted az elokonfiguracios beallitasokat az alabbi fajlokban:
>  /etc/hostname > dc1.docnetic.net.local
>  /etc/hosts > 10.0.0.66 DC1.docnetic.net.local DC1
>  /etc/network/interfaces > static ip
>  /etc/resolv.conf > 
[ver.: Debian 11.6.0]"
hostnamectl set-hostname dc1.docnetic.net.local
tput bold && tput setaf 2 && read -p "Telepites:[Y,n] Teszteles:[ENTER] " valasz  && tput sgr0
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
  tput bold && tput setaf 2 && read -p "Reverse Zone letrehozasa IPv6 [ENTER] " && tput sgr0
  samba-tool dns zonecreate 10.0.0.66 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.b.0.0.0.d.a.c.a.8.b.d.0.1.0.0.2.ip6.arpa -U administrator
  ufw enable && ufw logging high
  ufw allow 67/udp && ufw allow 68/udp && ufw allow DNS && ufw allow "WWW Full" && ufw allow "WWW Cache"
  ufw allow "Kerberos Admin" && ufw allow "Kerberos Password" && ufw allow "Kerberos KDC" && ufw allow "Kerberos Full" && ufw allow LDAP
  ufw allow LDAPS && ufw allow OpenSSH
  ufw allow to any from 10.0.0.64/29 && ufw status verbose
  ufw allow to any from 2001:db8:acad:b::1/64 && ufw status verbose
else
  clear
  echo "domain dc1.docnetic.net.local" > /etc/resolv.conf
  echo "search dc1.docnetic.net.local" >> /etc/resolv.conf
  echo "nameserver 10.0.0.66" >> /etc/resolv.conf
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
  host -t AAAA dc1.docnetic.net.local
  host -t SRV _kerberos._udp.docnetic.net.local
  host -t SRV _ldap._tcp.docnetic.net.local
  tput bold && tput setaf 2 && read -p "Teszteles (AD/KERB) [ENTER] " && tput sgr0
  smbclient -L localhost -U%
  tput bold && tput setaf 2 && read -p "Teszteles (DOMAIN) [ENTER] " && tput sgr0
  samba-tool domain level show
  kinit administrator
  klist
  samba-tool dns zonelist 10.0.0.66 -UAdministrator
  samba-tool domain info 10.0.0.66 -UAdministrator
  echo "--A program kilepett--"
fi
