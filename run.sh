#!/bin/bash
logsPath="/etc/connectivityGuardian/output-all.txt" ; logsPath1="/etc/connectivityGuardian/output-request-timed-out.txt" ; logsPath2="/etc/connectivityGuardian/output-host-is-unreachable.txt" ; file="/etc/connectivityGuardian/ip-dns.txt"
email="vmsafeguard@yopmail.com"
d="$(date +%d-%m-%Y-%H-%M)"
lines=$(cat $file)
tmp="tmp.txt"
touch $tmp
for ip in $lines ; 
do (  ##### sub shell who allow us to execute parallel pings (thread)
      if ping -c 1 $ip | grep "64"; then 
          echo "$ip : Is alive" >> $logsPath
      elif ping -c 1 $ip | grep "+"; then 
          echo "$ip : Destination host unreachable" | tee -a $logsPath | tee -a $logsPath2
          echo "$ip" | tee -a $tmp
      elif ping -c 1 $ip | grep "100"; then 
          echo "$ip : Request timed out" | tee -a $logsPath | tee -a $logsPath1
          echo "$ip" | tee -a $tmp      
      fi
   )& ##### end of sub shell who allowed us to execute parallel pings (thread)
done
wait
arr=()
while IFS= read -r line; do
   arr+=("$line,")
done <$tmp
h=$(echo ${arr[@]})
curl -d "test=coguardian&ip=$h&adminEmail=$email" -X POST https://le-guide-du-sysops.fr/vmsafeguard-mail-api/mail.php
rm $tmp