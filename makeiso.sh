#!/bin/sh

mkisofs="`which xorriso`"
[ "$mkisofs" = "" ] && echo "Не найдена программа для создания iso" &&exit

[ "$1" ] && ISODIR="$1" || ISODIR=isolinux-builds #каталог с файлами для упаковки в iso

[ ! -d "$ISODIR" ] && echo "Не найден каталог в котором находятся файлы для iso" && exit
cd "$ISODIR"
OUTPUT=../ #каталог в котором создавать iso
DATE=`date +%y%m%d`  #подстановка текущей даты в имя образа
CDLABEL=ZERO

$mkisofs  -as mkisofs -allow-lowercase -J -D -R -A "$CDLABEL" -V "$CDLABEL" \
-b grub2 \
-no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table \
-isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin -eltorito-alt-boot \
-e EFI/BOOT/bootx64.efi \
-no-emul-boot -isohybrid-gpt-basdat \
-o "$OUTPUT"PuppyRus-Zero-"$DATE".iso  .

#секция удаления старых версий iso (например старее 1 года)


#секция выкладки полученных iso в общий доступ
