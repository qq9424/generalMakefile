#!/bin/sh
#

export QT_QPA_GENERIC_PLUGINS=evdevtouch:/dev/input/event0
export QT_QPA_PLATFORM=linuxfb:fb=/dev/fb0

export QT_PLUGIN_PATH=/usr/lib/qt/plugins/
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins/platforms
export LD_LIBRARY_PATH=/lib:/usr/lib:$LD_LIBRARY_PATH
export QT_QPA_FONTDIR=/usr/lib/fonts
export QT_LOGGING_RULES=qt.qpa.input=true
route add default gw 192.168.1.1
mkdir -p /mnt/nand1-2/www/ini
echo "config qt enviroment"

