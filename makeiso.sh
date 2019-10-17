#!/bin/sh

mkisofs="`which xorriso`"
[ "$mkisofs" = "" ] && echo "Не найдена программа для создания iso" &&exit

[ "$1" ] && ISODIR="$1" || ISODIR=isolinux-builds #каталог с файлами для упаковки в iso

[ ! -d "$ISODIR" ] && echo "Не найден каталог в котором находятся файлы для iso" && exit
cd "$ISODIR"
OUTPUT=../ #каталог в котором создавать iso
DATE=`date +%y%m%d`  #подстановка текущей даты в имя образа
CDLABEL=ZERO

if [ -f ./grub2.eltorito ]; then
  echo "Найден файл загрузчика grub2.eltorito"
else
  [ -f /usr/lib/grub/grub2.eltorito ] && cp -f /usr/lib/grub/grub2.eltorito ./ || echo "Не найден файл загрузчика grub2.eltorito"
fi
#/usr/lib/grub/efi.img это образ раздела fat32 (можно монтировать) на котором размещен grub2
#этот образ используется при загрузке с флешки через EFI. 

$mkisofs  -as mkisofs -allow-lowercase -J -D -R -A "$CDLABEL" -V "$CDLABEL" \
-no-emul-boot -boot-load-size 4 -hide boot.catalog -boot-info-table \
-b grub2.eltorito --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
-boot-info-table --grub2-boot-info grub2.eltorito \
-append_partition 1 0xef /usr/lib/grub/efi.img \
-eltorito-alt-boot --efi-boot EFI/BOOT/bootx64.efi \
-no-emul-boot \
-o "$OUTPUT"PuppyRus-Zero-"$DATE".iso  .

#секция удаления старых версий iso (например старее 1 года)


#секция выкладки полученных iso в общий доступ
