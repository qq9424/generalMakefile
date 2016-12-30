. env_setup.sh
cd kernel/linux-imx/
make

cd -
cp bootloader/uboot-imx/u-boot.imx image/u-boot-mx6sxc9241.imx -fv
cp kernel/linux-imx/arch/arm/boot/zImage image/zImage-mx6sxc9241 -fv
cp kernel/linux-imx/arch/arm/boot/dts/mx6sxc9241.dtb image/mx6sxc9241.dtb -fv
cp mkrootfs/rootfs.tar.bz2 image/ -fv

cp image/* ~/tftpboot/ -fv
