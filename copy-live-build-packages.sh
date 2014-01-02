#!/bin/sh

rm -f live-build_4.0~alpha*_all.deb
rm -f live-config-doc_4.0~alpha*_all.deb
# rm -f live-manual_4.0~alpha*.deb
# rm -f live-manual-pdf_4.0~alpha*.deb
# rm -f live-manual-txt_4.0~alpha*.deb
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-build/live-build_4.0~alpha*.deb .
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-config/live-config-doc_4.0~alpha*.deb .
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-boot/live-boot-doc_4.0~alpha*.deb .
# cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-manual/live-manual_4.0~alpha*.deb .
# cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-manual/live-manual-pdf_4.0~alpha*.deb .
# cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-manual/live-manual-txt_4.0~alpha*.deb .


rm -f packages/live-*.deb
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-boot/live-boot_4.0~alpha*.deb packages/
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-boot/live-boot-initramfs-tools_4.0~alpha*.deb packages/
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-config/live-config_4.0~alpha*.deb packages/
#cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-config/live-config-systemd_4.0~alpha*.deb packages/
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-config/live-config-sysvinit_4.0~alpha*.deb packages/
cp /ARSIV/POOLS/topluluk/anahavuz/pool/main/l/live-tools/live-tools_4.0~alpha*.deb packages/
