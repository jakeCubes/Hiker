#!/bin/bash
#The main script to install Hiker.
#You might have already noticed the little "trick" I used to make this script and not care about Busybox Ash's lack of easily available documentation.
#Don't judge me, please.

#Basic Settings------------------------------------------------------------------
clear
echo "Welcome to the Hiker install script!"
echo "What will you call your user? [Without spaces or capital letters please!]"
read user
clear
echo "Nice, $user, what will your password be?"
read dummy #adduser $user
clear
echo "What about your keyboard layout? [ej. "es", "ru", "us"]"
read layout
clear
echo "What's your graphics card? [intel (both integrated and not), amd, nvidia, generic/vm]
read graphics
clear
echo "Alright, 3"
sleep 1
clear
echo "Alright, 3, 2"
sleep 1
clear
echo "Alright, 3, 2, 1..."
sleep 1
clear
echo "Go!"
clear
#Basic Settings------------------------------------------------------------------


#Setting up the user-------------------------------------------------------------
echo "Setting up your user account..."
sleep 0.2
apk add doas #Adds doas, Alpine's replacement for sudo.
addgroup $user wheel 
addgroup $user input 
addgroup $user video 
addgroup $user audio
addgroup $user users
addgroup $user adm
addgroup $user floppy
addgroup $user cdrom 
addgroup $user dialout
addgroup $user tape
addgroup $user netdev
addgroup $user kvm
addgroup $user games
addgroup $user cdrw
addgroup $user usb
echo "permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel" >> /etc/doas.conf #Makes all users on the "wheel" group (which $user is in) able to doas.
clear
#Setting up the user--------------------------------------------------------------

#Updating repositories and installing essential packages--------------------------
echo "Installing system essentials..."
sleep 0.2
apk update
apk add linux-firmware util-linux pciutils usbutils iproute2 gcompat
setup-devd udev
clear
#Updating repositories and installing essential packages--------------------------


#Installing Mesa drivers and D-Bus------------------------------------------------
echo "Installing graphic drivers..."
sleep 0.2
apk add mesa-dri-gallium mesa-va-gallium dbus dbus-x11bus

if [ $graphics = "intel" ]; then
  apk add intel-media-driver libva-intel-driver linux-firmware-i915
elif [ $graphics = "amd" ]; then
  apk add linux-firmware-amdgpu linux-firmware-radeon mesa-vulkan-ati
elif [ $graphics = "nvidia" ]; then
  echo "Nvidia GPU was selected, the Noveau open-source driver will be used."
else
  echo "No valid GPU brand was selected or generic/vm was selected."
fi

while [ ! -f "/etc/init.d/dbus" ]; do #Avoiding rc-update nonsense || It'd sometimes say D-Bus is not installed and just not enable the service.
  sleep 0.5
done
rc-update add dbus
clear
#Installing Mesa drivers and D-Bus-------------------------------------------------


#Installing the Hiker Desktop------------------------------------------------------
echo "Installing the Hiker Desktop..."
sleep 0.2
apk add xorg-server xinit xf86-input-libinput

echo "setxkbmap $layout" >> configs/.xinitrc
echo "exec icewm-session" >> configs/.xinitrc
cp configs/.xinitrc /home/$user/.xinitrc







