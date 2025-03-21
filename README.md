# MyGest IOn'R

## 📌 Présentation

**MyGest IOn'R** est un outil interactif en ligne de commande destiné à la **gestion de parc informatique** et à l'**utilisation d'outils réseau**, développé en **Bash** et basé sur une base de données **MySQL**. Il offre une interface simple et intuitive permettant d’ajouter, modifier, consulter ou supprimer des équipements, mais aussi de réaliser des opérations réseau comme tester des adresses IP ou ports.

Ce projet a été conçu dans le cadre d’un projet pédagogique pour un étudiant en **BTS SIO option SISR**.

---

## ⚙️ Fonctionnalités

### 1. Menu principal
- Accès à la **gestion du parc**
- Accès aux **outils réseau**

### 2. Gestion du parc informatique
- Consulter les équipements
- Ajouter un nouvel équipement
- Supprimer un équipement
- Modifier les informations d’un équipement

### 3. Outils réseau
- Test de connectivité IP (ping)
- Test de port TCP (netcat)
- Vérification des IP actives
- Génération d'un fichier contenant les IP stockées
- Interroge un switch SNMP
- Configurer l'IP du switch/routeur
- Accéder à la gestion du switch SNMP (Pas fini)

---

## 🧱 Structure du projet

```
.
├── myGestIOnR.sh         # Lancement principal du programme
├── config.sh             # Fichier de configuration (utilisateur, base)
├── install.sh            # Script d'installation
├── fonction.sh           # Fonctions utilitaires (ex: titres stylisés)
├── gestParc/
│   ├── menuParc.sh       # Menu gestion du parc
│   ├── ajout.sh          # Ajout d’un équipement
│   ├── modif.sh          # Modification d’un équipement
│   ├── suppr.sh          # Suppression d’un équipement
│   └── affiche.sh        # Affichage des équipements
├── outilsRx/
│   ├── menuOutils.sh     # Menu outils réseau
│   ├── testIP.sh         # Ping d'une adresse IP
│   ├── testTCP.sh        # Test d’un port TCP
│   ├── checkValid.sh     # Vérification d'adresses IP
│   └── generTxt.sh       # Génération d’un .txt d’IP
└── myGestIOnR.sql        # Script SQL de la base de données
```

---

## 💾 Base de données

Le fichier `myGestIOnR.sql` contient la structure nécessaire à la base de données. Elle comprend au minimum :

- Une table `Equipement` contenant :
  - `id` (int)
  - `nom` (varchar)
  - `adMAC` (varchar)
  - `adIP` (varchar)
  - `CIDR` (int)
  - `idT` (type d’équipement : 1=Machine, 2=Switch, 3=Serveur)

---

## 🛠️ Installation


1. **Lancer le script d'installation**
   ```bash
   ./install.sh
   ```

2. **Lancer le programme**
   ```bash
   ./myGestIOnR.sh
   ```

---

## 📌 Pré-requis

- GNU/Linux
- `bash`, `mysql`, `figlet`, `lolcat`, `netcat`, `ping`
- Droits d'accès à un serveur MySQL

---

## 👤 Auteur

Projet réalisé dans le cadre d’un BTS SIO SISR  
**Année :** 2024-2025

---
