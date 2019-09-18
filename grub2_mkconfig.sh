# Для GPT образа
./grub-mkimage --directory=x86_64-efi --compression=auto \
--config=grub.cfg --verbose --prefix=/EFI/BOOT \
--output=grubx64.efi --format=x86_64-efi \
part_gpt part_msdos disk fat exfat lvm ext2 ntfs iso9660 normal test search_fs_file multiboot2 configfile linux linux16 chain loopback echo efi_gop efi_uga file halt reboot ls true gfxterm gettext font

#для CDROM образа
./grub-mkimage --directory=i386-pc --compression=auto \
--config=grub.cfg --verbose --prefix=\(hd0,msdos1\)/EFI/BOOT \
--output=grub2 --format=i386-pc-eltorito \
part_msdos biosdisk disk fat iso9660 test vbe vga multiboot2 normal search_fs_file configfile linux linux16 chain loopback echo file halt reboot ls true gfxterm gettext font

#для USB образа
./grub-mkimage --directory=i386-pc --compression=none \
--verbose --prefix=\(hd0,msdos1\)/EFI/BOOT \
--output=core.img --format=i386-pc \
part_gpt part_msdos biosdisk disk fat lvm exfat ext2 ntfs iso9660 test vbe vga multiboot2 normal search_fs_file configfile linux linux16 chain loopback echo file halt reboot ls true gfxterm gettext font

#boot.img (из grub2) и core.img (делается grub-mkimage) записываются в MBR флешки или диска 
#командой grub-bios-setup или dd, примеры:
#dd if=boot.img of=/deb/sdb bs=446 count=1
#dd if=core.img of=/dev/sdb bs=512 seek=1
#grub-bios-setup -d. -b ./boot.img -c ./core.img /dev/sdb
