#!/bin/bash

# Définition des chemins
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEB_DIR="/var/www/html/outilsRx"
APACHE_USER="www-data"

echo "Création du dossier /var/www/html/outilsRx..."
mkdir -p "$WEB_DIR"

echo "Copie du fichier switch-snmp.php..."
cp "$SOURCE_DIR/switch-snmp.php" "$WEB_DIR/"

echo "Définition des permissions..."
chmod -R 755 "$WEB_DIR"
chown -R "$APACHE_USER:$APACHE_USER" "$WEB_DIR"

echo "Redémarrage d'Apache..."
systemctl restart apache2

echo "Déploiement terminé."
echo "Accédez à : http://localhost/outilsRx/switch-snmp.php"
