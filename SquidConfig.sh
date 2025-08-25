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
.atp.azure.com
.azure-automation.net
.azurewebsites.net
.blob.core.usgovcloudapi.net
.blob.core.windows.net
.cloud.microsoft
.digicert.com
.entrust.net
.microsoft.com
.microsoft365.com
.microsoftonline-p.com
.ods.opinsights.azure.com
.ods.opinsights.azure.us
.oms.opinsights.azure.com
.oms.opinsights.azure.us
.securitycenter.microsoft.us
.ss.wd.microsoft.us
.ssllabs.com
.windows.com
.windowsupdate.com
azure.archive.ubuntu.com
enterpriseregistration.windows.net
login.live.com
login.microsoftonline.com
login.microsoftonline.us
login.windows.net
officecdn-microsoft-com.akamaized.net
static2.sharepointonline.com
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

sed -i '/^proxy soft nofile/d' /etc/security/limits.conf
sed -i '/^proxy hard nofile/d' /etc/security/limits.conf
sed -i '/^# End of file/i proxy soft nofile 65535' /etc/security/limits.conf
sed -i '/^proxy soft nofile 65535/i proxy hard nofile 65535' /etc/security/limits.conf
sed -i '/^session required pam_limits.so/d' /etc/pam.d/common-session
sed -i '/^session required pam_limits.so/d' /etc/pam.d/common-session-noninteractive
sed -i '/^# end of pam-auth-update config/i session required pam_limits.so' /etc/pam.d/common-session
sed -i '/^# end of pam-auth-update config/i session required pam_limits.so' /etc/pam.d/common-session-noninteractive
sed -i '/^DefaultLimitNOFILE=/d' /etc/systemd/user.conf
sed -i '/^DefaultLimitNOFILE=/d' /etc/systemd/system.conf
echo DefaultLimitNOFILE=65535 >> /etc/systemd/user.conf
echo DefaultLimitNOFILE=65535 >> /etc/systemd/system.conf
sudo systemctl daemon-reexec
systemctl restart squid