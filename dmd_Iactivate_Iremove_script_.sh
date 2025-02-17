dscl . create /Users/admin
dscl . create /Users/admin UserShell /bin/bash
dscl . create /Users/admin RealName "Admin User"
dscl . create /Users/admin UniqueID 510
dscl . create /Users/admin PrimaryGroupID 20
dscl . create /Users/admin NFSHomeDirectory /Users/admin
dscl . passwd /Users/admin 1111
dscl . append /Groups/admin GroupMembership admin
