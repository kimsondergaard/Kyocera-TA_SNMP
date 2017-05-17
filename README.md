# Kyocera / Triumph Adler / UTAX snmp printer status
# Kim Søndergaard
# Requires SNMPGET is installed
# Run in linux, or Windows with BASH installed by ./snmp.sh
# Config file is requires to use this script, place the config in a file named config.sh, with chmod 777. 
# Template # 


#!/bin/bash
# Kyocera / Triumph Adler / UTAX snmp printer status
# Kim Søndergaard
# Config file, for customer specific variables
#Run in linux, or Windows with BASH installed by ./snmp.sh

host="Hostname/IP"
user="User to mysql db"
pw="password to mysql db"
db="Databse name in server"
tb="table name in database"

ips=('192.168.111.240')

# For table rows, look in the script file!
