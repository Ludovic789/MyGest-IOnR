#!/bin/bash

#import des configs et fonctions
source config.sh
echo ajout

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi
        # Ajout de données
        echo -n "Nom : "; read nom

# Vérification de l'adresse MAC
while true; do
    echo -n "Adresse MAC : "; read mac
    if [[ $mac =~ ^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$ ]]; then
        break
    else
        echo "Adresse MAC invalide. Exemple valide : AA:BB:CC:DD:EE:FF"
    fi
done

# Vérification de l'adresse IP
while true; do
    echo -n "Adresse IP : "; read ip

    # Vérification du format
    if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "Format IP invalide. Exemple valide : 192.168.1.1"
        continue
    fi

    # Vérification des valeurs des octets
    IFS='.' read -r o1 o2 o3 o4 <<< "$ip"
    if (( o1 < 0 || o1 > 255 || o2 < 0 || o2 > 255 || o3 < 0 || o3 > 255 || o4 < 0 || o4 > 255 )); then
        echo "Adresse IP invalide : chaque octet doit être entre 0 et 255"
        continue
    fi

    # Si tout est bon, on sort de la boucle
    break
done   
        echo -n "Masque (CIDR) : "; read cidr
        echo -n "Type (1: Machine, 2: Switch, 3: Serveur) : "; read type

        mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "INSERT INTO Equipement (nom, adMAC, adIP, CIDR, idT) VALUES ('$nom', '$mac', '$ip', $cidr, $type);"
        echo "L'équipement a été ajouté."
        