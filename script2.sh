#!/bin/bash
logsPath="$(pwd)/output-all.txt" ; logsPath1="$(pwd)/output-request-timed-out.txt" ; logsPath2="$(pwd)/output-host-is-unreachable.txt"
email="gsb@yopmail.com"
d="$(date +%d-%m-%Y-%H-%M)"
file="ip-dns.txt"
lines=$(cat $file)
for ip in $lines ; 
do (  ##### sub shell who allow us to execute parallel pings (thread)
      ping $ip -c1 &> /dev/null ; 
      if [ $? -eq 0 ]; 
      then 
       echo "$ip : Is alive" >> $logsPath
      elif [ $? -eq 1 ];then 
       echo "$ip : Request timed out" | tee -a $logsPath | tee -a $logsPath1
       # echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br>-> <b> Request timed out </b>" | mail -s "$(echo -e "Perte de connectivité - VM Lab \nContent-Type: text/html")" -A $logsPath2 $email
      elif [ $? -eq 2 ];then 
       echo "$ip : Destination host unreachable" | tee -a $logsPath | tee -a $logsPath1
       # echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br>-> <b> Destination host unreachable </b> " | mail -s "$(echo -e "Perte de connectivité - VM Lab \nContent-Type: text/html")" -A $logsPath2 $email
      fi 
   )& ##### end of sub shell who allowed us to execute parallel pings (thread)
done 
wait
