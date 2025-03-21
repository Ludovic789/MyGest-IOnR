#!/bin/bash

#import des configs et fonctions
source config.sh
source fonction.sh


afficheTitre 'Outils reseau'
quitter=1
while [[ $quitter -ne 0 ]]
do
echo -e "\nMenu :"
echo "1) Tester une IP"
echo "2) Tester un port TCP"
echo "3) Générer un .txt depuis la BDD"
echo "4) Consulter les IP actives"
echo "5) Interroger un switch SNMP"
echo "6) Configurer l'IP du switch/routeur"
echo "7) Accéder à la gestion du switch SNMP"
echo "0) Retour au menu principal"
echo -e "Veuillez choisir une option :"
read choix
case $choix in 
	1 )
		bash outilsRx/testIP.sh
		;;
	2 )
		bash outilsRx/testTCP.sh
		;;
	3 )
		bash outilsRx/generTxt.sh
		;;
	4 )
		bash outilsRx/checkValid.sh
		;;
	5 )
		bash outilsRx/snmpSwitch.sh
		;;
	6 )
		bash outilsRx/setSwitchIP.sh
		;;
	7 )
		bash sudo bash outilsRx/deploy_switch_snmp.sh
		;;
	0 )
		quitter=0
    	;;
	* )
		echo "Erreur dans la saisie"
		;;
esac
done
