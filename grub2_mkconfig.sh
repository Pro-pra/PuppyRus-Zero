./grub-mkimage --directory=x86_64-efi --compression=auto \
--config=grub.cfg --verbose --prefix=/EFI/BOOT \
--output=grubx64.efi --format=x86_64-efi \
part_gpt part_msdos disk fat exfat ext2 ntfs iso9660 normal test search_fs_file multiboot2 configfile linux linux16 chain loopback echo efi_gop efi_uga file halt reboot ls true gfxterm gettext font


#./grub-mkimage --directory=i386-pc --compression=auto \
#--config=grub.cfg --verbose --prefix=/EFI/BOOT \
#--output=grub2 --format=i386-pc-eltorito \
#part_gpt part_msdos biosdisk disk fat exfat ext2 ntfs iso9660 test vbe vga multiboot2 normal search_fs_file configfile linux linux16 chain loopback echo file halt reboot ls true gfxterm gettext font
