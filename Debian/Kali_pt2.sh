echo "Kali.localdomain" > /etc/hostname
cat <<EOF> /etc/hosts
127.0.0.1	 localhost
::1		 localhost
127.0.1.1	 Kali.localdomain		Kali
EOF

cat <<EOF> /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main contrib non-free
EOF


apt update

apt update && apt upgrade --no-install-recommends

apt install --no-install-recommends kali-archive-keyring vim systemd

apt install --no-install-recommends locales && dpkg-reconfigure locales

dpkg-reconfigure tzdata

apt install --no-install-recommends linux-image-amd64

vim /etc/mkinitcpio.conf

###HOOKS=(base systemd autodetect modconf block keyboard sd-vconsole filesystems shutdown)###
###Exeucte mkinitcpio
mkinitcpio -p linux-lts
###systemd-boot install:
bootctl install
###Edit the loader.conf file in the /boot/loader directory:
cat <<EOF> /boot/loader/loader.conf
timeout 3
#console-mode keep
default arch-*
editor no
EOF
###Copy the arch.conf file to the  entries directory:

cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/
###Edit the details for the arch.conf file:
cat <<EOF> /boot/loader/entries/arch.conf
title Kali Linux
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=LABEL=kaliroot rw
EOF
###Update bootloader

bootctl update

###Root password:
passwd

echo "Enter new user name:"
read user
useradd -m -g sudo -s /bin/bash $user
passwd $user

apt install --no-install-recommends xserver-xorg-input-libinput xinit xserver-xorg-core firefox-esr neofetch git alsa-utils sxiv nitrogen stterm dwm sudo network-manager

echo "Uncomment '%sudo' in sudo. Press enter to continue."
read continue

vim /etc/sudoers

echo "exec dwm" > ~/.xinitrc
echo "startx" >> ~/.bash_profile
