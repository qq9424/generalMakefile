#!/bin/sh

fw_get(){
	fw_printenv $1 | sed 's/^.*=//g';
}

fw_get_default(){
        value=$(fw_printenv $1 | sed 's/^.*=//g');
        if [ "$value" == "" ]; then                
                value=$2;                        
        fi;                        
        echo $value;         
}
 
fw_set(){
	fw_setenv $1 $2;
	echo "### set env $1=$2, result $(fw_get $1)";
}

net_set(){
	port=$1;
	ip=$2;
	mask=$3
	gw=$4;
	
	echo "### $0: port:$port, ip:$ip, mask:$mask, gw:$gw "
	ifconfig $port $ip netmask $mask;
	route add default gw $gw;

	echo "### check network "
	ifconfig;
	
	echo "### check route "
	route;
}

root_dir_mount(){
	if [ -d /root ]; then
		mount -t ext3 /dev/mmcblk3p3 /root;
	fi;
}

root_dir_umount(){
	if [ -d /root ]; then
		umount /root;
	fi;
}

root_ext3_format(){
	$(root_dir_umount);
	echo "formatting rootfs partition /dev/mmcblk3p3 ..."	
	mkfs.ext3 -E nodiscard /dev/mmcbl3kp3;
}

boot_dir_mount(){
	if [ ! -d /boot ]; then
# system bootpart /dev/mmcblk3p2
		mkdir /boot
	fi;
	
	mount -t vfat -o rw,noatime,shortname=mixed,utf8 /dev/mmcblk3p2 /boot
}

boot_dir_umount(){
	if [ -d /boot ]; then
		umount /boot;
	fi;
}

firmware_default_execute(){
	echo "### ENTER $0 $1 ----- " 	
	IMAGE_DIR=$1

	if [ ! -d $IMAGE_DIR ]; then
		echo "### Error, $IMAGE_DIR not exit"
		return 0;
	fi;
	
	cd $IMAGE_DIR;
	cp -fv zImage* /boot;
	cp -fv *.dtb /boot;

	if [ -f rootfs.tar.bz2 ]; then
		#$(root_ext3_format);
		echo "clear /root ..."
		rm -fr /root/*;
		echo "uncompress rootfs.tar.bz2 ..."
		tar xvf rootfs.tar.bz2 -C /root
		echo "update rootfs success ..."
		
		if [ ! -f /boot/sys_cfg.txt ]; then
			cp -fv /root/www/ini/sys_cfg.txt /boot;
		fi
		echo "cp /boot/sys_cfg.txt ..."
		mv -f /boot/sys_cfg.txt /root/www/ini/
		sync;
	fi
}


firmware_update(){

	$(boot_dir_mount);
	
	UPGADE_FILE=/boot/UPDATE_FIREWARE.bin
	UPDATE_TEMP_DIR=/tmp/firmware_update
	
	if [ -f $UPGADE_FILE  ] ; then
		mkdir $UPDATE_TEMP_DIR;
		echo "### upgrade decode $TARGET_FILE-------- " ;
		upgrade -d $UPGADE_FILE -C $UPDATE_TEMP_DIR;    
		$(root_dir_mount);
		echo "### firmware_default_execute $UPDATE_TEMP_DIR----- " 		
		$(firmware_default_execute $UPDATE_TEMP_DIR);
		$(root_dir_umount);
		rm -f $UPGADE_FILE;
		echo "UPDATE_TRUE, System Reboot";
		$(fw_setenv bootstatus 1);
		/sbin/reboot;
	else
		echo "UPDATE_FALSE"
	fi
	$(boot_dir_umount);
	
}

echo "### Enter $0 ============>"

if [ ! -d /dev/shm ]; then 
        mkdir /dev/shm 
        mkdir /dev/pts 
        mount -a                
fi

bootmode=$(fw_get_default bootmode recovery);
bootstatus=$(fw_get_default bootstatus 0);
ethport=$(fw_get_default ethport eth0);
ipaddr=$(fw_get_default ipaddr 192.168.1.101);
netmask=$(fw_get_default netmask 255.255.255.0);
route=$(fw_get_default route 192.168.1.1);
ethaddr=$(fw_get_default ethaddr 00:89:c0:a8:01:65);

echo "### Uboot net : $ethport $ipaddr $netmask $route";

result=$(firmware_update);
echo "### UPDATE RESULT : $result";

$(root_dir_mount);
if [ -f /root/usr_romfs.bin ] ; then
	mount -t romfs /root/usr_romfs.bin /usr/;
fi

#set net base uboot
net_set $ethport $ipaddr $netmask $route;

echo "### Uboot env : MODE:$bootmode STATUS:$bootstatus";

echo "### Starting BOA : "
. /etc/init.d/script/boa_start.sh 

if [ "$bootmode" == "system" ]; then
. /root/system.sh;
else
. /root/recovery.sh;
fi

echo "### Exit $0 ============>"
