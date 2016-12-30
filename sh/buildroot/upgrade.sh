mount -t vfat -o remount,rw,noatime,shortname=mixed,utf8 /dev/sda1 /mnt/nand1-1
cp -f /mnt/nand1-2/www/ini/sys_cfg.txt /mnt/nand1-1/
fuser -k /mnt/nand1-2/*
rm -rf /mnt/nand1-2/*

cp -f conprog.bin /mnt/nand1-1/
cp -f lib_usr_romfs.bin /mnt/nand1-1/
cp -f nand1-2.tar.gz /mnt/nand1-2/

if [ -f /mnt/nand1-2/nand1-2.tar.gz ]; then
        cd /mnt/nand1-2
        tar zxpf nand1-2.tar.gz
        rm -f nand1-2.tar.gz
fi

#compare_cfg /mnt/nand1-2/www/ini/sys_cfg.txt /mnt/nand1-1/sys_cfg.txt
mv -f /mnt/nand1-1/sys_cfg.txt /mnt/nand1-2/www/ini/
mount -t vfat -o remount,ro,noatime,shortname=mixed,utf8 /dev/sda1 /mnt/nand1-1
sync
reboot
