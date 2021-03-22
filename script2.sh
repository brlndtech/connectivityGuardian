#!/bin/bash 
logsPath="$(pwd)/output.txt"
email="gsb@yopmail.com"
d="$(date +%d-%m-%Y-%H-%M)"
file="ip-dns.txt"
lines=$(cat $file)
for ip in $lines ; 
do 
   ( 
      ping $ip -c1 &> /dev/null ; 
      if [ $? -eq 0 ]; 
      then 
       echo "$ip : Is alive" >> $logsPath
      elif [ $? -eq 1 ];then 
       echo "$ip : Request timed out" >> $logsPath
       # echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br> -> <b> Request timed out </b>" | mail -s "Perte de connectivité - VM Lab" $email
      elif [ $? -eq 2 ];then 
       echo "$ip : Destination host unreachable" >> $logsPath
       # echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br>-> <b> Destination host unreachable </b> " | mail -s "$(echo -e "Perte de connectivité - VM Lab \nContent-Type: text/html")" $email
      fi
   )& 
  done 
wait
