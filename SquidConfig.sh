#!/bin/bash 
apt update
apt -y upgrade
apt install -y squid
systemctl start squid
systemctl enable squid
ufw allow 22,3128/tcp
echo y | ufw enable
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

cat <<EOF >/etc/squid/mdemdi.conf
crl.microsoft.com
www.microsoft.com
events.data.microsoft.com
.notify.windows.com
.wns.windows.com
login.microsoftonline.com
login.live.com
settings-win.data.microsoft.com
officecdn-microsoft-com.akamaized.net
crl.microsoft.com
packages.microsoft.com
enterpriseregistration.windows.net 
login.microsoftonline.com
.dm.microsoft.com 
.ods.opinsights.azure.com
.oms.opinsights.azure.com
.azure-automation.net
.blob.core.windows.net
login.windows.net  
.securitycenter.windows.com 
us.vortex-win.data.microsoft.com
us-v20.events.data.microsoft.com
winatp-gw-cus.microsoft.com
winatp-gw-eus.microsoft.com
winatp-gw-cus3.microsoft.com
winatp-gw-eus3.microsoft.com
automatedirstrprdcus.blob.core.windows.net
automatedirstrprdeus.blob.core.windows.net
automatedirstrprdcus3.blob.core.windows.net
automatedirstrprdeus3.blob.core.windows.net
ussus1eastprod.blob.core.windows.net
ussus2eastprod.blob.core.windows.net
ussus3eastprod.blob.core.windows.net
ussus4eastprod.blob.core.windows.net
wsus1eastprod.blob.core.windows.net
wsus2eastprod.blob.core.windows.net
ussus1westprod.blob.core.windows.net
ussus2westprod.blob.core.windows.net
ussus3westprod.blob.core.windows.net
ussus4westprod.blob.core.windows.net
wsus1westprod.blob.core.windows.net
wsus2westprod.blob.core.windows.net
eu.vortex-win.data.microsoft.com
eu-v20.events.data.microsoft.com
winatp-gw-neu.microsoft.com
winatp-gw-weu.microsoft.com
winatp-gw-neu3.microsoft.com
winatp-gw-weu3.microsoft.com
automatedirstrprdneu.blob.core.windows.net
automatedirstrprdweu.blob.core.windows.net
automatedirstrprdneu3.blob.core.windows.net
automatedirstrprdweu3.blob.core.windows.net
usseu1northprod.blob.core.windows.net
wseu1northprod.blob.core.windows.net
usseu1westprod.blob.core.windows.net
wseu1westprod.blob.core.windows.net
uk.vortex-win.data.microsoft.com
uk-v20.events.data.microsoft.com
winatp-gw-uks.microsoft.com
winatp-gw-ukw.microsoft.com
automatedirstrprduks.blob.core.windows.net
automatedirstrprdukw.blob.core.windows.net
ussuk1southprod.blob.core.windows.net
wsuk1southprod.blob.core.windows.net
ussuk1westprod.blob.core.windows.net
wsuk1westprod.blob.core.windows.net
.update.microsoft.com
.delivery.mp.microsoft.com
.windowsupdate.com
go.microsoft.com 
definitionupdates.microsoft.com 
.download.windowsupdate.com
.download.microsoft.com
fe3cr.delivery.mp.microsoft.com
crl.microsoft.com
vortex-win.data.microsoft.com
settings-win.data.microsoft.com
.wdcp.microsoft.com
.wdcpalt.microsoft.com
.wd.microsoft.com
ussus1eastprod.blob.core.windows.net
ussus2eastprod.blob.core.windows.net
ussus3eastprod.blob.core.windows.net
ussus4eastprod.blob.core.windows.net
wsus1eastprod.blob.core.windows.net
wsus2eastprod.blob.core.windows.net
ussus1westprod.blob.core.windows.net
ussus2westprod.blob.core.windows.net
ussus3westprod.blob.core.windows.net
ussus4westprod.blob.core.windows.net
wsus1westprod.blob.core.windows.net
wsus2westprod.blob.core.windows.net
usseu1northprod.blob.core.windows.net
wseu1northprod.blob.core.windows.net
usseu1westprod.blob.core.windows.net
wseu1westprod.blob.core.windows.net
ussuk1southprod.blob.core.windows.net
wsuk1southprod.blob.core.windows.net
ussuk1westprod.blob.core.windows.net
wsuk1westprod.blob.core.windows.net
.smartscreen-prod.microsoft.com
.smartscreen.microsoft.com
.checkappexec.microsoft.com
.urs.microsoft.com
.ods.opinsights.azure.com
.oms.opinsights.azure.com
.blob.core.windows.net
.azure-automation.net
azure.archive.ubuntu.com
packages.microsoft.com
winatp-gw-cane.microsoft.com
.atp.azure.com
EOF

cat <<EOF >/etc/squid/squid.conf
http_port 3128
icp_port 0
redirect_rewrites_host_header off
forwarded_for delete
via off
cache deny all
acl localhost src 127.0.0.1/32
acl localnet src 10.0.0.0/8     # RFC 1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC 1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC 1918 possible internal network
acl azuremdemdi dstdomain "/etc/squid/mdemdi.conf"
acl Safe_ports port 80 443
acl CONNECT method CONNECT
acl all src all
http_access allow localnet azuremdemdi
http_access allow localhost
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
EOF

systemctl restart squid