#Get ip and netowrk interface
##ifconfig##

# Set up networking
# net-setup wlp1s0

#If boot from usb install and have extra pc run
#/etc/init.d/sshd start##
##passwd##

#From other pc replace ip with your own
##ssh root@10.0.0.10##

#cfdisk /dev/sda
#You can run   sed -i 's/sda/sdc/g' Gentoo_pt1.sh   to replce with disck you want to install on. Replace sdc witht the device you want.

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


mkdir /mnt/gentoo/



mount /dev/sda3 /mnt/gentoo/
mkdir /mnt/gentoo/usr
mkdir /mnt/gentoo/var
mkdir /mnt/gentoo/tmp
mkdir /mnt/gentoo/home
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi

mount /dev/sda4 /mnt/gentoo/usr
mount /dev/sda5 /mnt/gentoo/var
mount /dev/sda6 /mnt/gentoo/tmp
mount /dev/sda7 /mnt/gentoo/home
mount /dev/sda1 /mnt/gentoo/boot/efi

# Replace with Updated archive link on https://www.gentoo.org/downloads/
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20201206T214503Z/stage3-amd64-nomultilib-20201206T214503Z.tar.xz

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

##You are now in Gentoo Enirontment now download second part of script and runit ;)
