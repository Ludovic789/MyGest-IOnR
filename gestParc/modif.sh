#!/bin/bash

#import des configs et fonctions
source config.sh
echo modif

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi
      # Modification de données
        echo -n "Donner l'ID de l'équipement à modifier : "; read id
        echo -n "Nouveau nom : "; read nom
        echo -n "Nouvelle adresse MAC : "; read mac
        echo -n "Nouvelle adresse IP : "; read ip
        echo -n "Nouveau masque (CIDR) : "; read cidr
        echo -n "Nouveau type (1: Machine, 2: Switch, 3: Serveur) : "; read type

        mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e"UPDATE Equipement SET nom='$nom', adMAC='$mac', adIP='$ip', CIDR=$cidr, idT=$type WHERE id=$id;"
        echo "L'équipement a été mis à jour."

        echo "Fermeture du programme."
        exit 0
    else
        echo "Option invalide."
    fi
done