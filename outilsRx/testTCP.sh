#!/bin/bash

# Import des configs et fonctions
source config.sh
echo "testTCP"

# Vérifier la connexion et la sélection de la BDD
mysql -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "USE $DB_NAME;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Erreur : Impossible de se connecter à la base de données $DB_NAME."
    exit 1
fi

# Demande de l'adresse IP et du port à tester
read -p "Entrez une adresse IP : " adresse_ip
read -p "Entrez un numéro de port : " port

# Vérification de l'adresse IP
if [[ $adresse_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    IFS='.' read -r -a octets <<< "$adresse_ip"
    if [[ ${octets[0]} -le 255 && ${octets[1]} -le 255 && ${octets[2]} -le 255 && ${octets[3]} -le 255 ]]; then
        echo "L'adresse IP est valide."
    else
        echo "Erreur : L'adresse IP contient des octets hors limites."
        exit 1
    fi
else
    echo "Erreur : Format d'adresse IP incorrect."
    exit 1
fi

# Ping pour tester si la machine est accessible
if ! ping -c 1 -W 1 "$adresse_ip" > /dev/null 2>&1; then
    echo "Erreur : L'adresse IP $adresse_ip ne répond pas au ping."
    exit 1
fi

# Vérification du port
if [[ ! $port =~ ^[0-9]+$ ]] || [[ $port -lt 1 ]] || [[ $port -gt 65535 ]]; then
    echo "Erreur : Numéro de port invalide. Il doit être compris entre 1 et 65535."
    exit 1
fi

# Vérifier si le port est listé dans /etc/services comme un port UDP
is_udp=$(grep -w "$port" /etc/services | grep "udp")

if [ -n "$is_udp" ]; then
    echo "Attention : Le port $port est un port UDP et non un port TCP."
    exit 1
fi

# Tester le port sur l'adresse IP donnée
if nc -zv "$adresse_ip" "$port" > /dev/null 2>&1; then
    echo "Le port TCP $port de l'adresse IP $adresse_ip est ouvert."
else
    echo "Le port TCP $port de l'adresse IP $adresse_ip n'est pas ouvert."
fi

echo "Test terminé."
