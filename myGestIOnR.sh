#!/bin/bash

#import des configs et fonctions
source config.sh
source fonction.sh

echo "Bienvenu dans :"
afficheTitre "MyGest IOn ' R"
quitter=1
while [[ $quitter -ne 0 ]]
do
    echo ""
    afficheTitre "Menu principal"

    if (( $serveur == 1 )); then
        echo "1) Gestion du parc"
    else
        echo "1) Outils réseau"
    fi
    echo "2) Réinstaller / Configurer"
    echo "0) Quitter"
    echo -e "Veuillez choisir une option :"
    read choix

    case $choix in 
        1 )
            if (( $serveur == 1 )); then
                bash gestParc/menuParc.sh
            else
                bash outilsRx/menuOutils.sh
            fi
            ;;
        2 )
            bash install/install.sh
            ;;
        0 )
            exit 0
            figlet "Au revoir" | lolcat
            ;;
        * )
            echo "Erreur dans la saisie"
            ;;
    esac
done
