#!/bin/bash

echo "What will you call your user account? [no spaces, no capital letters]"
read username
#echo "What's your full name?"
#read fullname
#adduser -g $fullname $username
apk add sudo
sleep 10
adduser $username
addgroup $username wheel
addgroup $username input
addgroup $username video
addgroup $username audio
addgroup $username users
addgroup $username adm
addgroup $username floppy
addgroup $username cdrom
addgroup $username dialout
addgroup $username tape
addgroup $username netdev
addgroup $username kvm
addgroup $username games
addgroup $username cdrw
addgroup $username usb
#setup-user -a -g input,video,audio $username
echo /etc/doas.conf >> "permit persist setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel"
echo "What keyboard layout will you use? ej. us, es, ru..."
read keyboardlayout

apk update
echo "Installing basic system required packages"
apk add linux-firmware util-linux pciutils usbutils iproute2 gcompat
apk add sed
apk add mkrundir --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
sed -i -e '1iexport XDG_RUNTIME_DIR=$(mkrundir)\' /home/$username/.profile



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
echo "Installing the Hiker Desktop"
apk add elogind
while [ ! -f "/etc/init.d/elogind" ]; do
  sleep 0.5
done
rc-update add elogind
rc-service elogind start

apk add labwc labwc-doc xwayland foot swaybg font-dejavu mousepad falkon
#apk add sfwbar --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
apk add yambar
apk add greetd greetd-gtkgreet cage

mkdir -p /etc/greetd/
echo "labwc" >> /etc/greetd/environments

while [ ! -f "/etc/init.d/greetd" ]; do
  sleep 0.5
done
rc-update add greetd
mkdir -p /home/$username/.config/labwc
#mkdir -p /home/$username/.config/sfwbar
mkdir -p /home/$username/.config/yambar
cp environment_labwc_hiker /home/$username/.config/labwc/environment
cp rc.xml_labwc_hiker /home/$username/.config/labwc/rc.xml
cp autostart_labwc_hiker /home/$username/.config/labwc/autostart
cp menu.xml_labwc_hiker /home/$username/.config/labwc/menu.xml
#cp sfwbar.config /home/$username/.config/sfwbar/sfwbar.config
cp laptop
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
#apk add pipewire wireplumber pavucontrol pipewire-pulse pipewire-jack pipewire-alsa
apk add pulseaudio pulseaudio-alsa alsa-plugins-pulse pulseaudio-utils 

echo "Configuring bluetooth"
apk add bluez blueman bluez-openrc pulseaudio-bluez
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
apk add flatpak discover discover-backend-apk discover-backend-flatpak xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde xdg-desktop-portal-xapp
#It is possible xdg_desktop_portal will need further configuration
#to make Flatpak work right
hash -r #Refreshes the shell's command cache, in english, tells it to remember flatpak IS indeed installed.
sleep 39 #Waits for the shell to realise I told it to remember flstpak's a thing now.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Setting up networking"
apk add wpa_supplicant networkmanager network-manager-applet networkmanager-wifi networkmanager-bluetooth

while [ ! -f "/etc/init.d/networkmanager" ]; do
  sleep 0.5
done
rc-update add networkmanager default
addgroup $username plugdev

echo "Done! Please reboot."
exit
