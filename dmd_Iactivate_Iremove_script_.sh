#!/bin/bash

# Monter le disque en écriture
mount -uw /

# Démarrer le service Open Directory (indispensable)
launchctl load /System/Library/LaunchDaemons/com.apple.opendirectoryd.plist

# Créer un nouvel utilisateur admin
dscl . create /Users/admin
dscl . create /Users/admin UserShell /bin/bash
dscl . create /Users/admin RealName "Admin User"
dscl . create /Users/admin UniqueID 510
dscl . create /Users/admin PrimaryGroupID 20
dscl . create /Users/admin NFSHomeDirectory /Users/admin
dscl . passwd /Users/admin 1111
dscl . append /Groups/admin GroupMembership admin

# Créer le dossier utilisateur
mkdir /Users/admin
chown -R admin:staff /Users/admin

# Vérifier si la suppression du MDM est complète
profiles status -type enrollment

# Redémarrer pour appliquer les changements
echo "✅ Utilisateur créé avec succès. Redémarrage en cours..."
