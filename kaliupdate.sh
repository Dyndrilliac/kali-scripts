#!/usr/bin/env bash

echo -e "\e[1;34m[*] Checking connectivity\e[0m"
echo
sleep 2
TESTHOST="google.com"

TEST=`ping -c1 $TESTHOST|grep "1 packets transmitted"|cut --delimiter="," -f 3`
PASS=" 0% packet loss"

if [ "$TEST" = "$PASS" ]; then
        echo -e "\e[1;34m[*] Congratz bro! t3h Interntz is working\e[0m"

sleep 3
echo
echo -e "\e[1;34m[*] Updating the entire system...\e[0m"
echo
apt-get update && apt-get upgrade -y
echo
sleep 2
echo -e "\e[1;34m[*]Updating MSF.\e[0m"
/opt/metasploit/apps/pro/msf3/msfupdate
echo
sleep 2
echo -e "\e[1;34m[*]Updating Nessus.\e[0m"
if [ -f /opt/nessus/sbin/nessus-update-plugins ] ;
then
	cd /opt/nessus/sbin
	./nessus-update-plugins
else
	echo -e "\e[1;34m[*]Install Nessus and try again, or not.\e[0m"
fi
echo
sleep 2
echo -e "\e[1;34m[*]Installing SVN version of fuzzdb in /usr/share/fuzzdb and keeping it updated.\e[0m"
if [ -d /usr/share/fuzzdb ] ;
then
	cd /usr/share/fuzzdb
	svn update
else
	echo -e "\e[1;34m[*]Fuzzdb not found, installing at /usr/share/fuzzdb.\e[0m"
	cd /usr/share
	svn checkout http://fuzzdb.googlecode.com/svn/trunk fuzzdb
fi
echo
sleep 2
echo -e "\e[1;34m[*]Adding nmap-svn to /opt/nmap-svn.\e[0m"
svn co --username guest --password "" https://svn.nmap.org/nmap /opt/nmap-svn
cd /opt/nmap-svn
./configure && make
/opt/nmap-svn/nmap -V
echo "Installed in /opt/nmap-svn"
echo
sleep 2
echo -e "\e[1;34m[*]Installed or updated Fuzzdb to /usr/share/fuzzdb.\e[0m"
echo -e "\e[1;34m[*]Installed or updated nmap-svn to /opt/nmap-svn.\e[0m"
echo -e "\e[1;34m[*]All done.\e[0m"

else
        echo -e "\e[1;34m[*] You do not apear to have an Internet connection connection\e[0m"
        echo -e "\e[1;34m[*] Please connect to t3h Internetz and rerun this script\e[0m"

fi

exit 0