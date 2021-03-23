#!/bin/bash
logsPath="/etc/connectivityGuardian/output-all.txt" ; logsPath1="/etc/connectivityGuardian/output-request-timed-out.txt" ; logsPath2="/etc/connectivityGuardian/output-host-is-unreachable.txt" ; file="/etc/connectivityGuardian/ip-dns.txt"
email="gsb@yopmail.com"
d="$(date +%d-%m-%Y-%H-%M)"
lines=$(cat $file)
for ip in $lines ; 
do (  ##### sub shell who allow us to execute parallel pings (thread)
      if ping -c 1 $ip | grep "64"; 
      then 
          echo "$ip : Is alive" >> $logsPath
      elif ping -c 1 $ip | grep "+";then 
          echo "$ip : Destination host unreachable" | tee -a $logsPath | tee -a $logsPath2
      elif ping -c 1 $ip | grep "100";then 
          echo "$ip : Request timed out" | tee -a $logsPath | tee -a $logsPath1
      fi
   )& ##### end of sub shell who allowed us to execute parallel pings (thread)
done 
wait
# echo "&#9888;&#65039; One or more machines did not answered to the last ping scan. <br>-> <b> Request timed out </b>" | mail -s "$(echo -e "Connectivity loose report - connectivityGuardian \nContent-Type: text/html")" -A $logsPath1 $email
# echo "&#9888;&#65039; One or more machines did not answered to the last ping scan. <br>-> <b> Destination host unreachable </b> " | mail -s "$(echo -e "Perte de connectivité - VM Lab \nContent-Type: text/html")" -A $logsPath2 $email

