#!/bin/bash

#import des configs et fonctions
source config.sh
echo affiche

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi


        # Consultation des données
        echo "Que souhaitez-vous consulter ?"
        echo "1) Toutes les informations"
        echo "2) Seulement les machines"
        echo "3) Seulement les serveurs"
        echo "4) Seulement les switches"
        echo "0) Retour"
        echo -n "Veuillez choisir une option : "
        read consult

        case $consult in
            1) mysql -u "$DB_USER" -p "$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM Equipement;" ;;
            2) mysql -u "$DB_USER" -p "$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM Equipement WHERE idT=1;" ;;
            3) mysql -u "$DB_USER" -p "$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM Equipement WHERE idT=3;" ;;
            4) mysql -u "$DB_USER" -p "$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM Equipement WHERE idT=2;" ;;
            0) continue ;;
            *) echo "Option invalide." ;;
        esac
        quitter=0