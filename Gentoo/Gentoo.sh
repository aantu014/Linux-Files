#If boot from usb install and have extra pc run
#/etc/init.d/sshd start##
##passwd##

#Get ip
##ifconfig##

#From other pc replace ip with your own
##ssh root@10.0.0.10##

#cfdisk /dev/sda

#Device                         Start                End            Sectors          Size Type

#/dev/sda1                       2048            1026047            1024000          500M EFI System                  
#/dev/sda2                    1026048            3123199            2097152            4G Linux swap
#/dev/sda3                    3123200          104857566          101734367           30G Linux filesystem
#/dev/sda4                    3123200          104857566          101734367           30G Linux filesystem
#/dev/sda5                    3123200          104857566          101734367           30G Linux filesystem
#/dev/sda6                    3123200          104857566          101734367            2G Linux filesystem
#/dev/sda7                    3123200          104857566          101734367          250G Linux filesystem

mkfs.vfat -F32 -n EFIBOOT /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 -L genroot /dev/sda3
mkfs.ext4 -L genusr /dev/sda4
mkfs.ext4 -L genvar /dev/sda5
mkfs.ext4 -L gentmp /dev/sda6
mkfs.ext4 -L genhome /dev/sda7


mkdir /dev/sda3 /mnt/gentoo/
mkdir /dev/sda4 /mnt/gentoo/usr
mkdir /dev/sda5 /mnt/gentoo/var
mkdir /dev/sda6 /mnt/gentoo/tmp
mkdir /dev/sda7 /mnt/gentoo/home
mkdir /mnt/gentoo/boot/efi


mount /dev/sda3 /mnt/gentoo/
mount /dev/sda4 /mnt/gentoo/usr
mount /dev/sda5 /mnt/gentoo/var
mount /dev/sda6 /mnt/gentoo/tmp
mount /dev/sda7 /mnt/gentoo/home
mount /dev/sda1 /mnt/gentoo/boot/efi

# Update archive link on https://www.gentoo.org/downloads/
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20201202T214503Z/hardened/stage3-amd64-hardened+nomultilib-20201202T214503Z.tar.xz

mv *.tar.xz /mnt/gentoo/

cd /mnt/gentoo/
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
rm mv *.tar.xz

wget https://raw.githubusercontent.com/aantu014/Linux-Files/master/Gentoo/make.conf
cat make.conf > /mnt/gentoo/etc/portage/make.conf
rm make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/


mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev 

# If not using Gentoo iso
#test -L /dev/shm && rm /dev/shm && mkdir /dev/shm 
#mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
#chmod 1777 /dev/shm

chroot /mnt/gentoo /bin/bash
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

emerge -q --autounmask-continue sys-kernel/gentoo-sources sys-kernel/genkernel


emerge -q --autounmask-continue sys-kernel/gentoo-sources sys-kernel/genkernel

#Configure kernel but look for tutorials.
cd /usr/src/linux
make menuconfig
make && make modules_install && make install
genkernel --install --kernel-config=/usr/src/linux/.config initramfs

echo "Gentoo" > /etc/conf.d/hostname

#Get your network interfaces.
# ifconfig | grep "flag"

echo 'config_enp0s3="dhcp"' > /etc/conf.d/net

emerge -q net-misc/dhcpcd

cd /etc/init.d
ln -s net.lo net.enp0s3
rc-update add net.enp0s3 default


cd /
emerge -q sys-boot/grub:2
grub-install --target=x86_64-efi --efi-directory=/boot

wget https://raw.githubusercontent.com/aantu014/Linux-Files/master/Gentoo/genfstab
chmod +x genfstab
./genfstab -p -U . >> /etc/fstab

emerge -q app-admin/sudo
