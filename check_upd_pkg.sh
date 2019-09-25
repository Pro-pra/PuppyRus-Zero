#!/bin/bash
#190925 Pro for Zero

usage () {
	echo -e "Поиск обновлений модулей в репозитарии Slackware.\n"
	echo -e "Использование: $(basename $0) -d [dir] \n"
	echo "     dir - путь к точке монтирования модуля или к каталогу"
	echo "           в который распакован модуль. Если не задан dir,"
	echo "           то используется системный каталог /etc/packages/mount"
	echo "           и проверяются обновления для перечисленных в нем модулей."
	echo "     -d  - скачать в текущий каталог пакеты из репозитария" 
	echo "           для последующего обновления в системе."
}

case $1 in
    -h | --help | -help) usage; exit;;
    -d) DOWNLOAD=1; MOD_DIR="$2/etc/packages/mount";;
    *) MOD_DIR="$1/etc/packages/mount";;
esac
	
REPO="http://mirror.yandex.ru/slackware/slackware-current/slackware"
#REPO="http://slackware.cs.utah.edu/pub/slackware/slackware-current/slackware"

#[ -f /var/tmp/slackware.cut.lst ] && rm -f /var/tmp/slackware.cut.lst
#получить список пакетов из репозитария slackware, записать в файл
curl $REPO/FILE_LIST | awk '/\.txz$/ {print $8}'|cut -d / -f 3 > /var/tmp/slackware.cut.lst
#awk '/\.txz$/ {print $8}' ./FILE_LIST | cut -d / -f 3 > /var/tmp/slackware.cut.lst
splitname(){
local ver sver
  ver=$(echo "$1" \
        |sed 's/i[3-6]86\|x86[_-]64\|x64\|[Xx][Ff][_-]\?86\|[Qq][Tt]4\|[Qq][Tt]5/masq/g
              s/_64\|_DEV/_masq/g' \
        |grep -oE '[_-]([A-Za-z]{0,2}[0-9][a-z0-9]*[_.+-])+')
  local re1='\(.*\)' re2='\1' n=1 partver
  for partver in $ver ; do
     n=$(($n+1))
     partver=${partver%?}
     partver=${partver#?}
     re1="${re1}$partver\\(.*\\)"
     re2="${re2}.*\\$n"
     sver="${sver}${sver:+-}$partver"
  done
    #declare -g $2=$(echo "$1" |sed 's/'$re1'/'\\1'/')
    declare -g $2=${1%%-[0-9|p-]*}
    declare -g $3=$sver
}

# newer <версия1> <версия2> - версия1 больше/новее версии2 ?
newer(){ [ "$1" != "$2" -a $(echo -e "$1\n$2"|sort -V|tail -1) == "$1" ] ; }



#берем из /etc/packages/mount названия модулей и ищем их в списке пакетов slackware
for MOD in `ls -A "$MOD_DIR"`
do
    #разделяем название модуля на номер версии и название
    splitname "$MOD" modname modver
    if [ "$modver" ]; then
	#echo "В системе $modname $modver"
	#ищем строку modname в списке файлов
	PKG="`grep --basic-regexp --max-count=1 --ignore-case -w "^$modname" /var/tmp/slackware.cut.lst`"
	#если нашли строку, выделяем имя и номер версии
	if [ "$PKG" ];then 
	    splitname "$PKG" pkgname pkgver 
	    #echo "В репозитарии $pkgname $pkgver"
	    # сравниваем номера версий если определили версию
	    if [ "$pkgver" ]; then 
		newer "$pkgver" "$modver" 
		echo "Для модуля '$MOD' есть обновление в репозитарии '$pkgver'"
		[ $DOWNLOAD = 1 ] && get_slack_txz "$PKG"
	    fi
	fi
    fi
done
