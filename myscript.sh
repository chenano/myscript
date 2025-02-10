#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for MacOS Sonoma"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery" "Disable Notification (SIP)" "Disable Notification (Recovery)" "Check MDM Enrollment" "Exit")
select opt in "${options[@]}"; do
    case $opt in
    "Bypass on Recovery")
        echo -e "${GRN}Bypass on Recovery"
        if [ -d "/Volumes/Macintosh HD - Data" ]; then
            diskutil rename "Macintosh HD - Data" "Data"
        fi
        echo -e "${GRN}Creating new user"
        echo -e "${BLU}Press Enter to proceed, you can leave fields blank for default values"
        echo -e "Enter username (default: MAC)"
        read realName
        realName="${realName:=MAC}"
        echo -e "${BLU}Enter username (no spaces, default: MAC)"
        read username
        username="${username:=MAC}"
        echo -e "${BLU}Enter password (default: 1234)"
        read passw
        passw="${passw:=1234}"
        dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
        echo -e "${GRN}Creating user"
        # Create user
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
        mkdir "/Volumes/Data/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
        dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
        dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
        echo "0.0.0.0 deviceenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
        echo "0.0.0.0 mdmenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
        echo "0.0.0.0 iprofiles.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
        echo -e "${GRN}Hosts successfully blocked${NC}"
        touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        echo "----------------------"
        break
        ;;
    "Disable Notification (SIP)")
        echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Check MDM Enrollment")
        echo ""
        echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
        echo ""
        echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        echo ""
        # Check MDM status (only works if "profiles" is available)
        profiles show -type enrollment
        break
        ;;
    "Exit")
        break
        ;;
    *) echo "Invalid option $REPLY" ;;
    esac
done
