# DistributedScanning
This project shows how to implement a distributed scanning startagy using mostly bash and the Vultr VPS service. 

###read the comments in the scripts for more information 

###Add an SSH key on vultr in the following URL:

https://my.vultr.com/sshkeys/

###Add a startup script on Vultr using the following URL:

https://my.vultr.com/startup/

the startup script you should use is also in this project, modify the IP of your dnmap server.


###Grab your Vultr API key here 
https://my.vultr.com/settings/#settingsapi


###Update the script ID and SSH Key ID in the DistributedScan-vultrCreateScanners function.



###Command file output examples

![alt tag](https://i.imgur.com/08NcOsL.png)


###Results folders and files Explained 

`
root@kaliiso:~/Results-27-01-17-18-35# find .
.
./gnmap-detailed.csv << -- very detailed CSV containing the service details (if you've modified the script) 

./XML-Subnets.txt << -- list of class C subnets that contain live hosts 

./XML-Host-Ports-Matrix.csv << -- CSV with IP, port, port schema for open ports from the XML files 

./XML-Live-IPs.txt << -- IPs which are up based on open ports from the XML files  


./XML-merged-27-01-17-18-35.xml << -- the Merged nmap XML from all the scans 

./Gnmap-OpenPorts.txt << -- list of all the open ports from Gnmap files 

./Gnmap-LiveHosts.txt << -- list of all live hosts from Gnmap files 

./gnx-suggested_scans-27-01-17-18-35.sh << -- list of suggested nmap scans for further information gathering, can be modified in the the 
parsing script 

./XML-Open-Ports.txt << --  list of all the open ports from the XML files

./gnmap-merged.gnmap << -- Merged gnmap files 

./gnmap-parser.sh << -- copy of the used gnmap parser

./GnmapFiles-27-01-17-18-35.tar.gz << -- backup of the parsed Gnmap files 

./NmapFiles-27-01-17-18-35.tar.gz << -- backup of the parsed Nmap files 

./XMLFiles-27-01-17-18-35.tar.gz << -- backup of the parsed XML files 

./Parsed-Results

./Parsed-Results/Host-Lists 

./Parsed-Results/Host-Lists/Alive-Hosts-ICMP.txt << -- list of hosts which are up due to ping reponse from Gnmap files 

./Parsed-Results/Host-Lists/Alive-Hosts-Open-Ports.txt << -- list of hosts which are up due to open ports from Gnmap files 

./Parsed-Results/Port-Matrix

./Parsed-Results/Port-Matrix/TCP-Services-Matrix.csv << -- CSV of Host to one port 


./Parsed-Results/Host-Type

./Parsed-Results/Host-Type/Nix.txt << -- identified unix systems 

./Parsed-Results/Host-Type/Webservers.txt << --identified WebServers

./Parsed-Results/Port-Files

./Parsed-Results/Port-Files/9000-cslistener-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/8008-http-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Port-Files/8009-ajp13-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Port-Files/21-ftp-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Port-Files/5060-sip-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Port-Files/9999-abyss-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/280-http-mgmt-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/3001-nessus-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/2107-msmq-mgmt-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/443-https-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Port-Files/81-hosts2-ns-TCP.txt << -- text file with all the IPs availble on these ports

./Parsed-Results/Port-Files/8888-sun-answerbook-TCP.txt << -- text file with all the IPs availble on these ports 

./Parsed-Results/Third-Party

./Parsed-Results/Third-Party/PeepingTom.txt << -- URL format for identified web ports 

./Parsed-Results/Port-Lists

./Parsed-Results/Port-Lists/TCP-Ports-List.txt << -- CSV open ports from Gnmap files (same file as the master directory) 

`

## Results screenshots
