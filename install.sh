#!/bin/bash

echo "What will you call your user account? [no spaces, no capital letters]"
read username
echo "What's your full name?"
read fullname
adduser -g $fullname $username
setup-user -a -g input,video,audio $username
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
rc-update add dbus

#REVISIT LATER :: SEVERELY UNFINISHED MATERIAL RIGHT HERE
echo "Installing the Hiker XFCE4 Desktop"
apk add elogind

apk add labwc labwc-doc xwayland foot swaybg font-dejavu xfce4-panel mousepad falkon
apk add sddm xorg-server-xephyr
rc-update add sddm

cp ~/Hiker/environment_labwc_hiker ~/home/$username/.config/labwc/environment
cp ~/Hiker/rc.xml_labwc_hiker ~/home/$username/.config/labwc/rc.xml
cp ~/Hiker/autostart_labwc_hiker ~/home/$username/.config/labwc/autostart
cp ~/Hiker/menu.xml_labwc_hiker ~/home/$username/.config/labwc/menu.xml
cp ~/Hiker/thx_mango133_on_wallpapercave.jpg ~/home/$username/.config/labwc/thx_mango133_on_wallpapercave.jpg
echo "XKB_DEFAULT_LAYOUT=$keyboardlayout" >> ~/home/$username/.config/environment
#FIX XDG_RUNTIME_DIR IS UNSET




echo "Installing and configuring file management utilities"
apk add polkit-elogind
rc-update add polkit
rc-service polkit start
apk add thunar gvfs-fuse udisks2 ntfs-3g gvfs-mtp gvfs-smb gvfs-afc gvfs-fuse gvfs-gphoto2 gvfs-archive
apk add fuse-openrc
rc-update add fuse
rc-service fuse start

echo "Configuring audio"
apk add pipewire wireplumber pavucontrol pipewire-pulse pipewire-jack pipewire-alsa
rc-update -U add pipewire gui
rc-update -U add wireplumber gui

echo "Configuring bluetooth"
apk add bluez blueman bluez-openrc pipewire-spa-bluez
modprobe btusb
adduser $username lp
rc-update add bluetooth default

echo "Configuring power management"
apk add acpid powerctl
rc-update add acpid
echo "" >> /etc/doas.conf
echo "permit nopass $username as root cmd /bin/loginctl" >> /etc/doas.conf

echo "Configuring software management"
apk add flatpak discover discover-backend-apk discover-backend-flatpak xdg-desktop-portal xdg-desktop-portal-*
#It is possible xdg_desktop_portal will need further configuration
#to make Flatpak work right
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Setting up networking"
apk add wpa_supplicant wpa_supplicant_openrc networkmanager network-manager-applet
rc-update add wpa-supplicant boot
rc-update add networking boot
rc-update add wpa_cli boot


#service not found workaround
echo "#!/bin/bash" >> ~/Hiker/dbus_workaround.sh
echo "rc-update add dbus" >> ~/Hiker/dbus_workaround.sh
echo "rc-update add elogind" >> ~/Hiker/dbus_workaround.sh
echo "exit" >> ~/Hiker/dbus_workaround.sh
./dbus_workaround.sh

echo "Done! Please reboot."
exit
