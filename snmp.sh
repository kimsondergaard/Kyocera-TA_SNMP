#!/bin/bash
# Kyocera / Triumph Adler / UTAX snmp printer status
# Kim Søndergaard
#Run in linux, or Windows with BASH installed by ./snmp.sh

#Toner name = snmp_get('.1.3.6.1.2.1.43.11.1.1.6.1.		
#iso.3.6.1.2.1.43.11.1.1.6.1.1 = STRING: "CK-8512C"
#iso.3.6.1.2.1.43.11.1.1.6.1.2 = STRING: "CK-8512M"
#iso.3.6.1.2.1.43.11.1.1.6.1.3 = STRING: "CK-8512Y"
#iso.3.6.1.2.1.43.11.1.1.6.1.4 = STRING: "CK-8512K"
#iso.3.6.1.2.1.43.11.1.1.6.1.5 = STRING: "Waste Toner Box"

#Max toner = snmp_get('.1.3.6.1.2.1.43.11.1.1.8.1.
#iso.3.6.1.2.1.43.11.1.1.8.1.1 = INTEGER: 15000
#iso.3.6.1.2.1.43.11.1.1.8.1.2 = INTEGER: 15000
#iso.3.6.1.2.1.43.11.1.1.8.1.3 = INTEGER: 15000
#iso.3.6.1.2.1.43.11.1.1.8.1.4 = INTEGER: 25000

#Toner usage = snmp_get('.1.3.6.1.2.1.43.11.1.1.9.1.
#iso.3.6.1.2.1.43.11.1.1.9.1.1 = INTEGER: 11400
#iso.3.6.1.2.1.43.11.1.1.9.1.2 = INTEGER: 9900
#iso.3.6.1.2.1.43.11.1.1.9.1.3 = INTEGER: 8850
#iso.3.6.1.2.1.43.11.1.1.9.1.4 = INTEGER: 13250
#iso.3.6.1.2.1.43.11.1.1.9.1.5 = INTEGER: -3

ips=('192.168.111.240') # Alternative if more than one MFP ('xxx.xxx.xxx.xxx','xxx.xxx.xxx.xxx')

for ip in ${ips[@]} ; do
serial=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.5.1.1.17.1 | cut -d" " -f4-) 
model=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.5.1.1.16.1 | cut -d" " -f4-)
total=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.43.10.1.1.12.1.1 | cut -d" " -f4-)
a3c=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.42.2.1.1.1.8.1.1 | cut -d" " -f4-)
a3m=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.42.2.1.1.1.7.1.1 | cut -d" " -f4-)
a4m=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.42.2.1.1.1.7.1.3 | cut -d" " -f4-)
a4c=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.42.2.1.1.1.8.1.3 | cut -d" " -f4-)
hostname=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.40.10.1.1.5.1 | cut -d" " -f4-) 
scan=$(snmpget -v2c -c public $ip iso.3.6.1.4.1.1347.46.10.1.1.5.3 | cut -d" " -f4-)


cname=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.6.1.1 | cut -d" " -f4-)
mname=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.6.1.2 | cut -d" " -f4-)
yname=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.6.1.3 | cut -d" " -f4-)
kname=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.6.1.4 | cut -d" " -f4-)


tcyan=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.9.1.1 | cut -d" " -f4-)
tmagenta=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.9.1.2 | cut -d" " -f4-)
tyellow=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.9.1.3 | cut -d" " -f4-)
tkey=$(snmpget -v2c -c public $ip iso.3.6.1.2.1.43.11.1.1.9.1.4 | cut -d" " -f4-)

bbase=25000
cbase=15000
pro=100

result=`echo "scale=2; $tkey/$bbase * $pro" | bc`
key=${result%.*}

cresult=`echo "scale=2; $tcyan/$cbase * $pro" | bc`
cyan=${cresult%.*}

mresult=`echo "scale=2; $tmagenta/$cbase * $pro" | bc`
magenta=${mresult%.*}

yresult=`echo "scale=2; $tyellow/$cbase * $pro" | bc`
yellow=${yresult%.*}



#WRITE TO FILE
 
echo "
INFO-----------------------
Serialnumber: ${serial} 
Model: ${model} 
Ip address: ${ip}
Hostname: ${hostname} 

PAPER USAGE----------------
Total Scan: ${scan} 
Total print: ${total} 
A3 Color: ${a3c} 
A3 B/W: ${a3m} 
A4 Color: ${a4c} 
A4 B/W: ${a4m} 

TONER USAGE----------------
Cyan: ${cyan}% ${cname}
Magenta: ${magenta}% ${mname} 
Yellow: ${yellow}% ${yname}
Key/Black: ${key}% ${kname} " >> MFP.txt



#WRITE TO MYSQL


#mysql --host=xxx.xxx.xxx.xxx --user=USERNAME --password=PASSWORD status_printer -e "INSERT INTO DATABASENAME (serial,model,total,a3c,a3m,a4m,a4c,hostname,scan,ip,cyan,magenta,yellow,key)
 #VALUES('${serial}','${model}','${total}','${a3c}','${a3m}','${a4m}','${a4c}','${hostname}','${scan}','${ip}','${cyan}','${magenta}','${yellow}','${key}');"


done

