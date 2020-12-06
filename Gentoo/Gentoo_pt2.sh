## You can run   sed -i 's/s.wlp1s0/enps1/g' Gentoo_pt1.sh   to pick the correct NIC. Replace enps1 with your NIC.

source /etc/profile
export PS1="(chroot) ${PS1}"

emerge-webrsync -q
emerge --sync -q
emerge -q --update --deep --newuse @world
emerge -q app-editors/vim

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
make && make modules_install && make install
genkernel --install --kernel-config=/usr/src/linux/.config initramfs

echo "Gentoo" > /etc/conf.d/hostname

#Get your network interfaces.
# ifconfig | grep "flag"

echo 'config_wlp1s0="dhcp"' > /etc/conf.d/net

emerge -q net-misc/dhcpcd

cd /etc/init.d
ln -s net.lo net.wlp1s0
rc-update add net.wlp1s0 default


cd /
emerge -q sys-boot/grub:2
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

wget https://raw.githubusercontent.com/aantu014/Linux-Files/master/Gentoo/genfstab
chmod +x genfstab
./genfstab -p -U . >> /etc/fstab

emerge -q app-admin/sudo
