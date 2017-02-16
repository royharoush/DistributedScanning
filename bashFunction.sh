#add this functions to your bashrc file or source them when you want to operate your scanners and files 
#you need to change the vultr API key here 
#setup
function DistributedScan-Setup(){
wget https://raw.githubusercontent.com/royharoush/rtools/master/json2csv.py -O /usr/bin/json2csv.py && chmod +x /usr/bin/json2csv.py
apt-get install jq -y > /dev/null 
apt-get install pv -y > /dev/null
apt-get install pssh -y >/dev/null
apt-get install cssh -y >/dev/null
apt-get install ssh
apt
printf "Finished ! "
}

export VULTRAPIKEY="ENTER YOUR VULTR API KEY HERE"


#enable SSH-Agent to start when terminal starts, leaving this function will disable automated data retreival. 
eval $(ssh-agent)

#Vultr 
function DistributedScan-vultrGetAllserversCSV(){
rm vulter-servers.csv
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json >> vulter-servers.csv && libreoffice vulter-servers.csv &
}
function DistributedScan-vultrGetAllserversPrint(){
rm vulter-servers.csv
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json >> vulter-servers.csv &&  cat vulter-servers.csv
}

function DistributedScan-vultrGetAllserversLight(){
rm vulter-servers.csv
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |  cut -d"," -f1,10,16
}

#function DistributedScan-vultrGetScannersIP(){
#curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f10 > scanners_IP
#}

#function DistributedScan-vultrGetScannersSubID(){
#curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f1 > scanners_subid
#}

function DistributedScan-vultrGetLocations(){
curl https://api.vultr.com/v1/regions/list | jq . > locations.json && json2csv.py locations.json
}

function DistributedScan-vultrCreateStartupScript(){
echo "Enter the Designated Dnmap server to be pushed into the script:"
read dnmapserver
echo "Enter the Dnmap server's port:"
read dnmapport
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/startupscript/create --data 'name=temp1' --data 'script=#!/bin/bash%0d%0asleep 5%0d%0aapt-key adv --keyserver pgp.mit.edu --recv-keys ED444FF07D8D0BF6%0d%0a> /etc/apt/apt.conf.d/01keep-debs%0d%0aprintf "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list%0d%0asleep 3%0d%0aexport DEBIAN_FRONTEND=noninteractive%0d%0aapt-get purge %0d%0 apt-get update -y -q %0d%0asleep 3%0d%0aapt-get install screen -y%0d%0aapt-get install dnmap -y --force-yes --assume-yes %0d%0aapt-get install bash-completion -y --force-yes --assume-yes %0d%0acp /etc/skel/.bashrc ~/%0d%0asleep 3%0d%0aapt-get install nmap -y --force-yes --assume-yes %0d%0asleep 3%0d%0adnmap_client -s "$DNMAPSERVER" -p "$DNMAPPORT"' | grep SCRIPTID | cut -d":" -f2 | tr -d } > startupScriptId



}
#vultr
#Data  Retreival
function DistributedScan-vpsGetResults (){
ssh-add
echo "what is the project name:"
read project
echo "Creating a folder to place all the results in /root/projects/"$project
mkdir -p /root/projects/$project
cd /root/projects/$project
rm vulter-servers.csv
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json > servers.csv && cat servers.csv |  cat servers.csv | grep scanmachine1| cut -d"," -f10 > scanners_IP 
pssh -i -h /root/projects/$project/scanners_IP  -x "-oStrictHostKeyChecking=no" ls 
#install rsync on remote servers
pssh -i -h /root/projects/$project/scanners_IP  -x "-oStrictHostKeyChecking=no" apt-get install rsync -y > /dev/null
pssh -i -h /root/projects/$project/scanners_IP  -x "-oStrictHostKeyChecking=no" apt-get install rsync -y > /dev/null
for i in $(cat /root/projects/$project/scanners_IP); do rsync -avz  --remove-source-files -e ssh  root@$i:/nmap_output/* /root/projects/$project --rsync-path=/usr/bin/rsync & done 
}
#data retreival 


#Delete scanners
function DistributedScan-vultrDeleteScanners(){
echo "Make sure you don't have any more scans running on your scanners."
echo "Run the Data Fetching function one last time and wait for it to finish."
echo -e " \e[91m \e[1;4m after you've made sure you retreived all the results and no new scans are running, run the following command:"
echo -e "\e[0mfor i in \$(cat scanners_subid);do curl -H "\"API-Key: "$VULTRAPIKEY"\"" https://api.vultr.com/v1/server/destroy --data 'SUBID='\$i'';done"
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f1 > scanners_subid
}

function DistributedScan-parseResults(){
wget https://raw.githubusercontent.com/royharoush/rtools/master/nmaParseClean.sh -O parse.sh && bash parse.sh
}


##Create Evasive Command file 
function DistributedScan-commandFileCreate_4(){
if [[ -f ./targets && -f ./ports ]];then
	echo "Targets and Ports exists"
	echo "Creating command file" 
	echo "This may take a while, please do not CTRL+C"
	printf "53\n80\n443\n67\n20" > ./randomport
	for ip in $(nmap -iL targets -sL -Pn -sn -n  | grep "Nmap scan report"| sort -u  | cut -d" " -f 5  ) ; do for port in $(cat ports); do printf "nmap $ip -p $port -Pn --source-port $( cat  ./randomport  | shuf  | head -1)  --data-length $( shuf -i 50-100 -n 1) -oA nmap_result_$ip-$port\n"; done ;done > nmapCommands-EvasionSorted_4-$(cat ports | tr "\n" "-") && sort -R nmapCommands-EvasionSorted_4-$(cat ports | tr "\n" "-") | shuf > nmapCommands-Evasion_4-$(cat ports | tr "\n" "-") 

else
	echo "targets or ports missing"
fi
}

function DistributedScan-commandFileCreate_3(){
if [[ -f ./targets ]];then
	echo "Targets file exists"
	echo "Enter the ports to scan, you can use "-p port-list,singleport" or "--top-ports XXX":"
	read port
	echo "Creating command file" 
	echo "This may take a while, please do not CTRL+C"
	for ip in $(nmap -iL targets -sL -Pn -sn -n  | grep "Nmap scan report"| sort -u  |shuf | sort -R | cut -d" " -f 5  ); do printf "nmap $ip  $port -Pn --source-port $( cat  ./randomport  | shuf  | head -1)  --data-length $( shuf -i 50-100 -n 1) -oA \"nmap_result_$ip-$port\"\n";done > nmapCommands-Evasion_3-$(echo $port |tr " " "_" | tr "," "-")

else
	echo "targets file missing, please create it"
fi
}


##Create None Evasive None Command file 
function DistributedScan-commandFileCreate_2(){
if [[ -f ./targets && -f ./ports ]];then
	echo "Targets and Ports exists"
	echo "Creating command file" 
	echo "This may take a while, please do not CTRL+C"
	printf "53\n80\n443\n67\n20" > ./randomport
	for ip in $(nmap -iL targets -sL -Pn -sn -n  | grep "Nmap scan report"| sort -u  | cut -d" " -f 5  ) ; do for port in $(cat ports); do printf "nmap $ip -p $port -Pn -oA nmap_result_$ip-$port\n"; done ;done > nmapCommands-EvasionSorted_2-$(cat ports | tr "\n" "-") && sort -R nmapCommands-EvasionSorted_2-$(cat ports | tr "\n" "-") | shuf > nmapCommands-Evasion_2-$(cat ports | tr "\n" "-") 

else
	echo "targets or ports missing"
fi
}

##Create very none evasive command file 
function DistributedScan-commandFileCreate_1(){
if [[ -f ./targets ]];then
	echo "Targets file exists"
	echo "Enter the ports to scan, you can use "-p port-list,singleport" or "--top-ports XXX":"
	read port
	echo "Creating command file" 
	echo "This may take a while, please do not CTRL+C"
	rm nmapTargets > /dev/nul
	nmap -iL targets -sL -Pn -sn -n  | grep "Nmap scan report"| sort -u | cut -d" " -f 5 | shuf | sort -R  > nmapTargets
	for ip in $(cat nmapTargets) ; do echo  "nmap $ip -Pn $port -oA \"nmapResult_"$ip"_$port\"" ; done  > nmapCommands-Evasion_1-$(echo $port | tr "," "_" | tr " " "_" )
	rm nmapTargets 

else
	echo "targets file missing, please create it"
fi
}



function DistributedScan-commandFileCreateInfo(){
echo "Command files are the source files for Dnmapserver and they contain the nmap commands to be executed by the scanners."
echo "These commands will allow you to create command files using different types of techniques, using mainly 2 different evasion techniques:"
echo 			"1. randomizing the IP-Port pairs, so that hosts should not be scanned twice for the same port by the same scanner instance."
echo			"2. randomizing traffic paramters, such as the TCP data length and the souce port."
echo "The commands creation time of creation varies based on how complex it is perform the randomization, as much randmoized scans will take longer to produce. "
echo "Below is an explaintion of the complexlity level for each commadn file creation function "
echo " "
echo "commandFileCreate_1: This function creates a command file very quickly, but will not randomize IP-Port pairs and will not randomize traffic parameters"
echo "commandFileCreate_2: This function creates a command file very fairly quick, but will not randomize randomize traffic parameters, it will randomize IP-Port pairs"
echo "commandFileCreate_3: This function creates a command file kinda slow and will randomize traffic parameters but will not randomize IP-Port pairs"
echo "commandFileCreate_4: This function creates a command file kinda very slowly and will randomize traffic parameters as well as IP-Port pairs"
echo "in short, the higher the number, the longer it will take to create the command file, but the more evasive it will be:"
}

	
#	for ip in $(nmap -iL targets -sL -Pn -sn -n  | grep "Nmap scan report"| sort -u  |shuf | sort -R | cut -d" " -f 5  ); do printf "nmap $ip  $port -Pn --source-port $( cat  ./randomport  | shuf  | head -1)  --data-length $( shuf -i 50-100 -n 1) -oA nmap_result_#$ip-$(echo $port |tr " " "_")\n";done > commandFile-$(echo $port |tr " " "_" | tr "," "-").txt



function DistributedScan-vultrCreateScanners(){
echo "If you are not sure what information you need to enter you should CTRL+C and read the documentation!"
echo "Make sure you've updated the correct SSH key and starup script in this script" 
curl https://api.vultr.com/v1/regions/list | jq . > locations.json && json2csv.py locations.json
echo "Where do you want to create your scanners?(enter a location ID from the above list)"
#echo "(if you are not sure you need to check the DCID in using DistributedScan-vultrGetLocations):"
read  dcid
#echo $VULTRAPIKEY
echo "How many instances to create:"
read number
#for i in $(seq 1 $number); do date ;done
echo "Creating" $number "scanners in location" $dcid
for i in $(seq 1 $number); do  curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/create  --data 'VPSPLANID=29' --data 'OSID=193' --data 'SCRIPTID=18661'  --data 'SSHKEYID=578f78ece9844' --data "DCID="$dcid"" --data "label=scanmachine1"; done;
echo "Finished Creating" $number "scanners in location" $dcid 
}

#function DistributedScan-vultrCreateDnmapServer(){
#echo "If you are not sure what information you need to enter you should CTRL+C and read the documentation!"
#echo "Make sure you've updated the correct SSH key and starup script in this script" 
#curl https://api.vultr.com/v1/regions/list | jq . > locations.json && json2csv.py locations.json
#echo "Where do you want to create your scanners?(enter a location ID from the above list)"
#echo "(if you are not sure you need to check the DCID in using DistributedScan-vultrGetLocations):"
#read  dcid
#echo $VULTRAPIKEY
#echo "How many instances to create:"
#read number
#for i in $(seq 1 $number); do date ;done
#echo "Creating" $number "Dnmap Server in" $dcid
#for i in $(seq 1 $number); do  curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/create  --data 'VPSPLANID=29' --data 'OSID=194' --data 'SCRIPTID=18661'  --data 'SSHKEYID=578f78ece9844' --data "DCID="$dcid"" --data "label=dnmapserver"; done;
#echo "Finished Creating" $number "Servers in location" $dcid 
#}

function DistributedScan-vultrGetScannersInfo(){
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f1 > scanners_subid
curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f10 > scanners_IP
}


function DistributedScan-vultrDnmapServerInfo(){
echo "in order to use a dnmap server build one and make sure the server works, as there seems to be an issue with the twisted library in later debian releaes"
echo "if you want to import this scripts functions into your dnmap server, run the below command"
echo "wget https://raw.githubusercontent.com/royharoush/DistributedScanning/master/bashFunction.sh && source bashFunction.sh"

}

#function DistributedScan-vultrGetDnmapServerInfo(){
#curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep dnmapserver | cut -d "," -f1 > DnmapServer_subid
#curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep dnmapserver | cut -d "," -f10 > DnmapServer_IP
#echo -e " \e[91m \e[1;4m LOG IN TO YOUR SERVER AND EXECUTE DNMAP TO ALLOW CONNETIONS FROM SCANNERS"
#}

function DistributedScan-vpsExecuteCommand(){
echo "enter the command you would like to execute:"
read command
ssh-add 
if [[ -f ./scanners_IP ]];then
	pssh -o ./ -i -h scanners_IP  -x "-oStrictHostKeyChecking=no" "$command"
else
	echo "Geting scanners IP file"
	curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/list > servers.json && <servers.json jq '.'  | sed s'/},/},\n/' > servers-json.json && json2csv.py servers-json.json |grep scan | cut -d "," -f10 > scanners_IP
	pssh -o ./ -i -h scanners_IP  -x "-oStrictHostKeyChecking=no" "$command"
fi	
}

function DistributedScan-CheckScanProgress
if [ $# -lt 2 ]; then
echo "you need to provide the trace file and the corrosponding command file"
echo "example: DistributedScan-CheckScanProgress commandfile.dnmaptrace commandfile "
	else
	watch -n 1 "	cat $1 | xargs -I '{}' grep -n '{}'  $2	"

fi

##Distributed Scan Process ##

