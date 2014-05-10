#!/bin/sh
set -e

echo "KDE AYARLANIYOR"


###### Remove Debian Menu

rm -f /etc/xdg/menus/debian-menu.menu

## Remove pulseaudio from xdg autostart

rm -f /etc/xdg/autostart/pulseaudio*
 
echo "KDE AYARLANDI"
