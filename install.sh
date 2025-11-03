#!/bin/bash

echo "What will you call your user account? [no spaces, no capital letters]"
read username
#echo "What's your full name?"
#read fullname
#adduser -g $fullname $username
adduser $username
addgroup $username wheel
addgroup $username input
addgroup $username video
addgroup $username audio
#setup-user -a -g input,video,audio $username
echo "What keyboard layout will you use? ej. us, es, ru..."
read keyboardlayout

apk update
echo "Installing basic system required packages"
apk add linux-firmware util-linux pciutils usbutils iproute2 gcompat
echo "Installing basic Mesa graphics"
apk add mesa-dri-gallium mesa-va-gallium
echo "Setting up udev"
setup-devd udev
echo "Installing D-Bus"
apk add dbus dbus-x11
echo "Setting up D-Bus"
while [ ! -f "/etc/init.d/dbus" ]; do
  sleep 0.5
done
rc-update add dbus

#REVISIT LATER :: SEVERELY UNFINISHED MATERIAL RIGHT HERE
echo "Installing the Hiker XFCE4 Desktop"
apk add elogind
while [ ! -f "/etc/init.d/elogind" ]; do
  sleep 0.5
done
rc-update add elogind
rc-service elogind start

apk add labwc sfwbar labwc-doc xwayland foot swaybg font-dejavu mousepad falkon
apk add sddm xorg-server-xephyr
while [ ! -f "/etc/init.d/sddm" ]; do
  sleep 0.5
done
rc-update add sddm
mkdir -p /home/$username/.config/labwc
mkdir -p /home/$username/.config/sfwbar
cp environment_labwc_hiker /home/$username/.config/labwc/environment
cp rc.xml_labwc_hiker /home/$username/.config/labwc/rc.xml
cp autostart_labwc_hiker /home/$username/.config/labwc/autostart
cp menu.xml_labwc_hiker /home/$username/.config/labwc/menu.xml
cp sfwbar.config /home/$username/.config/sfwbar/sfwbar.config
cp thx_mango133_on_wallpapercave.jpg /home/$username/.config/labwc/thx_mango133_on_wallpapercave.jpg
echo "XKB_DEFAULT_LAYOUT=$keyboardlayout" >> /home/$username/.config/labwc/environment

echo "Installing and configuring file management utilities"
apk add polkit-elogind
while [ ! -f "/etc/init.d/polkit" ]; do
  sleep 0.5
done
rc-update add polkit
rc-service polkit start
apk add thunar gvfs-fuse udisks2 ntfs-3g gvfs-mtp gvfs-smb gvfs-afc gvfs-fuse gvfs-gphoto2 gvfs-archive
apk add fuse-openrc
while [ ! -f "/etc/init.d/fuse" ]; do
  sleep 0.5
done
rc-update add fuse
rc-service fuse start

echo "Configuring audio"
apk add pipewire wireplumber pavucontrol pipewire-pulse pipewire-jack pipewire-alsa
while [ ! -f "/etc/init.d/pipewire" ]; do
  sleep 0.5
done
rc-update -U add pipewire gui
while [ ! -f "/etc/init.d/wireplumber" ]; do
  sleep 0.5
done
rc-update -U add wireplumber gui

echo "Configuring bluetooth"
apk add bluez blueman bluez-openrc pipewire-spa-bluez
modprobe btusb
addgroup $username lp
while [ ! -f "/etc/init.d/bluetooth" ]; do
  sleep 0.5
done
rc-update add bluetooth default

echo "Configuring power management"
apk add acpid pm-utils
while [ ! -f "/etc/init.d/acpid" ]; do
  sleep 0.5
done
rc-update add acpid
echo "" >> /etc/doas.conf
echo "permit nopass $username as root cmd /bin/loginctl" >> /etc/doas.conf

echo "Configuring software management"
apk add flatpak discover discover-backend-apk discover-backend-flatpak xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xdg-desktop-portal-openrc xdg-desktop-portal-xapp
#It is possible xdg_desktop_portal will need further configuration
#to make Flatpak work right
hash -r #Refreshes the shell's command cache, in english, tells it to remember flatpak IS indeed installed.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Setting up networking"
apk add wpa_supplicant wpa_supplicant_openrc networkmanager network-manager-applet

while [ ! -f "/etc/init.d/wpa_supplicant" ]; do
  sleep 0.5
done
rc-update add wpa_supplicant boot
while [ ! -f "/etc/init.d/networking" ]; do
  sleep 0.5
done
rc-update add networking boot
while [ ! -f "/etc/init.d/wpa_cli" ]; do
  sleep 0.5
done
rc-update add wpa_cli boot


echo "Done! Please reboot."
exit
