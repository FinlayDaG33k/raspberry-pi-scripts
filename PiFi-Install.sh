'
The MIT License (MIT)

Copyright (c) 2016 Aroop 'FinlayDaG33k' Roelofs <contact@finlaydag33k.nl>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

echo "This script is in Dev and might not work, or kill your Pi."
echo "I'm not responsible for any damage done as stated in the MIT-License that the script uses."
read -p "Are you sure you want to continue?" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "Updating all your repos"
sudo apt-get update

echo "Installing some items"
sudo apt-get install libssl-dev isc-dhcp-server libnl-dev

echo "Setting up some stuff for you"
sed -i 'Ns/.*/#option domain-name "example.org"/' /etc/dhcp/dhcpd.conf
sed -i 'Ns/.*/#option domain-name-servers ns1.example.org, ns2.example.org/' /etc/dhcp/dhcpd.conf
sed -i 'Ns/.*/authoritative/' /etc/dhcp/dhcpd.conf

echo "subnet 192.168.42.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
echo "    range 192.168.42.10 192.168.42.50;" >> /etc/dhcp/dhcpd.conf
echo "    option broadcast-address 192.168.42.255;" >> /etc/dhcp/dhcpd.conf
echo "    option routers 192.168.42.1;" >> /etc/dhcp/dhcpd.conf
echo "    default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
echo "    max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
echo "    option domain-name "local";" >> /etc/dhcp/dhcpd.conf
echo "    option domain-name-servers 8.8.8.8, 8.8.4.4;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf

sed -i 'Ns/.*/INTERFACES="wlan0"/' /etc/default/isc-dhcp-server
echo "iface wlan0 inet static" >> /etc/network/interfaces
echo "		address 192.168.42.1" >> /etc/network/interfaces
echo "		netmask 255.255.255.0" >> /etc/network/interfaces

echo "Installing HostAPd for you"
wget http://w1.fi/releases/hostapd-2.5.tar.gz
tar xzvf hostapd-2.5.tar.gz
cd hostapd-2.5/hostapd
cp defconfig .config


sed -i 'Ns/.*/CONFIG_DRIVER_NL80211=y/' .config
make
sudo make install
cd 

echo "interface=wlan0" >> hostapd.conf
echo "	driver=nl80211" >> hostapd.conf
echo "	ssid=PiFi" >> hostapd.conf
echo "	channel=8" >> hostapd.conf
echo "	hw_mode=g" >> hostapd.conf

echo "Setting up DNSMasq for you"
sudo apt-get install dnsmasq


echo "Installation should be finished"
