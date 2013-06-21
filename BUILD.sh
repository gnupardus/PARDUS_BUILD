#!/bin/bash

set -e

unset GREP_OPTIONS
PARDUS_SURUM="2013.1"
PARDUS_ISO_SURUM="2013.6beta1"
DIST_ARCH=i386
PARDUS_ARCH=32
PARDUS_desk="kde"
PARDUS_dagitim="topluluk"
PARDUS_DAGITIM="Topluluk"
PARDUS_dagitim_lang="topluluk"
PARDUS_DAGITIM_LANG="Topluluk"
PARDUS_lang_surum=$PARDUS_dagitim_lang"_"$PARDUS_SURUM
PARDUS_LANG_SURUM=$PARDUS_DAGITIM_LANG" "$PARDUS_SURUM
DIST_BASE=wheezy
DELETE_BASE=sid

if [ "`uname -m`" == "x86_64" ]
then
    DIST_ARCH=amd64
    PARDUS_ARCH=64
fi

if ! [ "$USER" == "root" ]
then
    echo "ISO ' yu olusturabilmek icin 'root' yetkisine sahip olmalisiniz."
    exit 1
fi 

function KULLANIM_MESAJI ()
{
	echo "Kullanim : sudo ./BUILD.sh [tr,en] [topluluk, kurumsal, fatih , sunucu] [KDE,GNOME,XFCE] [32,64] [localhost]"
	exit 2
}


function PARAMETRELERI_KONTROL_ET()
{
    case "$1" in
        tr)
            PARDUS_LANG=tr
            ;;
        en)
            PARDUS_LANG=en
            ;;
        *)
            KULLANIM_MESAJI
            ;;
    esac
    case "$2" in
        fatih|Fatih)
            PARDUS_DAGITIM=Fatih
            PARDUS_dagitim=fatih
            PARDUS_DAGITIM_LANG=Fatih
            PARDUS_dagitim_lang=fatih
            ;;
        kurumsal|Kurumsal)
            PARDUS_DAGITIM=Kurumsal
            PARDUS_dagitim=kurumsal
            case "$PARDUS_LANG" in
                en)
                    PARDUS_DAGITIM_LANG=Corporate
                    PARDUS_dagitim_lang=corporate
                   ;;
                *)
                    PARDUS_DAGITIM_LANG=Kurumsal
                    PARDUS_dagitim_lang=kurumsal
                   ;;
            esac
            ;;
        sunucu|Sunucu)
            PARDUS_DAGITIM=Sunucu
            PARDUS_dagitim=sunucu
            case "$PARDUS_LANG" in
                en)
                    PARDUS_DAGITIM_LANG=Server
                    PARDUS_dagitim_lang=server
                   ;;
                *)
                    PARDUS_DAGITIM_LANG=Sunucu
                    PARDUS_dagitim_lang=sunucu
                   ;;
            esac
            ;;
        topluluk|Topluluk)
            PARDUS_DAGITIM=Topluluk
            PARDUS_dagitim=topluluk
            DIST_BASE=sid
            DELETE_BASE=wheezy
            case "$PARDUS_LANG" in
                en)
                    PARDUS_DAGITIM_LANG=
                    PARDUS_dagitim_lang=
                   ;;
                *)
                    PARDUS_DAGITIM_LANG=
                    PARDUS_dagitim_lang=
                   ;;
            esac
            ;;
        *)
            KULLANIM_MESAJI
            ;;
    esac
    if [ "$PARDUS_DAGITIM_LANG" = "" ]
    then
        PARDUS_LANG_SURUM=$PARDUS_SURUM
        PARDUS_lang_surum=$PARDUS_SURUM
    else 
        PARDUS_LANG_SURUM=$PARDUS_DAGITIM_LANG" "$PARDUS_SURUM
        PARDUS_lang_surum=$PARDUS_dagitim_lang"_"$PARDUS_SURUM
    fi
    case "$3" in
        KDE|kde)
            PARDUS_desk=kde
            ;;
        GNOME|gnome)
            PARDUS_desk=gnome
            ;;
        XFCE|xfce)
            PARDUS_desk=xfce
            ;;
        *)
            KULLANIM_MESAJI
            ;;
    esac
    if ! [ "$4" == "" ]
    then
        case "$4" in
            32|i386)
                DIST_ARCH=i386
                PARDUS_ARCH=32
                ;;
            64|amd64|x86_64)
                DIST_ARCH=amd64
                PARDUS_ARCH=64
                ;;
            *)
                KULLANIM_MESAJI
                ;;
        esac
    fi
}


PARAMETRELERI_KONTROL_ET $*


PARDUS_DESK_ENV=$3
LOCALHOST=$5

if [ "$LOCALHOST" == "localhost" ]
then
    DEBIAN_POOL="ftp://localhost/$PARDUS_dagitim/anahavuz/"
    SECURITY_POOL="ftp://localhost/$PARDUS_dagitim/guvenlik/"
    MULTIMEDIA_POOL="ftp://localhost/$PARDUS_dagitim/cokluortam/"
    BACKPORTS_POOL="ftp://localhost/$PARDUS_dagitim/geritasima/"
    OZEL_HAVUZ="ftp://localhost/$PARDUS_dagitim/ozelhavuz/"
else
    DEBIAN_POOL="ftp://depo.pardus.org.tr/$PARDUS_dagitim/anahavuz/"
    SECURITY_POOL="ftp://depo.pardus.org.tr/$PARDUS_dagitim/guvenlik/"
    MULTIMEDIA_POOL="ftp://depo.pardus.org.tr/$PARDUS_dagitim/cokluortam/"
    BACKPORTS_POOL="ftp://depo.pardus.org.tr/$PARDUS_dagitim/geritasima/"
    OZEL_HAVUZ="ftp://depo.pardus.org.tr/$PARDUS_dagitim/ozelhavuz/"
    ###### DEBIAN_POOL="ftp://ftp.tr.debian.org/debian/"
    ###### SECURITY_POOL="http://security.debian.org/"
    ###### MULTIMEDIA_POOL="http://www.deb-multimedia.org/"
    ###### BACKPORTS_POOL="deb ftp://ftp.de.debian.org/debian-backports/"
    ###### OZEL_HAVUZ="ftp://depo.pardus.org.tr/ozelhavuz/"
fi


PACKAGES=`cat PAKETLER.txt PAKETLER_"$PARDUS_LANG".txt | grep "|$PARDUS_ARCH|" | grep "|$PARDUS_DESK_ENV|" | grep "|$PARDUS_DAGITIM|" | grep "|$DIST_BASE|" |  cut -d "|" -f 1`

rm -r -f LIVE ISO
mkdir -p LIVE
cd    LIVE

rm -r -f  isolinux
mkdir isolinux
cp -f ../isolinux/$DIST_BASE"_"$DIST_ARCH/$PARDUS_LANG/* isolinux

lb config -a $DIST_ARCH --verbose --apt apt --parent-distribution $DIST_BASE --distribution $DIST_BASE --binary-images iso-hybrid
lb config --apt-options  '--force-yes -y'
lb config --system live
lb config --parent-distribution $DIST_BASE 
lb config  --firmware-binary false

if [ "$DIST_BASE" == "sid" ]
then
    lb config  --updates false
    lb config  --security false
    lb config  --backports false
fi

cp -f ../packages/*          config/packages.chroot/

mkdir -p config/includes.chroot/opt/PARDUS/

cp -r -f ../files                            config/includes.chroot/opt/PARDUS/
cd  config/includes.chroot/opt/PARDUS/files
    rm -f "$DELETE_BASE"_*
cd -

if [ "$PARDUS_DAGITIM" == "Sunucu" ]
then
    mkdir -p config/includes.chroot/usr/share/applications/
    cp -f ../files/webmin.desktop                 config/includes.chroot/usr/share/applications/
    cp -f ../files/webmin.jpg                     config/includes.chroot/usr/share/applications/

    cp -f ../files/finish-install*.udeb .
fi

echo "Pardus $PARDUS_LANG_SURUM \\n \\l"    > config/includes.chroot/opt/PARDUS/files/issue
echo "Pardus $PARDUS_LANG_SURUM"            > config/includes.chroot/opt/PARDUS/files/issue.net
echo "$PARDUS_LANG"                         > config/includes.chroot/opt/PARDUS/pardus_lang.txt
echo "$DIST_BASE"                           > config/includes.chroot/opt/PARDUS/pardus_pool.txt
echo "$PARDUS_ARCH"                         > config/includes.chroot/opt/PARDUS/pardus_arch.txt
echo "$PARDUS_DAGITIM"                      > config/includes.chroot/opt/PARDUS/pardus_dagitim.txt
echo "$PARDUS_DESK_ENV"                     > config/includes.chroot/opt/PARDUS/pardus_desk_env.txt
#cp -f ../files/"$DIST_BASE"_sources.list.internet  config/includes.chroot/opt/PARDUS/files/sources.list
cp -f ../files/sources.list_"$PARDUS_dagitim"  config/includes.chroot/opt/PARDUS/files/sources.list

if [ "$DIST_BASE" == "wheezy" ]
then
    if ! [ "$PARDUS_DAGITIM" == "Sunucu" ]
    then
        echo "deb $DEBIAN_POOL      wheezy-proposed-updates   main contrib non-free"  >> config/archives/pardus-mirrors.list.chroot
    fi
    echo "deb $MULTIMEDIA_POOL  wheezy                    main         non-free"  >> config/archives/pardus-mirrors.list.chroot
    echo "deb $OZEL_HAVUZ       wheezy                    main contrib non-free"  >> config/archives/pardus-mirrors.list.chroot
else
    echo "deb $MULTIMEDIA_POOL  sid                    main         non-free"  >> config/archives/pardus-mirrors.list.chroot
    echo "deb $OZEL_HAVUZ       sid                    main contrib non-free"  >> config/archives/pardus-mirrors.list.chroot
fi

lb config --parent-archive-areas "main contrib non-free"

lb config --parent-mirror-bootstrap $DEBIAN_POOL
lb config --mirror-bootstrap $DEBIAN_POOL

lb config --parent-mirror-chroot $DEBIAN_POOL
lb config --parent-mirror-chroot-security $SECURITY_POOL
lb config --mirror-chroot $DEBIAN_POOL
lb config --mirror-chroot-security $SECURITY_POOL

lb config --parent-mirror-binary $DEBIAN_POOL
lb config --parent-mirror-binary-security $SECURITY_POOL
lb config --mirror-binary $DEBIAN_POOL
lb config --mirror-binary-security $SECURITY_POOL


#lb config --parent-mirror-debian-installer $DEBIAN_POOL
lb config --mirror-debian-installer $DEBIAN_POOL


if [ "$DIST_BASE" == "wheezy" ]
then
    lb config --mirror-binary-updates $DEBIAN_POOL
    lb config --mirror-binary-backports $BACKPORTS_POOL
    lb config --parent-mirror-binary-updates $DEBIAN_POOL
    lb config --parent-mirror-binary-backports $BACKPORTS_POOL
    lb config --mirror-chroot-updates $DEBIAN_POOL
    lb config --mirror-chroot-backports $BACKPORTS_POOL
    lb config --parent-mirror-chroot-updates $DEBIAN_POOL
    lb config --parent-mirror-chroot-backports $BACKPORTS_POOL
fi


echo "$PACKAGES"                      > config/package-lists/pardus.list.chroot

mkdir -p config/includes.chroot/lib/live/config
cp -f ../live-config/*            config/includes.chroot/lib/live/config/

cp -f ../hooks/*                        config/hooks

########## if [ "$PARDUS_DESK_ENV" == "GNOME" ]
########## then
   ########## mkdir -p                                       config/includes.chroot/usr/share/backgrounds/gnome/
   ########## cp -f ../files/Pardus_Mood.png                 config/includes.chroot/usr/share/backgrounds/gnome/
########## fi

cp -f ../files/pardus.preseed.chroot       config/preseed/pardus.cfg.chroot
cat ../files/pardus.preseed.chroot.$PARDUS_LANG >>  config/preseed/pardus.cfg.chroot


##### isolinux
sed -i "s|XYZ|$PARDUS_LANG_SURUM $PARDUS_DESK_ENV|" isolinux/live.cfg
if [ "$PARDUS_DAGITIM" == "Sunucu" ]
then
    if [ "$DIST_ARCH" == "i386" ]
    then
        sed -i "1,10d" isolinux/live.cfg
    fi
    sed -i "s/ splash quiet --//" isolinux/live.cfg
else
    sed -i "s/file=\/cdrom\/install\/preseed.cfg //" isolinux/live.cfg
fi

###### lsb-release 
echo "DISTRIB_ID=Debian"                                                  >> config/includes.chroot/opt/PARDUS/files/lsb-release
echo "DISTRIB_RELEASE=$PARDUS_SURUM"                                      >> config/includes.chroot/opt/PARDUS/files/lsb-release
echo "DISTRIB_CODENAME=$DIST_BASE"                                        >> config/includes.chroot/opt/PARDUS/files/lsb-release
echo "DISTRIB_DESCRIPTION=\"Pardus $PARDUS_LANG_SURUM $PARDUS_DESK_ENV\"" >> config/includes.chroot/opt/PARDUS/files/lsb-release

###### debian_version
echo "$PARDUS_SURUM" >> config/includes.chroot/opt/PARDUS/files/pardus_version

if [ "$PARDUS_DAGITIM_LANG" = "" ]
then
    lb config --iso-application "Pardus"
else
    lb config --iso-application "Pardus $PARDUS_DAGITIM_LANG"
fi
lb config --iso-volume "Pardus $PARDUS_LANG_SURUM $PARDUS_DESK_ENV$PARDUS_ARCH"

cp -f ../files/isolinux_pardus_background.png   isolinux/splash.png

lb config --archive-areas                   "main contrib non-free"
lb config --mirror-bootstrap                $DEBIAN_POOL
lb config --mirror-chroot                   $DEBIAN_POOL
lb config --mirror-chroot-security          $SECURITY_POOL
lb config --mirror-binary                   $DEBIAN_POOL
lb config --mirror-binary-security          $SECURITY_POOL


if [ "$PARDUS_DAGITIM" == "Sunucu" ]
then
    lb config --debian-installer live
    lb config --debian-installer-gui true
    lb config --debian-installer-distribution wheezy
    cp  ../files/preseed_"$PARDUS_LANG".cfg config/debian-installer/preseed.cfg
    cat ../files/preseed_common.cfg >> config/debian-installer/preseed.cfg
    # preseed.cfg atamasi yapildiktan sonr tekrar lb config demek gerekiyor
    lb config

    rm -f config/packages.chroot/inxi*
    rm -f config/packages.chroot/pardus-installer*
    rm -f config/packages.chroot/mint-translation*
    rm -f config/includes.chroot/lib/live/config/3016-create-live-desktop-shortcuts
else
    lb config --debian-installer false
    rm -f config/packages.chroot/debian-installer-launcher*
fi


lb config --checksums none
lb config --apt-recommends false
lb config --security             true
lb config --memtest none
lb config --source false 
lb config --iso-preparer  "Pardus"
lb config --iso-publisher "ULAKBIM - http://www.ulakbim.gov.tr"

ls -l -R config

lb build 2>&1 | tee build.log

cd ..

if ! [ -e LIVE/binary.hybrid.iso ]
then
    echo "ALARM\nALARM. ISO not found"
    exit 3
fi

echo "***************************************************************"
echo "  ISO'nun ismi degistiriliyor ve MD5 hazirlaniyor           "


mkdir -p ISO

if [ "$PARDUS_DAGITIM_LANG" = "" ]
then
    PARDUS_ISO_NAME="pardus_"$PARDUS_ISO_SURUM"_"$PARDUS_desk"_"$PARDUS_ARCH"bit""_"$PARDUS_LANG
else 
    PARDUS_ISO_NAME="pardus_"$PARDUS_dagitim_lang"_"$PARDUS_ISO_SURUM"_"$PARDUS_desk"_"$PARDUS_ARCH"bit""_"$PARDUS_LANG
fi

mv     -f LIVE/binary.hybrid.iso     ISO/"$PARDUS_ISO_NAME".iso
mv     -f LIVE/build.log             ISO/"$PARDUS_ISO_NAME".log

cd ISO
md5sum    "$PARDUS_ISO_NAME".iso > "$PARDUS_ISO_NAME".md5
cd ..

echo ""
echo "  $PARDUS_ISO_NAME.iso hazir !                     "
echo ""
echo "***************************************************************"

if [ -d /SDA1/FTP/qetujgda/gunluk ]
then
    ISO_TARGET="/SDA1/FTP/qetujgda/gunluk/$PARDUS_LANG"
fi

if [ -d /ARSIV ]
then
    ISO_TARGET="/ARSIV"
fi

if ! [ "$ISO_TARGET" == "" ]
then
     echo "  ISO Kopyalaniyor .. "
     cp -f ISO/"$PARDUS_ISO_NAME".iso $ISO_TARGET
     cp -f ISO/"$PARDUS_ISO_NAME".md5 $ISO_TARGET
     cp -f ISO/"$PARDUS_ISO_NAME".log ~
     echo "  Kopyalandi"
fi

