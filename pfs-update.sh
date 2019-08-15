#!/bin/sh
DEL=""
BASENAME=zero-base-1908.pfs #название модуля
ISODIR=Zero-iso # путь к каталогу в котором находятся файлы для будущего iso
BASEDIR=packages-base #каталог в котором хранятся модули из которых делается base.pfs
BASEPFS="`ls -1 $ISODIR/zero/base | grep base`" #имя файла .pfs

NEWP="`ls -1 $BASEDIR/new/`" #каталог с файлами .pfs которые нужно добавить (обновить) в модуле base 
if [ "$NEWP" ]; then
#поиск названий пакетов для удаления
for NEW in `ls -1 $BASEDIR/new/` 
do
	NEW="`basename $NEW .pfs`"
	PKGNAME="`echo -n "$NEW" | sed -e 's/\-[0-9].*$//g'`" # обрезаем полное название пакета чтобы получить короткое (без версии)
	DELPKG=`pfsinfo $ISODIR/$BASEPFS | grep -m 1 $PKGNAME`
	DEL="$DEL $DELPKG"
done

# удаление пакетов
pfsmerge $ISODIR/$BASEPFS $ISODIR/pupm-cut.pfs -c $DEL --clean

#удаление старого файла pfs при условии что удаление пакетов завершилось успешно
[ "$?" -eq 0 ] && rm -f $ISODIR/$BASEPFS


# добавление новых пакетов
pfsmerge $BASEDIR/new/ $ISODIR/pupm-cut.pfs $ISODIR/$BASENAME
rm -rf $ISODIR/pupm-cut.pfs
fi

#переносим обновленные файлы в основной каталог модулей (предыдущие версии удаляются вручную)
mv -f $BASEDIR/new/* $BASEDIR
#здесь можно вписать команду для синхронизации основного каталога модулей с ftp или перед тем как переносить файлы
#из new сделать их выкладывание на ftp.
exit 0
