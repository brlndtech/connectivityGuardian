#!/bin/bash
logsPath="$(pwd)/output.txt"
email="gsb@yopmail.com"
d="$(date +%d-%m-%Y-%H-%M)"
echo "-----> Start ping scan $d " >> $logsPath
while read line || [ -n "$line" ];
do   
   ping -c 1 $line > /dev/null ;
   if [ $? -eq 0 ];then 
       echo "$line : Is alive" >> $logsPath
   elif [ $? -eq 1 ];then 
       echo "$line : Request timed out" >> $logsPath
       echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br> -> <b> Request timed out </b>" | mail -s "Perte de connectivité - VM Lab" $email
   elif [ $? -eq 2 ];then 
       echo "$line : Destination host unreachable" >> $logsPath
       echo "&#9888;&#65039; La machine virtuelle identifié par $line n'a pas répondu au dernier ping. <br>-> <b> Destination host unreachable </b> " | mail -s "$(echo -e "Perte de connectivité - VM Lab \nContent-Type: text/html")" $email
   fi
done < $(pwd)/ip-dns.txt
echo -e "<----- End $d \n" >> $logsPath
echo "Here is the report of the last connectivity test" | mail -s "Whole Report" -A $logsPath $email