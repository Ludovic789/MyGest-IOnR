#!/bin/bash

read -p "Adresse IP du switch : " ip
read -p "Communauté SNMP (ex: public) : " community

echo "Liste des interfaces disponibles sur le switch $ip :"
snmpwalk -v2c -c $community $ip IF-MIB::ifDescr
