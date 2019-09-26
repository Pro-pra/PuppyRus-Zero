#!/bin/ash
#180109 sfs DDSE
#190923 rewrite for Zero
#190926 find repo package with needed lib
[ ! "$1" ] && echo "Использование: $0 [-base] dir
    Поиск недостающих библиотек для модуля (пакета) распакованного в dir
    если не задан параметр -base поиск выполняется в существующем /usr/lib
    -base - поиск библиотек выполняется только в модуле base" && exit

NO_CHECK=0 #выдать запрос на поиск в онлайн репозитарии Slackware

find_pkg () {
[ "$1" ] || return
#подключиться к серверу и выкачать MANIFEST.bz2
local REPO="http://mirror.yandex.ru/slackware/slackware-current/slackware"
#REPO="http://slackware.cs.utah.edu/pub/slackware/slackware-current/slackware"
 
#получить список из репозитария slackware, записать в файл
[ -f /var/tmp/MANIFEST.bz2 ] || curl $REPO/MANIFEST.bz2 > /var/tmp/MANIFEST.bz2
#найти в содержимом нужный пакет, имя библиотеки передается в параметре функции
[ -f /var/tmp/MANIFEST.bz2 ] && local PKG="`bzgrep --ignore-case --max-count=1 "Package:\|$1" /var/tmp/MANIFEST.bz2 | grep -B1 $1 | awk '/\.txz$/ {print $3}'| cut -b2-`" || return
#скачать пакет
if [ $PKG ]; then 
    echo "Найдено в пакете $PKG"
    curl ${REPO}${PKG} --output . || return
    #wget ${REPO}${PKG} || return
fi
}


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
	:
	else
	    echo "$LIB не найден"
	    if [ `find "$2" \( -type l -or -type f \) -name "$LIB"` ]; then
		echo "$LIB  найден в '$2'"
	    elif [ "$NO_CHECK" = "1" ]; then
		find_pkg $LIB
	    else
		echo "Выполнить поиск пакета содержащего $LIB"
		echo "в репозитарии Slackware?"
		echo -n "Нажмите ENTER для пропуска, или любую букву для поиска."
		read N
		[ $N != "" ] && NO_CHECK=1 && find_pkg $LIB
		
	    fi
	fi
    done
    exit
fi

d="`find "$1" -type f -executable -exec ldd {} \; |awk '/=> not found/ {print $1}'|sort -u`"
#echo -n "cp -d "
#echo "$d" |awk -F '\\.so' '{print $1".*"}'|tr "\n" " "
echo "$d не найден"
if [ "$d" ]; then
echo
    if [ `find "$1" \( -type l -or -type f \) -name "$d"` ]; then
	echo "$d  найден в '$1'"
    elif [ "$NO_CHECK" = "1" ]; then
		find_pkg $LIB
    else
	echo "Выполнить поиск пакета содержащего $d"
	echo "в репозитарии Slackware?"
	echo -n "Нажмите ENTER для пропуска, или любую букву для поиска."
	read N
	[ $N != "" ] && NO_CHECK=1 && find_pkg $d
    fi
fi
