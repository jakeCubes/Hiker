#!/bin/sh
#
# ~/.xinitrc
#
# The last lines with the window manager session are echoed from the script for technical reasons.

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
/usr/libexec/polkit-gnome-authentication-agent-1 &
nm-applet &
volumeicon &
