# squidmdemdi

# This isn't a Microsoft produced script, this is my creation.

# Why to use
This solution is designed to be used to deployment. Often systems cannot be allowed direct internet access or there are other filtering solutions in place for the system to use. This proxy is designed to be configured at the application level, so that the operating system can utilize its own proxy or internet rules, where MDE/MDI can use this proxy to talk to their required endpoints.

# About
The proxy in a box is designed to run on Ubuntu Linux and is a preconfigured, known good Squid install with only the MDE/MDI endpoints allowed in the mdemdi.conf file. The squid.conf file is configured to only allow connections _from_ RFC 1918 addresses, so public address space cannot be used to connect to the proxy. If your environment is using public address space internally you'll need to modify the squid.conf file.

The squid.conf file only has 1 allow list of endpoints configured at /etc/squid/mdemdi.conf. This proxy is specifically designed not for system use, but only to be used by the MDE/MDI applications. However, you can still utilize this for generic use as long as you provision the endpoints. If you need to allow additional endpoints the easiest way is to edit the /etc/squid/mdemdi.conf file. If you want you can add your own allow list file and edit the squid.conf file to incorporate your new endpoint file.

# Instructions
Create an Ubuntu server (anything supported). Nothing special needs to be in the install.

Login and run the SquidConfig.sh script. The script must be run as root (sudo -i) or sudo.