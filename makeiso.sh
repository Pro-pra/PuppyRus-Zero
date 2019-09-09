#!/bin/sh

mkisofs="`which mkisofs || which genisoimage`"
[ "$mkisofs" = "" ] && echo "Не найдена программа для создания iso" &&exit

[ "$1" ] && ISODIR="$1" || ISODIR=isolinux-builds #каталог с файлами для упаковки в iso

[ ! -d "$ISODIR" ] && echo "Не найден каталог в котором находятся файлы для iso" && exit
cd "$ISODIR"
OUTPUT=../ #каталог в котором создавать iso
DATE=`date +%y%m%d`  #подстановка текущей даты в имя образа
CDLABEL=Zero

#$mkisofs -allow-lowercase -J -D -R -o "$OUTPUT"PuppyRus-Icewm-"$DATE".iso -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table "$ISODIR"
#для загрузчика grub4dos 
#$mkisofs -allow-lowercase -J -D -R -A "$CDLABEL" -V "$CDLABEL" -b grldr -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table -o "$OUTPUT"PuppyRus-Zero-"$DATE".iso .

#для загрузчика Grub2
$mkisofs -allow-lowercase -J -D -R -A "$CDLABEL" -V "$CDLABEL" -b grub2 -no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table -o "$OUTPUT"PuppyRus-Zero-"$DATE".iso .

#секция удаления старых версий iso (например старее 1 года)


#секция выкладки полученных iso в общий доступ
