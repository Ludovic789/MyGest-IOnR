#!/bin/bash

echo "=== Configuration de la base de données ==="
read -p "Nom d'utilisateur de la base de données : " db_user
read -sp "Mot de passe de la base de données : " db_pass
echo
read -p "Nom de la base de données : " db_name
read -p "Hôte de la base de données (ex: localhost) : " db_host
echo
read -p "Nom du dossier de réceptions des .txt : " db_file

# Génération initiale avec valeurs par défaut
serveur=1
machine=0

# Création du fichier config.sh
cat <<EOF > ./config.sh
#!/bin/bash
# fichier généré automatiquement

serveur=$serveur
machine=$machine

DB_USER="$db_user"
DB_PASSWORD="$db_pass"
DB_NAME="$db_name"
DB_HOST="$db_host"
DB_FILE="$db_file"
EOF

chmod +x config.sh
echo "Fichier config.sh généré avec succès."

# Choix Machine ou Serveur
echo ""
echo "=== Utilisation de la machine ==="
echo "1) Machine"
echo "2) Serveur"
read -p "Votre choix (1 ou 2) : " choix

if [ "$choix" == "1" ]; then
    sed -i 's/^serveur=.*/serveur=0/' config.sh
    sed -i 's/^machine=.*/machine=1/' config.sh
elif [ "$choix" == "2" ]; then
    sed -i 's/^serveur=.*/serveur=1/' config.sh
    sed -i 's/^machine=.*/machine=0/' config.sh
else
    echo "Choix invalide. Par défaut, configuration en 'Machine'."
    sed -i 's/^serveur=.*/serveur=0/' config.sh
    sed -i 's/^machine=.*/machine=1/' config.sh
fi

# Chargement de la config générée
source config.sh

echo ""
echo "=== Installation des éléments essentiels du programme ==="

# Installation de packets
if ! command -v figlet &> /dev/null; then
    echo "Installation de figlet..."
    sudo apt update && sudo apt install -y figlet
fi

if ! command -v lolcat &> /dev/null; then
    echo "Installation de lolcat..."
    sudo apt update && sudo apt install -y lolcat
fi

    echo "Installation de php-snmp..."
    sudo apt update && sudo apt install -y php-snmp

# Vérification et installation de MySQL
if ! command -v mysql &> /dev/null; then
    echo "MySQL n'est pas installé. Voulez-vous l'installer ? (o/n)"
    read choix_mysql
    if [ "$choix_mysql" == "o" ]; then
        sudo apt update && sudo apt install -y mysql-server
    else
        echo "Installation annulée."
        exit 1
    fi
fi

# Vérification et installation de SNMP
if ! command -v snmp &> /dev/null; then
    echo "Snmp n'est pas installé. Voulez-vous l'installer ? (o/n)"
    read choix_snmp
    if [ "$choix_snmp" == "o" ]; then
        sudo apt update && sudo apt install -y snmp
    else
        echo "Installation annulée."
        exit 1
    fi
fi

# Vérification des identifiants
if [[ -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DB_NAME" ]]; then
    echo "Erreur : Les identifiants MySQL ne sont pas correctement configurés."
    exit 1
fi

# Création utilisateur MySQL
echo "Création de l'utilisateur MySQL '$DB_USER'..."
sudo mysql -u root -p -e "
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

if [ $? -ne 0 ]; then
    echo "Erreur lors de la création de l'utilisateur MySQL."
    exit 1
fi

# Création de la base
echo "Création de la base de données $DB_NAME..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
if [ $? -ne 0 ]; then
    echo "Erreur lors de la création de la base de données."
    exit 1
fi

# Importation SQL
if [ -f "myGestIOnR.sql" ]; then
    echo "Importation de myGestIOnR.sql dans $DB_NAME..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < myGestIOnR.sql
    if [ $? -eq 0 ]; then
        echo "Base de données importée avec succès."
    else
        echo "Erreur lors de l'importation SQL."
    fi
else
    echo "Fichier myGestIOnR.sql introuvable."
fi

mkdir -p ./$DB_FILE
echo "Dossier $DB_FILE créé"

echo "Installation de apache2..."
sudo apt update && sudo apt install -y apache2 php libapache2-mod-php -y

echo ""
echo "Installation terminée."
