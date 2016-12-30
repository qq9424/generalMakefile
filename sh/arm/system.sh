#!/bin/sh
fw_set(){
	fw_setenv $1 $2;
	echo "### set env $1=$2, result $(fw_get $1)";
}

fw_get_default(){
        value=$(fw_printenv $1 | sed 's/^.*=//g');
        if [ "$value" == "" ]; then                
                value=$2;                        
        fi;                        
        echo $value;         
}
	
echo "### Starting compare_cfg : "
cp -f /root/www/ini/sys_cfg.txt /var/www/ini/sys_cfg.txt 
compare_cfg /var/www/ini/ini_bak/sys_cfg.txt /var/www/ini/sys_cfg.txt;
echo "### Starting net_cfg_set : "
ipaddr=$(fw_get_default ipaddr 192.168.1.101);
network_set /var/www/ini/sys_cfg.txt $ipaddr
echo "### Starting telnetd : "
telnetd
echo "### Starting watch_dog : "
watch_dog &
echo "### Starting NCS : "
ncs &
$(fw_set bootstatus 1);

echo "### Exit $0 ============>"
