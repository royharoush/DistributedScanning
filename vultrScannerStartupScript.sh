#add this script to the scanner you will create on vultr 
#then refer to it in the scanner creation process  
#your machine needs to be debian 8 64bit 
#!/bin/bash
sleep 5
apt-key adv --keyserver pgp.mit.edu --recv-keys ED444FF07D8D0BF6
#echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \    > /etc/apt/apt.conf.d/01keep-debs
printf "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list
sleep 3
export DEBIAN_FRONTEND=noninteractive
apt-get purge && apt-get update -y -q 
#aptitude update
#echo -ne q | apt-get update
sleep 3
apt-get install screen -y
apt-get install dnmap -y --force-yes --assume-yes 
sleep 3
apt-get install nmap -y --force-yes --assume-yes 
sleep 3
dnmap_client -s X.X.X.X -p XXXX
#ln -sf $(realpath botnetscanmap.sh) /etc/rc.d/botnetscanmap.sh
#chmod +x /etc/rc.d/botnetscanmap.sh
#exit 0
