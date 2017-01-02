#!/bash/bin
echo "If you are not sure what information you need to enter you should CTRL+C and read the documentation!"
echo "Where do you want to create your scanners(if you are not sure, you need to check the DCID in using DistributedScan-vultrGetLocations):"
export VULTRAPIKEY="VULTRAPIKEY"
read  dcid
echo $VULTRAPIKEY
echo "How many instances to create:"
read number
for i in $(seq 1 $number); do date ;done
echo "creating" $number "scanners in location" $dcid
for i in $(seq 1 $number); do  curl -H "API-Key: "$VULTRAPIKEY"" https://api.vultr.com/v1/server/create  --data 'VPSPLANID=29' --data 'OSID=193' --data 'SCRIPTID=18661'  --data 'SSHKEYID=578f78ece9844' --data "DCID="$dcid"" --data "label=scanmachine1"; done;
