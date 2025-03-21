#!/bin/bash

#import des configs et fonctions
source config.sh
echo generTxt

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi

# Nom du fichier de sortie
OUTPUT_FILE="./$DB_FILE/ip_list.txt"

# Récupération des adresses IP depuis la base de données et écriture dans un fichier .txt
mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -sN -e "SELECT adIP FROM Equipement;" > "$OUTPUT_FILE"

# Vérification si le fichier a été généré
if [ -s "$OUTPUT_FILE" ]; then
    echo "Fichier $OUTPUT_FILE généré avec succès !"
else
    echo "Erreur : Aucune adresse IP trouvée dans la base de données."
fi