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

apt install --no-install-recommends locales

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

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


cd /etc/kernel/postinst.d/
curl -O https://raw.githubusercontent.com/aantu014/Linux-Files/master/Debian/zz-update-systemd-boot
chmod +x zz-update-systemd-boot

#Run Script
./zz-update-systemd-boot


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
adduser $user
usermod -aG sudo $user

apt install --no-install-recommends xserver-xorg-input-libinput xinit xserver-xorg-core x11-xserver-utils \
libavcodec58 firefox-esr neofetch git alsa-utils nitrogen maim stterm suckless-tools dwm sudo \
network-manager iputils-ping iproute2 ca-certificates curl less xcompmgr x11-apps

#Network firmware
#apt install --no-install-recommends firmware-atheros firmware-realtek

#Graphics firmware
#apt install --no-install-recommends firmware-amd-graphics

echo "Uncomment '%sudo' in sudo. Press enter to continue."
read continue

vim /etc/sudoers

echo "rmmod pcspkr" > /etc/modprobe.d/blacklist
echo "dmesg -n 1" > /etc/rc.local
echo "exec dwm" > ~/.xinitrc
echo "startx" >> ~/.bash_profile
