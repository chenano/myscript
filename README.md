# README - MacBook Pro & Air MDM Bypass Script

## 📌 Introduction
This script is designed to **automatically remove MDM (Mobile Device Management)** from **MacBook Pro & Air (2018 and later, including T2, M1, M2, M3)**. It mimics the functionality of iActivate, making the process fully automated with **no user intervention required**.

## ⚠️ Prerequisites
Before running the script, ensure the following conditions are met:
- **Find My Mac is disabled** (mandatory for MDM removal).
- **You have administrative/root access** to the Mac.
- **SIP (System Integrity Protection) is disabled** (run `csrutil disable` in Recovery Mode).
- **You are connected to the Internet** (recommended but not mandatory).

## 🔧 Supported Mac Models
This script works on the following models:
- **MacBook Pro** (2018 and later)
- **MacBook Air** (2018 and later)
- **Macs with T2, M1, M2, M3 chips**

## 🚀 How to Use
### **Step 1: Download and Prepare the Script**
1. Download the script and save it to your Mac.
2. Open Terminal and navigate to the script location.
   ```bash
   cd /path/to/script
   ```
3. Make the script executable:
   ```bash
   sudo chmod +x mdm_removal_final.sh
   ```

### **Step 2: Run the Script**
Execute the script with root privileges:
```bash
sudo ./mdm_removal_final.sh
```

### **Step 3: Wait for Completion**
- The script will automatically:
  - Check for **Find My Mac** status.
  - Detect and backup existing **MDM profiles**.
  - Remove all **MDM-related restrictions**.
  - Disable **MDM services**.
  - Create a new **admin user (admin / 1111)**.
  - Provide a **progress bar for status updates**.
  
### **Step 4: Restart Your Mac**
- Once the script completes, **restart the Mac manually**.
- Login using:
  - **Username:** `admin`
  - **Password:** `1111`
- **MDM will be completely removed.** 🎯🔥

## 🛠️ Features & Improvements
- ✅ **Fully Automated Process** (No user intervention)
- ✅ **Works on macOS Sonoma, Ventura, and later**
- ✅ **Find My Mac verification & alert**
- ✅ **Progress bar animation for a smooth experience**
- ✅ **No need for third-party software**

## 📜 Logs & Debugging
- All actions are logged to `/var/log/mdm_removal.log`.
- If you encounter issues, check the logs:
  ```bash
  cat /var/log/mdm_removal.log
  ```

## ⚠️ Disclaimer
This script is provided **for educational purposes only**. The use of this script **should comply with all local laws and policies**. Unauthorized use on devices **not owned by you** may be illegal.

## 💡 Need Help?
For additional support, feel free to contact experts or check online macOS administration guides.

---
Enjoy your **MDM-Free Mac**! 🚀🔥

