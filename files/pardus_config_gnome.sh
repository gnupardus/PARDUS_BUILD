#!/bin/sh
set -e

echo "GNOME AYARLANIYOR"


# Epiphany-browser ' i devre disi birak
update-alternatives --remove x-www-browser /usr/bin/epiphany-browser
update-alternatives --remove gnome-www-browser /usr/bin/epiphany-browser


###### Gnome ayarlarini derle
#### gconftool-2 --set /apps/nautilus/desktop/volumes_visible --type bool 0

if [ -d /usr/share/glib-2.0/schemas/ ]
then
    glib-compile-schemas /usr/share/glib-2.0/schemas/
fi



###### Remove Debian Menu

rm -f /etc/xdg/menus/debian-menu.menu
 
echo "GNOME AYARLANDI"
