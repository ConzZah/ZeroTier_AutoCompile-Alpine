#!/usr/bin/env bash
  #================================================
  # Project: ZeroTier_AutoCompile-Alpine.sh
  # Author:  ConzZah / ©️ 2024
  # Last Modification: 18.06.2024 / 15:32 [v0.1]
  #================================================
wd=$(pwd); cd /home/$USER; mkdir -p ZeroTier_AutoCompile-Alpine; cd ZeroTier_AutoCompile-Alpine
doas apk add git wget build-base clang rust cargo make linux-headers openssl-dev nodejs nodejs-dev # installs dependencies for zerotier compilation
git clone https://github.com/zerotier/ZeroTierOne; cd ZeroTierOne # clones zerotier-one from github
doas make && echo ""; echo "DONE COMPILING!"; echo "" # runs make and shows message when done
doas make install && echo ""; echo "DONE INSTALLING, SETTING UP INIT SCRIPT.."; echo "" # runs make install and shows message when done
cd /home/$USER; doas rm -rf ZeroTier_AutoCompile-Alpine # removes working dir to save space since the binaries are compiled & installed by that point
cd /etc/init.d; doas wget -q -O zerotier-one https://raw.githubusercontent.com/ConzZah/ZeroTier_AutoCompile-Alpine/main/zerotier-one.initd; doas chmod 755 zerotier-one; cd $wd # installs init script
echo "tun" > zerotier-one.conf; doas mv -f zerotier-one.conf /usr/lib/modules-load.d/; doas modprobe tun; lsmod | grep tun
doas rc-update add zerotier-one; doas rc-service zerotier-one start # adds zerotier-one service and starts it. 
doas zerotier-one -d >/dev/null 2>&1
sleep 3; echo ""; echo ""; echo "[ PRESS ANY KEY TO REBOOT ]"; read -n 1 -s
doas reboot
