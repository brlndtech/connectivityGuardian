#!/bin/bash 
#Filename: fast_ping.sh 
# Change base address 192.168.0 according to your network. 
file="ip-dns.txt"
lines=$(cat $file)
for ip in $lines ; 
do 
   ( 
      ping $ip -c1 &> /dev/null ; 

      if [ $? -eq 0 ]; 
      then 
       echo $ip is alive >> out.txt 
      else 
       echo $ip is dead >> out.txt   
      fi 
   )& 
  done 
wait
