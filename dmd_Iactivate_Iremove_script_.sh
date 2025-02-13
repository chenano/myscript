#!/bin/bash

# 🔥 CONFIGURATION
LOG_FILE="/var/log/mdm_removal.log"
BACKUP_DIR="/tmp/mdm_backup_$(date +%Y%m%d_%H%M%S)"
MDM_SERVICE="/System/Library/LaunchDaemons/com.apple.mdmclient.plist"

clear
echo "========================================"
echo "  🔥 Suppression Automatisée du MDM 🔥  "
echo "========================================"
echo ""

# 🎯 Vérification des droits administrateurs
if [ "$EUID" -ne 0 ]; then
  echo "❌ Ce script doit être exécuté en tant que root (sudo)."
  exit 1
fi

# 🎯 Vérification du modèle du MacBook
MODEL=$(sysctl -n hw.model)
SUPPORTED_MODELS=("MacBookPro15,1" "MacBookPro15,2" "MacBookPro16,1" "MacBookPro16,2" "MacBookPro17,1" "MacBookPro18,1" "MacBookPro18,2" "MacBookPro18,3" "MacBookAir8,1" "MacBookAir8,2" "MacBookAir9,1" "MacBookAir10,1")
if [[ ! " ${SUPPORTED_MODELS[@]} " =~ " ${MODEL} " ]]; then
  echo "⚠️ Ce script est optimisé pour MacBook Pro & Air (2018 et +). Modèle détecté: $MODEL"
fi

# 🎯 Vérification et désactivation de Find My Mac
echo "🔍 Vérification de Find My Mac..."
FIND_MY_MAC_STATUS=$(sudo fdesetup status | grep "FileVault is On")
if [[ -n "$FIND_MY_MAC_STATUS" ]]; then
  echo "❌ Find My Mac est activé ! Désactive-le avant de continuer."
  exit 1
fi
echo "✅ Find My Mac est désactivé, continuation..."

# 🎯 Vérification de l'état MDM
check_mdm_status() {
  echo "🔍 Vérification du statut MDM..."
  if profiles status -type enrollment | grep -q "MDM enrollment"; then
    echo "✅ MDM détecté, suppression en cours..."
  else
    echo "ℹ️ Aucun profil MDM détecté. Arrêt du script."
    exit 0
  fi
}

# 🎯 Sauvegarde des fichiers MDM
backup_files() {
  echo "📂 Sauvegarde des fichiers MDM..."
  mkdir -p "$BACKUP_DIR"
  cp -r /var/db/ConfigurationProfiles/ "$BACKUP_DIR/"
  cp -r /Library/Managed Preferences/ "$BACKUP_DIR/"
  echo "✅ Sauvegarde terminée."
}

# 🎯 Suppression des profils MDM
remove_mdm_profiles() {
  echo "📌 Suppression des profils MDM..."
  profiles remove -all
  sleep 2
}

# 🎯 Désactivation complète du service MDM
disable_mdm_service() {
  echo "📌 Désactivation du service MDM..."
  if [ -f "$MDM_SERVICE" ]; then
    launchctl unload -w "$MDM_SERVICE"
    sleep 1
  fi
}

# 🎯 Suppression des fichiers de configuration MDM
remove_config_files() {
  echo "📌 Suppression des fichiers de configuration MDM..."
  rm -rf /var/db/ConfigurationProfiles/
  rm -rf /Library/Managed Preferences/
  rm -rf /var/db/ConfigurationProfiles/Settings.plist
  rm -rf /var/db/ConfigurationProfiles/Client
  sleep 1
}

# 🎯 Création d'un compte administrateur
create_admin_user() {
  echo "📌 Création d'un compte administrateur..."
  sysadminctl -addUser admin -fullName "Admin User" -password "1111" -admin
}

# 🎯 Vérification des utilisateurs existants
check_users() {
  echo "📌 Vérification des utilisateurs..."
  dscl . list /Users
}

# 🎯 Affichage de la progression
progress_bar() {
  for i in {10..100..10}; do
    echo -ne "🔄 Suppression en cours... $i%\r"
    sleep 0.5
  done
  echo -ne "\n"
}

# 🚀 Exécution des étapes
echo "⏳ Démarrage du processus de suppression..."
progress_bar
check_mdm_status
backup_files
remove_mdm_profiles
disable_mdm_service
remove_config_files
create_admin_user
check_users

# 🎯 Fin du processus
clear
echo "========================================"
echo "  ✅ Suppression du MDM réussie ✅   "
echo "========================================"
echo ""
echo "🔹 Identifiants d'accès :"
echo "   👤 Utilisateur : admin"
echo "   🔑 Mot de passe : 1111"
echo ""
echo "ℹ️ Veuillez redémarrer votre Mac maintenant."
echo "ℹ️ MDM a été entièrement supprimé."
echo ""
