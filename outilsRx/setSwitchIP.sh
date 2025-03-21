#!/bin/bash

CONFIG_FILE="../configSwitch.txt"

# Vérifier si le fichier existe, sinon le créer
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
    echo "Fichier $CONFIG_FILE créé."
fi

echo "Entrez l'adresse IP du switch (ex: 192.168.1.1) :"
read ip
echo "$ip" > "$CONFIG_FILE"

echo "IP du switch enregistrée : $ip"
echo "Vous pouvez maintenant accéder à la page web via Outils Réseau."
