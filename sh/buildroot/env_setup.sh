#!/bin/sh
echo "usage: source env_setup.sh"
ENV_DIR=$(pwd);

TOOLCHAIN=$ENV_DIR/tools/arm-linux-cotex-a9-glibc
if [ -d $TOOLCHAIN ] ;then
	echo "check toolchain ok!"
else
	echo "tar xvf toolchain!"
	cd $ENV_DIR/tools
	tar xvf arm-linux-cotex-a9-glibc.tar.gz
	cd $ENV_DIR 
fi
BR_EXTERNAL=$ENV_DIR/../buildroot/output/.br-external
if [ -f $BR_EXTERNAL ] ;then
	echo "check .br-exteral ok!"
else
	echo "copy .br-external from board"
	cp -fv $ENV_DIR/board/mx6sxc9241/configs/output.br-external $BR_EXTERNAL
fi

export ARCH=arm; 
export CROSS_COMPILE=$ENV_DIR/tools/arm-linux-cotex-a9-glibc/usr/bin/arm-linux-;
echo "ARCH=$ARCH"
echo "CROSS_COMPILE=$CROSS_COMPILE"
