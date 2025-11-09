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
adduser $user
clear
echo "What about your keyboard layout? [ej. "es", "ru", "us"]"
read layout
clear
echo "What's your graphics card? [intel (both integrated and not), amd, nvidia, generic/vm]"
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
sleep 0.5
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
sleep 0.5
apk update
sleep 0.5
apk add linux-firmware util-linux pciutils usbutils iproute2 gcompat sof-firmware
apk add linux-pam shadow-login #Fixes a problem where all polkit agents'd refuse to start. Turns out the default login command doesn't care about pam, which is a problem, because polkit requires it.
setup-devd udev
clear
#Updating repositories and installing essential packages--------------------------


#Installing Mesa drivers and D-Bus------------------------------------------------
echo "Installing graphic drivers..."
sleep 0.5
apk add mesa-dri-gallium mesa-va-gallium dbus dbus-x11 mesa-gles mesa-gl

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
sleep 0.5
echo "Installing the desktop..."
apk add xterm mousepad setxkbmap xorg-server xinit xf86-input-libinput icewm xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xdg-desktop-portal-xapp polkit-gnome

apk add elogind
while [ ! -f "/etc/init.d/elogind" ]; do
  sleep 0.5
done
rc-update add elogind

apk add jgmenu
mkdir -p /home/$user/.config/gtk-3.0/
cp configs/gtk.css /home/$user/gtk-3.0/gtk.css

apk add greetd greetd-openrc greetd-tuigreet
while [ ! -f "/etc/init.d/greetd" ]; do
  sleep 0.5
done
rc-update add greetd

echo "setxkbmap $layout" >> configs/.xinitrc
echo "exec icewm-session" >> configs/.xinitrc
cp configs/.xinitrc /home/$user/.xinitrc
cp -r configs/icewm /home/$user/.icewm/

while [ ! -f "/usr/bin/jgmenu_run" ]; do
  sleep 0.5
done
jgmenu_run init --theme=greeneye #Sets a whiskermenu-like theme for jgmenu. 
clear
#Installing the Hiker Desktop-------------------------------------------------------


#Configuring connectivity-----------------------------------------------------------
echo "Setting up Wifi and Bluetooth"
sleep 0.5
apk add wpa_supplicant networkmanager network-manager-applet networkmanager-wifi networkmanager-bluetooth

while [ ! -f "/etc/init.d/networkmanager" ]; do
  sleep 0.5
done
rc-update add networkmanager default
addgroup $user plugdev

apk add bluez blueman bluez-openrc
modprobe btusb
addgroup $user lp
while [ ! -f "/etc/init.d/bluetooth" ]; do
  sleep 0.5
done
rc-update add bluetooth default
clear
#Configuring connectivity-----------------------------------------------------------


#Setting up audio (ALSA)------------------------------------------------------------
echo "Setting up audio..."
sleep 0.5
apk add alsa-utils alsaconf
addgroup root audio
apk add volumeicon --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
while [ ! -f "/etc/init.d/alsa" ]; do
  sleep 0.5
done
rc-update add alsa
clear
#Setting up audio (ALSA)------------------------------------------------------------


#Setting up automounting and pcmanfm------------------------------------------------
echo "Setting up file management..."
sleep 0.5
apk add polkit-elogind
while [ ! -f "/etc/init.d/polkit" ]; do
  sleep 0.5
done
rc-update add polkit
rc-service polkit start
apk add pcmanfm gvfs-fuse udisks2 ntfs-3g gvfs-mtp gvfs-smb gvfs-afc gvfs-fuse gvfs-gphoto2 gvfs-archive
apk add fuse-openrc
while [ ! -f "/etc/init.d/fuse" ]; do
  sleep 0.5
done
rc-update add fuse
rc-service fuse start
clear
#Setting up automounting and pcmanfm------------------------------------------------


#Setting up power management--------------------------------------------------------
echo "Setting up power management..."
sleep 0.5
apk add powerctl

#Setting up busybox acpid takes a while, so it's been left for later just for now.

clear
#Setting up power management--------------------------------------------------------


#Adding a software store------------------------------------------------------------
echo "Installing the software store..."
sleep 0.5
apk add flatpak discover discover-backend-apk discover-backend-flatpak
sleep 2 #Waits for the shell to realise I told it to remember flstpak's a thing now.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
clear
#Adding a software store------------------------------------------------------------


#Rebooting--------------------------------------------------------------------------
echo "Installation complete!"
sleep 0.2
echo "Rebooting in..."
sleep 0.1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
reboot
#Rebooting----------------------------------------------------------------------------

#TODO:
#Config acpid propperly.
#Add a greeter.
#Fix Super_L showing the IceWM start menu.
#Fix applets not displaying by default
#Fix default theme not being applied by default
#Fix jgmenu not being installed
#Fix icewm preferences not being configured propperly
#Give KDE Discover root perms by default with doas because you don't have enough work already
