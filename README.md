# Hiker :D
An easy installation script to make Alpine Linux (3.22.2 as of now) into a minimal, yet very usable graphical distribution. Oriented at older, limited devices (the kind of things Action Retro'd try to breathe life into).

DISCLAIMER
----------
This is very much not finished yet, and the instructions below may be too complicated or confusing for the average user to follow. Although a bit more technical user might not find that an issue, the end goal is for almost anybody to be able to follow this guide as an easy way to revive their old computers, and to someday become a full derivative of Alpine as a whole.

INSTRUCTIONS
------------

[An ethernet cable is required to follow most of this guide until the installation's finished. This may change in the future.]

Download and flash the standard 3.22.2 version of Alpine Linux to an usb drive, boot into the live environment and login as root (there is no password, just press enter).
Afterwards, use the normal setup-alpine install script from the live enviroment first to install base Alpine. For a more detailed explanation, refer to the official Alpine wiki: https://wiki.alpinelinux.org/wiki/Installation 
It is MANDATORY that you install Alpine in "sys" mode and enable the community repository. If for whatever reason, you forgot to enable the community repo, use the setup-apkrepos script to easily do so.

Once you are done with the base installation of Alpine, reboot into the new install, and install the alpine-sdk package by using the command [apk add alpine-sdk].
