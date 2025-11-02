# Hiker :D
An easy installation script to make Alpine Linux (3.22.2 as of now) into a minimal, yet very usable graphical distribution. Oriented at older, limited devices (the kind of things Action Retro'd try to breathe life into).

DISCLAIMER
----------
This is very much not finished yet, and the instructions below may be too complicated or confusing for the average user to follow. Although a bit more technical user might not find that an issue, the end goal is for almost anybody to be able to follow this guide as an easy way to revive their old computers, and to someday become a full derivative of Alpine as a whole. I am not responsible for any damage inflicted to one's device through the usage of this script.

INSTRUCTIONS
------------

[An ethernet cable is required to follow most of this guide until the installation's finished. This may change in the future.]

Download and flash the standard 3.22.2 version of Alpine Linux to a usb drive, boot into the live environment and login as root (there is no password, just press enter).
Afterwards, use the normal setup-alpine install script from the live enviroment first to install base Alpine. For a more detailed explanation, refer to the official Alpine wiki: https://wiki.alpinelinux.org/wiki/Installation 
It is MANDATORY that you install Alpine in "sys" mode, DO NOT make a user account (the Hiker script'll handle that) and enable the community repository. If for whatever reason, you forgot to enable the community repo, use the setup-apkrepos script to easily do so.

Once you are done with the base installation of Alpine, reboot into the new install, and install the alpine-sdk package by using the command [apk add alpine-sdk].

Once all of the previous' done, we will move on to downloading and executing the Hiker install script. Then, you sit back, let the magic happen, and reboot your computer.

To do so, just type in the following commands:

- Clone this repo: [git clone https://github.com/jakeCubes/Hiker.git]
- Enter the newly downloaded folder: [cd Hiker]
- Make the script executable [chmod +x install.sh && chmod +x install_bash.sh]
- Run the script [./install_bash]
- Watch an Action Retro video while it installs (I really like that channel, if you haven't guessed just yet).
- Realise the installation actually only took 4 minutes.
Once this is done, the computer will reboot into a graphical environment.
‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ 
-------------------
