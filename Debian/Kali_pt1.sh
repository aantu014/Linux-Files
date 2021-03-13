#!/bin/bash

#cfdisk /dev/sda
#You can run   sed -i 's/sda/sdc/g' Kali_pt1.sh to replce with disk you want to install on. Replace sdc witht the device you want.

#Device                         Start                End            Sectors          Size Type

#/dev/sda1                       2048            1026047            1024000          500M EFI System                  
#/dev/sda2                    1026048            3123199            2097152            4G Linux swap
#/dev/sda3                    3123200          104857566          101734367           15G Linux filesystem
#/dev/sda4                    3123200          104857566          101734367           15G Linux filesystem
#/dev/sda5                    3123200          104857566          101734367            4G Linux filesystem
#/dev/sda6                    3123200          104857566          101734367            1G Linux filesystem
#/dev/sda7                    3123200          104857566          101734367          250G Linux filesystem


mkfs.vfat -F32 -n EFIBOOT /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 -L kaliroot /dev/sda3
mkfs.ext4 -L kaliusr /dev/sda4
mkfs.ext4 -L kalivar /dev/sda5
mkfs.ext4 -L kalitmp /dev/sda6
mkfs.ext4 -L kalihome /dev/sda7

mkdir /mnt/kali/

mount /dev/sda3 /mnt/kali/
mkdir /mnt/kali/usr
mkdir /mnt/kali/var
mkdir /mnt/kali/tmp
mkdir /mnt/kali/home
mkdir /mnt/kali/boot
mkdir /mnt/kali/boot/efi


mount /dev/sda4 /mnt/kali/usr
mount /dev/sda5 /mnt/kali/var
mount /dev/sda6 /mnt/kali/tmp
mount /dev/sda7 /mnt/kali/home
mount /dev/sda1 /mnt/kali/boot/efi


debootstrap --variant=minbase --arch amd64 kali-rolling /mnt/kali http://http.kali.org/kali

mount -t proc /proc /mnt/kali/proc
mount --rbind --make-rslave /dev /mnt/kali/dev
mount --rbind --make-rslave /sys /mnt/kali/sys
mount --rbind --make-rslave /run /mnt/kali/run

cd /boot
cp /boot/*-amd64 /mnt/kali/boot/

cd /
curl -O https://raw.githubusercontent.com/aantu014/Linux-Files/master/Debian/zz-update-systemd-boot

mv zz-update-systemd-boot /mnt/kali/etc/kernel/postinst.d/ 
# Set the right owner.
chown root: /mnt/kali/boot/etc/kernel/postinst.d/zz-update-systemd-boot
# Make it executable.
chmod 0755 /mnt/kali/boot/etc/kernel/postinst.d/zz-update-systemd-boot

## IF /var on seperate partion change option to Defaults.
genfstab -U -p /mnt/kali >> /mnt/kali/etc/fstab

chroot /mnt/kali /bin/bash


