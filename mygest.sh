#!/bin/bash

USER="u1"                 
DATABASE="MyGest"        

# verifier la connexion et la selection de la BDD

mysql -u $USER -p -D $DATABASE -e "SELECT DATABASE();" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DATABASE."
    exit 1
fi

# Affichage du menu principal
while true; do
    echo "Menu Gestion du Parc :"
    echo "1) Consulter les données"
    echo "2) Ajouter des données"
    echo "3) Supprimer des données"
    echo "4) Modifier des données"
    echo "0) Quitter"
    echo -n "Veuillez choisir une option : "
    read choix

    if [ "$choix" -eq 1 ]; then
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
            1) mysql -u $USER -p -D $DATABASE -e "SELECT * FROM Equipement;" ;;
            2) mysql -u $USER -p -D $DATABASE -e "SELECT * FROM Equipement WHERE idT=1;" ;;
            3) mysql -u $USER -p -D $DATABASE -e "SELECT * FROM Equipement WHERE idT=3;" ;;
            4) mysql -u $USER -p -D $DATABASE -e "SELECT * FROM Equipement WHERE idT=2;" ;;
            0) continue ;;
            *) echo "Option invalide." ;;
        esac

    elif [ "$choix" -eq 2 ]; then
        # Ajout de données
        echo -n "Nom : "; read nom
        echo -n "Adresse MAC : "; read mac
        echo -n "Adresse IP : "; read ip
        echo -n "Masque (CIDR) : "; read cidr
        echo -n "Type (1: Machine, 2: Switch, 3: Serveur) : "; read type

        query="INSERT INTO Equipement (nom, adMAC, adIP, CIDR, idT) VALUES ('$nom', '$mac', '$ip', $cidr, $type);"
        mysql -u $USER -p -D $DATABASE -e "$query"
        echo "L'équipement a été ajouté."

    elif [ "$choix" -eq 3 ]; then
        # Suppression de données
        echo -n "Donner l'ID de l'équipement à supprimer : "; read id
        mysql -u $USER -p -D $DATABASE -e "DELETE FROM Equipement WHERE id=$id;"
        echo "L'équipement a été supprimé."

    elif [ "$choix" -eq 4 ]; then
        # Modification de données
        echo -n "Donner l'ID de l'équipement à modifier : "; read id
        echo -n "Nouveau nom : "; read nom
        echo -n "Nouvelle adresse MAC : "; read mac
        echo -n "Nouvelle adresse IP : "; read ip
        echo -n "Nouveau masque (CIDR) : "; read cidr
        echo -n "Nouveau type (1: Machine, 2: Switch, 3: Serveur) : "; read type

        query="UPDATE Equipement SET nom='$nom', adMAC='$mac', adIP='$ip', CIDR=$cidr, idT=$type WHERE id=$id;"
        mysql -u $USER -p -D $DATABASE -e "$query"
        echo "L'équipement a été mis à jour."

    elif [ "$choix" -eq 0 ]; then
        echo "Fermeture du programme."
        exit 0
    else
        echo "Option invalide."
    fi

    echo -n "[Appuyer sur Entrée pour continuer]"
    read
done
