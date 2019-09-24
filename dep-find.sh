#!/bin/ash
#180109 sfs DDSE
#190923 rewrite for Zero
[ ! "$1" ] && echo "Использование: $0 [-base] dir
    Поиск недостающих библиотек для модуля (пакета) распакованного в dir
    если не задан параметр -base поиск выполняется в существующем /usr/lib
    -base - поиск библиотек выполняется только в модуле base" && exit
#[ "$1" = "-p" ] && p=1 && shift


if [ "$1" = "-base" ] ;then
    [ ! "$2" ] && echo "Не задан каталог из которого проверяем зависимости
    Использование: $0 [-base] dir" && exit
    #определить где примонтирован base
    BASE_DIR="`lsblk -l -n -o MOUNTPOINT | grep --max-count=1 "\-base.pfs"`"
    
    [ -f /var/tmp/dep-find.lst ] && rm -f /var/tmp/dep-find.lst
    # выполнить поиск исполняемых
    for F in `find "$2" -type f -executable`
    do
	#для каждого найденного делаем ldd и записываем во временный файл
	ldd $F | grep ".so" | grep -v "ld-linux" | awk '{print $1}' >> /var/tmp/dep-find.lst
    done
    # убираем повторяющиеся строки
    for LIB in `sort -u /var/tmp/dep-find.lst`
    do
	#делаем поиск каждого файла в каталоге BASE_DIR
	if [ `find "$BASE_DIR/usr/lib" \( -type l -or -type f \) -name "$LIB"` ]; then
	
	else
	    echo "$LIB не найдено в base.pfs"
	    find "$1" \( -type l -or -type f \) -name "$LIB" -exec echo "$LIB  найден в '$1'" \;
	    echo
	fi
    done
    exit
fi

d="`find "$1" -type f -executable -exec ldd {} \; |awk '/=> not found/ {print $1}'|sort -u`"
#echo -n "cp -d "
#echo "$d" |awk -F '\\.so' '{print $1".*"}'|tr "\n" " "
echo
echo ======== не хватает `echo $d|wc -w` библиотек ======
echo "$d"
if [ "$d" ]; then
echo
echo "Проверка в содержимом '$1':"
find "$1" \( -type l -or -type f \) -name "$d" -exec echo "$d  найден" \;
fi
