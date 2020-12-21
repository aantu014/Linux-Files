

# Use this to get script to run.
#https://www.studytonight.com/post/solved-getting-error-while-executing-a-sh-file-binbashm-bad-interpreter

#Get ip and netowrk interface
##ip a##

timedatectl set-ntp true

#cfdisk /dev/sda
#You can run   sed -i 's/sda/sdc/g' ArchPt1  to replce with disk you want to install on. Replace sdc witht the device you want.

#Device                         Start                End            Sectors          Size Type

#/dev/sda1                       2048            1026047            1024000          500M EFI System                  
#/dev/sda2                    1026048            3123199            2097152            4G Linux swap
#/dev/sda3                    3123200          104857566          101734367           30G Linux filesystem
#/dev/sda4                    3123200          104857566          101734367           30G Linux filesystem
#/dev/sda5                    3123200          104857566          101734367            4G Linux filesystem
#/dev/sda6                    3123200          104857566          101734367            2G Linux filesystem
#/dev/sda7                    3123200          104857566          101734367          250G Linux filesystem

mkfs.vfat -F32 -n EFIBOOT /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 -L archroot /dev/sda3
mkfs.ext4 -L archusr /dev/sda4
mkfs.ext4 -L archvar /dev/sda5
mkfs.ext4 -L archtmp /dev/sda6
mkfs.ext4 -L archhome /dev/sda7

mkdir /mnt/arch/

mount /dev/sda3 /mnt/arch/
mkdir /mnt/arch/usr
mkdir /mnt/arch/var
mkdir /mnt/arch/tmp
mkdir /mnt/arch/home
mkdir /mnt/arch/boot
mkdir /mnt/arch/boot/efi

mount /dev/sda4 /mnt/arch/usr
mount /dev/sda5 /mnt/arch/var
mount /dev/sda6 /mnt/arch/tmp
mount /dev/sda7 /mnt/arch/home
mount /dev/sda1 /mnt/arch/boot/efi

#Base install:
pacstrap /mnt/arch systemd pacman linux-lts linux-firmware vim git networkmanager

#Generate the FSTAB file:

genfstab -U /mnt/arch >> /mnt/arch/etc/fstab

#Enter the installation

arch-chroot /mnt/arch

##You are now in Arch Enirontment now download second part of script and runit ;)
