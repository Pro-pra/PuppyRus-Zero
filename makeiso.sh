#!/bin/sh

ISODIR=isolinux-builds/ #каталог с файлами для упаковки в iso
OUTPUT=/mnt/sda1/ #каталог в котором создавать iso
DATE=`date +%y.%m`  #подстановка текущей даты в имя образа

#/usr/bin/mkisofs -allow-lowercase -J -D -R -o "$OUTPUT"PuppyRus-base-"$DATE".iso -m "$ISODIR"'packages/*' -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table "$ISODIR"
#/usr/bin/mkisofs -allow-lowercase -J -D -R -o "$OUTPUT"PuppyRus-base-"$DATE"-xorg.iso -m "$ISODIR"'packages/puppyrus*.pfs' -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table "$ISODIR"
/usr/bin/mkisofs -allow-lowercase -J -D -R -o "$OUTPUT"PuppyRus-Icewm-"$DATE".iso -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table "$ISODIR"
#/usr/bin/mkisofs -allow-lowercase -J -D -R -o "$OUTPUT"PuppyRus-Icewm-"$DATE"-Big.iso -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table "$ISODIR"

#секция удаления старых версий iso (например старее 1 года)


#секция выкладки полученных iso в общий доступ