## You can run   sed -i 's/wlp1s0/enp0s3/g' Gentoo_pt2.sh   to pick the correct NIC. Replace enps1 with your NIC.
## eth0 wlan0
source /etc/profile
export PS1="(chroot) ${PS1}"

emerge-webrsync -q

#emerge --autounmask-continue --quiet --update --deep --newuse @world

#echo 'USE="${USE} libressl"' >> /etc/portage/make.conf
#echo 'CURL_SSL="libressl"' >> /etc/portage/make.conf
#mkdir -p /etc/portage/profile
#printf "-libressl\n" >> /etc/portage/profile/use.stable.mask
#echo "dev-libs/openssl" >> /etc/portage/package.mask
#echo "dev-libs/libressl" >> /etc/portage/package.accept_keywords
#emerge -f libressl
#emerge -C openssl
#emerge -1q libressl


emerge --deselect app-editors/nano
emerge --depclean -q
emerge -q --update --deep --newuse @world
emerge -q app-editors/vim
#emerge -q sys-kernel/linux-firmware

#Pick zone replce time zone with yours
#ls /usr/share/zoneinfo
#ls /usr/share/zoneinfo/America/
echo "America/New_York" > /etc/timezone
emerge --config sys-libs/timezone-data

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set 4

env-update && source /etc/profile && export PS1="(chroot) ${PS1}"


emerge -q --autounmask-continue sys-kernel/gentoo-sources sys-kernel/genkernel

#Configure kernel but look for tutorials.
cd /usr/src/linux
make menuconfig
make localmodconfig
make && make modules_install && make install
genkernel --install --kernel-config=/usr/src/linux/.config initramfs

sed -i -e "s/localhost/Gentoo" /etc/conf.d/hostname
emerge --noreplace net-misc/netifrc
#Get your network interfaces.
# ifconfig | grep "flag"

#echo 'config_wlp1s0="dhcp"' > /etc/conf.d/net

emerge -q net-misc/dhcpcd

cd /etc/init.d
ln -s net.lo net.wlp1s0
rc-update add net.wlp1s0 default


cd /
emerge -q sys-boot/grub:2
#grub-install --target=x86_64-efi --efi-directory==/boot/efi
#If installing to usb or external hardrive comment above line and uncomment the line below.
grub-install --efi-directory=/boot/efi --target=x86_64-efi --removable
grub-mkconfig -o /boot/grub/grub.cfg


wget https://raw.githubusercontent.com/aantu014/Linux-Files/master/Gentoo/genfstab
chmod +x genfstab
./genfstab -p -U . >> /etc/fstab

cat <<EOF>> /etc/fstab

shm                     /dev/shm        tmpfs           nodev,nosuid,noexec     0 0
EOF

emerge -q --autounmask-continue app-admin/doas x11-drivers/xf86-input-libinput media-sound/alsa-utils net-wireless/wpa_supplicant
#emerge -q --autounmask-continue net-misc/networkmanager

#for x in /etc/runlevels/default/net.* ; do rc-update del $(basename $x) default ; rc-service --ifstarted $(basename $x) stop; done
#rc-update del dhcpcd default
#rc-update add NetworkManager default
rc-update add dbus default
passwd
