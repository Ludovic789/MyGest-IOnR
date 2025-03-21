#!/bin/bash

#import des configs et fonctions
source config.sh
echo testIP

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi

read -p "Entrez une adresse IP : " ip

# Vérification du format de l'adresse IP
if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Adresse IP invalide : $ip"
    exit 1
fi

# Vérification des valeurs des octets (0-255)
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"
if (( o1 < 0 || o1 > 255 || o2 < 0 || o2 > 255 || o3 < 0 || o3 > 255 || o4 < 0 || o4 > 255 )); then
    echo "Adresse IP invalide : $ip"
    exit 1
fi

# Vérifier si l'IP répond au ping et mettre à jour la base de données
if ping -c 1 "$ip" > /dev/null 2>&1; then
    echo "L'adresse IP $ip répond au ping, mise à jour dans la base de données..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
        UPDATE Equipement 
        SET active=1 
        WHERE adIP='$ip' AND EXISTS (SELECT 1 FROM Equipement WHERE adIP='$ip');
    "
    echo "L'adresse IP $ip est maintenant active."
else
    echo "L'adresse IP $ip ne répond pas au ping, mise à jour dans la base de données..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "
        UPDATE Equipement 
        SET active=0 
        WHERE adIP='$ip' AND EXISTS (SELECT 1 FROM Equipement WHERE adIP='$ip');
    "
    echo "L'adresse IP $ip est maintenant inactive."
fi
