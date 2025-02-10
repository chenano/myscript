#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for macOS"
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
        echo -e "${GRN}Create New User"
        echo -e "${BLU}Press Enter to continue to the next step, you can leave it blank for default values"
        echo -e "Enter username (Default: MAC)"
        read realName
        realName="${realName:=MAC}"
        echo -e "${BLUE}Enter username (write without spaces, Default: MAC)"
        read username
        username="${username:=MAC}"
        echo -e "${BLUE}Enter password (Default: 1234)"
        read passw
        passw="${passw:=1234}"
        dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
        echo -e "${GREEN}Creating user"
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
        echo -e "${GREEN}Host blocked successfully${NC}"
        touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        echo "----------------------"
        break
        ;;
    "Disable Notification (SIP)")
        echo -e "${RED}Please Enter Your Password To Proceed${NC}"
        # Without sudo, actions may require direct access to system files which is available in Recovery Mode.
        echo -e "${RED}This command should be executable in Recovery Mode.${NC}"
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
        echo -e "${RED}Please Enter Your Password To Proceed${NC}"
        echo ""
        # Check if sudo is needed (not required in Recovery Mode).
        echo -e "${RED}This command should be executable in Recovery Mode.${NC}"
        break
        ;;
    "Exit")
        break
        ;;
    *) echo "Invalid option $REPLY" ;;
    esac
done
