#!/bin/sh
set -e

#  Sabit diske kurulum bitince cagriliyor

PARDUS_USER_NAME=`ls -1 /home/`

# autologin 

if [ -d /etc/kde4 ]
then
    echo "KDE4 found"
    sed -i "s|^#\?AutoLoginEnable=.*|AutoLoginEnable=true|" /etc/kde4/kdm/kdmrc
    sed -i "s|^#\?AutoLoginUser=.*|AutoLoginUser=$PARDUS_USER_NAME|" /etc/kde4/kdm/kdmrc
fi

if [ -d /etc/gdm3 ]
then
    echo "GDM3 found"
    sed -i "s|^#\?.*AutomaticLoginEnable.*|AutomaticLoginEnable = true|" /etc/gdm3/daemon.conf
    ######## #sed -i "s|^#\?.*AutomaticLogin .*=.*|AutomaticLogin = $PARDUS_USER_NAME|" /etc/gdm3/daemon.conf
    sed -i "s|^#\?.*AutomaticLogin .*=.*|AutomaticLogin = $PARDUS_USER_NAME\nTimedLoginEnable = true\nTimedLogin = $PARDUS_USER_NAME\nTimedLoginDelay = 0|" /etc/gdm3/daemon.conf
fi
if [ -e /etc/lightdm/lightdm.conf ]
then
    sed -i -r -e "s|^#.*autologin-user=.*\$|autologin-user=${PARDUS_USER_NAME}|" -e "s|^#.*autologin-user-timeout=.*\$|autologin-user-timeout=0|" /etc/lightdm/lightdm.conf
fi
