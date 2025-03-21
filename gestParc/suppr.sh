#!/bin/bash

#import des configs et fonctions
source config.sh
echo suppr

# verifier la connexion et la selection de la BDD

mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi

echo -n "Donner l'ID de l'équipement à supprimer : "; read id

# affichage des infos avant suppression
mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM Equipement WHERE id=$id;"

# confirmation
echo -n "Es-tu sûr de vouloir supprimer cet équipement ? (o/n) : "
read confirmation

  # Suppression de données
  if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "DELETE FROM Equipement WHERE id=$id;"
        echo "L'équipement a été supprimé."
        else
    echo "Suppression annulée."
fi