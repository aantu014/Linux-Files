echo "Kali.localdomain" > /etc/hostname
cat <<EOF> /etc/hosts
127.0.0.1	 localhost
::1		 localhost
127.0.1.1	 Kali.localdomain		Kali
EOF

cat <<EOF> /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main contrib non-free
EOF

echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" > /etc/environment

apt update

apt update && apt upgrade --no-install-recommends

apt install --no-install-recommends kali-archive-keyring vim systemd

apt install --no-install-recommends locales && dpkg-reconfigure locales

dpkg-reconfigure tzdata

apt install --no-install-recommends linux-image-amd64

cd /boot/efi
mkdir -p loader/entries
mkdir kali

cat <<EOF> /boot/efi/loader/loader.conf
default kali
timeout 3
editor 0
EOF

#Run Script
./etc/kernel/postinst.d/zz-update-systemd-boot


# One for the kernel's postrm:
cd /etc/kernel/postrm.d/ && ln -s ../postinst.d/zz-update-systemd-boot zz-update-systemd-boot

# Note: Ubuntu does not usually create the necessary hook folder
# for initramfs, so the next line will take care of that if
# needed. (And yes, it *is* supposed to be "initramfs" and not
# "initramfs-tools"!)
[ -d "/etc/initramfs/post-update.d" ] || mkdir -p /etc/initramfs/post-update.d

# And now we can add the symlink:
cd /etc/initramfs/post-update.d/ && ln -s ../../kernel/postinst.d/zz-update-systemd-boot zz-update-systemd-boot

###systemd-boot install:
bootctl install --path=/boot/efi

###Update bootloader

#bootctl update

###Root password:
passwd

echo "Enter new user name:"
read user
useradd -m -g sudo -s /bin/bash $user
passwd $user

apt install --no-install-recommends xserver-xorg-input-libinput xinit xserver-xorg-core firefox-esr neofetch git alsa-utils sxiv nitrogen maim stterm dwm sudo network-manager iputils-ping iproute2

echo "Uncomment '%sudo' in sudo. Press enter to continue."
read continue

vim /etc/sudoers

echo "exec dwm" > ~/.xinitrc
echo "startx" >> ~/.bash_profile
