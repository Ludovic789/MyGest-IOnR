#!/bin/bash

# Import des configs et fonctions
source config.sh
echo "checkValid"

# Vérifier la connexion à la base de données
mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi

# Récupération des adresses IP et de leur état sous un format sûr
IP_LIST=$(mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -se "SELECT adIP, active FROM Equipement;")

# Vérification si des adresses IP ont été trouvées
if [ -z "$IP_LIST" ]; then
    echo "Aucune adresse IP trouvée dans la base de données."
    exit 1
fi

# Création du fichier de rapport
OUTPUT_FILE="./$DB_FILE/ip_status.txt"
echo "Rapport IP - État BDD et Ping" > "$OUTPUT_FILE"
echo "--------------------------------" >> "$OUTPUT_FILE"

# Lecture et test des IP
echo "Vérification des équipements..."
while IFS=$'\t' read -r IP STATUS; do
    if [[ -z "$IP" || -z "$STATUS" ]]; then
        echo "Erreur: Donnée invalide détectée."
        continue
    fi

    # Vérification stricte du statut (Doit être 0 ou 1)
    if ! [[ "$STATUS" =~ ^[01]$ ]]; then
        echo "Erreur: Valeur inattendue pour STATUS ($STATUS) sur IP $IP"
        continue
    fi

    # Test avec ping
    if ping -c 1 -W 1 "$IP" > /dev/null 2>&1; then
        echo -e "\e[32m$IP - ACTIVE (BDD:$STATUS) | Ping OK\e[0m"
        echo "$IP - ACTIVE (BDD:$STATUS) | Ping OK" >> "$OUTPUT_FILE"

        # Mise à jour BDD si nécessaire
        if [ "$STATUS" -eq 0 ]; then
            echo "Mise à jour: $IP → ACTIVE"
            mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "UPDATE Equipement SET active=1 WHERE adIP='$IP';"
        fi
    else
        echo -e "\e[31m$IP - INACTIVE (ping) | Mise à jour BDD\e[0m"
        echo "$IP - INACTIVE (ping) | Mise à jour BDD" >> "$OUTPUT_FILE"

        # Mise à jour BDD si nécessaire
        if [ "$STATUS" -eq 1 ]; then
            mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "UPDATE Equipement SET active=0 WHERE adIP='$IP';"
        fi
    fi
done <<< "$IP_LIST"

echo "Rapport généré dans $OUTPUT_FILE"
