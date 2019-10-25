#скрипт создает образы GRUB2 для использования на загрузочных носителях
#Пересоздавать образы постоянно требуется только при обновлении GRUB2 или при
#добавлении-удалении модулей в GRUB2.
#Готовые сгенерированные образы находятся в каталоге /usr/lib/grub

#Образы будут созданы в текущем каталоге, если все не требуется, закоментируйте ненужное
#grubx64.efi - EFI образ
#grub2 - El Torito образ для ISO

#core.img - образ для загрузочного USB, используется вместе с boot.img
#boot.img (из grub2) и core.img (делается grub-mkimage) записываются в MBR флешки или диска 
#командой grub-bios-setup или dd, примеры (/dev/sdb заменить на свою флешку):
#grub-bios-setup -d. -b /usr/lib/grub/i386-pc/boot.img -c ./core.img /dev/sdb
#или
#dd if=./core.img of=/dev/sdb bs=512 seek=1
#dd if=/usr/lib/grub/i386-pc/boot.img of=/deb/sdb bs=446 count=1

# Для GPT загрузки (можно использовать при загрузке с HDD и ISO)
grub-mkimage --directory=/usr/lib/grub/x86_64-efi --compression=auto \
--config=/usr/share/grub/grub.cfg --verbose --prefix=/EFI/BOOT \
--output=grubx64.efi --format=x86_64-efi \
part_gpt part_msdos disk memdisk fat exfat lvm ext2 ntfs iso9660 normal gzio xzio test search configfile linux linux16 chain loopback echo efi_gop efi_uga file halt reboot ls true gfxterm gettext font

#для CDROM
grub-mkimage --directory=/usr/lib/grub/i386-pc --compression=auto \
--config=/usr/share/grub/grub.cfg --verbose --prefix=/EFI/BOOT \
--output=grub2.eltorito --format=i386-pc-eltorito \
part_msdos biosdisk disk fat iso9660 test vbe vga normal gzio xzio search configfile linux linux16 chain loopback echo file halt reboot ls true gfxterm gettext font

#для USB образа
#grub-mkimage --directory=/usr/lib/grub/i386-pc --compression=none \
#--verbose --prefix=\(hd0,msdos1\)/EFI/BOOT \
#--output=core.img --format=i386-pc \
#part_gpt part_msdos biosdisk disk memdisk fat lvm ntldr exfat ext2 ntfs iso9660 gzio xzio test vbe vga normal search configfile linux linux16 chain loopback echo file halt reboot ls true gfxterm gettext font

