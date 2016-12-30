#!/bin/sh

IMX6_DIR=..
#BOARD=$1
BOARD=mx6sxc9241
ROOTFS_TAR=rootfs.tar.bz2

if [ $BOARD ] && [ -d $IMX6_DIR/board/$BOARD ]; then
	echo "=========================>start mkramfs for board $BOARD"
else
	echo "error,can not find board $BOARD"
	exit 1	
fi

sudo rm -fr ramfs
mkdir ramfs

sudo rm -fr rootfs
mkdir rootfs

sudo rm $ROOTFS_TAR -fv

cp $IMX6_DIR/../buildroot/output/images/rootfs.tar . -fv
sudo tar xf rootfs.tar -C ramfs/
sudo rm rootfs.tar -f

sudo cp $IMX6_DIR/board/$BOARD/image/script ramfs/etc/init.d -fvr
sudo cp $IMX6_DIR/board/$BOARD/image/firmware ramfs/usr/ -fvr
#sudo cp $IMX6_DIR/board/$BOARD/image/app ramfs/root/ -fvr
sudo cp $IMX6_DIR/board/$BOARD/image/boa.conf ramfs/etc/boa/ -fvr
sudo cp $IMX6_DIR/board/$BOARD/image/syslog.conf ramfs/etc/ -fvr
sudo cp VersionInfo.txt ramfs/var/www/ini/ -fvr

#sudo cp rootfs/var/www/pages/Menu_Ramfs.htm ramfs/var/www/pages/Menu.htm -fv
#sudo cp rootfs/var/www/pages/Firmware_Ramfs.htm ramfs/var/www/pages/Firmware.htm -fv

sudo cp $IMX6_DIR/board/$BOARD/image/fstab_ramfs ramfs/etc/fstab -fv
sudo cp $IMX6_DIR/board/$BOARD/image/fw_printenv/* ramfs/sbin/ -fv
sudo cp $IMX6_DIR/board/$BOARD/image/S90Ramfs ramfs/etc/init.d/S90app -fv
sudo mv ramfs/usr/sbin/* ramfs/sbin/ -f
sudo rm ../kernel/linux-imx/usr/initramfs_data.cpio.gz -f
#sudo tar -cjf $ROOTFS_TAR -C rootfs/ .

#######################################################################
#sudo mv  ramfs/usr/bin rootfs/ -f
sudo genromfs -f usr_romfs.bin -d ramfs/usr
sudo mv usr_romfs.bin rootfs/ -f
sudo rm -fr ramfs/usr/*
sudo mv -f ramfs/etc/init.d/script/system.sh rootfs/ 
sudo mv -f ramfs/etc/init.d/script/recovery.sh rootfs/ 
sudo cp $IMX6_DIR/board/$BOARD/image/app/* rootfs/ -fr
sudo tar -cjf $ROOTFS_TAR -C rootfs/ .

sudo chmod 755 ramfs/root/ -R
sudo chmod 755 ramfs/etc/ -R
sudo rm ../kernel/ramfs -fr
sudo cp ramfs/ ../kernel/ -fr
