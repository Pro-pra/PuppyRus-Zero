#!/bin/sh
DEL=""
ISODIR=isolinux-builds
BASEDIR=packages-base
XORGDIR=packages-xorg
WMDIR=packages-Icewm
BASEPFS="`ls -1 $ISODIR | grep base`" #имя файла pupm-218-base.pfs
XORGPFS="`ls -1 $ISODIR/packages | grep xorg`"
WMPFS="`ls -1 $ISODIR/packages | grep puppyrus-icewm`"

NEWP="`ls -1 $BASEDIR/new/`"
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
pfsmerge $BASEDIR/new/ $ISODIR/pupm-cut.pfs $ISODIR/pupm-218-base.pfs
rm -rf $ISODIR/pupm-cut.pfs
fi

DEL=""

NEWP="`ls -1 $XORGDIR/new/`"
if [ "$NEWP" ]; then
for NEW in `ls -1 $XORGDIR/new/` 
do
	NEW="`basename $NEW .pfs`"
	PKGNAME="`echo -n "$NEW" | sed -e 's/\-[0-9].*$//g'`" # обрезаем полное название пакета чтобы получить короткое (без версии)
	DELPKG=`pfsinfo $ISODIR/packages/$XORGPFS | grep -m 1 $PKGNAME`
	DEL="$DEL $DELPKG"
done

# удаление пакетов
pfsmerge $ISODIR/packages/$XORGPFS $ISODIR/packages/xorg-cut.pfs -c $DEL --clean

#удаление старого файла pfs при условии что удаление пакетов завершилось успешно
[ "$?" -eq 0 ] && rm -f $ISODIR/packages/$XORGPFS

# добавление новых пакетов
pfsmerge $XORGDIR/new/ $ISODIR/packages/xorg-cut.pfs $ISODIR/packages/xorg-meta-`date "+%y.%m"`.pfs
rm -rf $ISODIR/packages/xorg-cut.pfs
fi

DEL=""

NEWP="`ls -1 $WMDIR/new/`"
if [ "$NEWP" ]; then
for NEW in `ls -1 $WMDIR/new/` 
do
	NEW="`basename $NEW .pfs`"
	PKGNAME="`echo -n "$NEW" | sed -e 's/\-[0-9].*$//g'`" # обрезаем полное название пакета чтобы получить короткое (без версии)
	DELPKG=`pfsinfo $ISODIR/packages/$WMPFS | grep -m 1 $PKGNAME`
	DEL="$DEL $DELPKG"
done

# удаление пакетов
pfsmerge $ISODIR/packages/$WMPFS $ISODIR/packages/puppyrus-cut.pfs -c $DEL --clean

#удаление старого файла pfs при условии что удаление пакетов завершилось успешно
[ "$?" -eq 0 ] && rm -f $ISODIR/packages/$WMPFS

# добавление новых пакетов
pfsmerge $WMDIR/new/ $ISODIR/packages/puppyrus-cut.pfs $ISODIR/packages/puppyrus-icewm-`date "+%y.%m"`.pfs
rm -rf $ISODIR/packages/puppyrus-cut.pfs
fi

mv -f $BASEDIR/new/* $BASEDIR
mv -f $XORGDIR/new/* $XORGDIR
mv -f $WMDIR/new/* $WMDIR
exit