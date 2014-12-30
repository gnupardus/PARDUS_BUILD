#!/bin/sh
set -e

echo "KDE AYARLANIYOR"


###### Remove Debian Menu

rm -f /etc/xdg/menus/debian-menu.menu

## Remove pulseaudio from xdg autostart

rm -f /etc/xdg/autostart/pulseaudio-kde.desktop
#rm -f /etc/xdg/autostart/pulseaudio.desktop
#rm -f /etc/xdg/autostart/hplip-systray.desktop

 
echo "KDE AYARLANDI"
