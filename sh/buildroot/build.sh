VER_FILE=VersionInfo.txt
TOP_DIR=$(pwd)
APP_DIR=$TOP_DIR/../buildroot
KERNEL_DIR=$TOP_DIR/kernel/linux-imx
MKROOTFS_DIR=$TOP_DIR/mkrootfs
VERSION='HEAD'

while true;do 
read -p "Check for modification?(yes/no)[no]" CHECK 
case $CHECK in 
Y|y|YES|yes) 
		CHECK=true 
		break;; 
N|n|NO|no) 
		CHECK=false 
		break;; 
"") 
		CHECK=false 
		break;; 
esac 
done 

if [ $CHECK = true ]
then
	echo "Check for modification"
	MODIFY=$(svn st -q | grep '\.c$\|\.h$\|config$')
	if [ "$MODIFY" ]
	then
		echo "Resouce file below have been modified, please commit or revert them!"
		echo $MODIFY
	exit 1
	fi
	
	echo "Update to $VERSION" 
	svn up -r $VERSION
fi

echo "Generate version file"
BUILD_VER=$(svn info | grep '^Revision:' | awk '{print $NF}')
if [ -z "$BUILD_VER" ]
then
BUILD_VER=$(svn info | grep '^版本:' | awk '{print $NF}')
fi

DEVNAME_DEF=XC9241
read -p "Please enter product name[$DEVNAME_DEF]:" DEVNAME
if [ -z $DEVNAME ]
then
	DEVNAME=$DEVNAME_DEF
fi

DATE_DEF=$(date "+%Y-%m-%d")
echo "Please enter date"
echo $DATE_DEF 

read   DATE
if [ -z $DATE ]
then
        DATE=$DATE_DEF
fi

YEAR=$(echo $DATE | cut -d'-' -f1)
MON=$(echo $DATE | cut -d'-' -f2)
DAY=$(echo $DATE | cut -d'-' -f3)

if [ -z $YEAR ] || [ -z $MON ] || [ -z $DAY ]
then
        echo "Release date formate error"
        exit 1
fi
VER_DEF="1.1.0.0"
read -p "Please enter version(x.x.x.x)[1.1.0.0]:" RELEASE_VER
if [ -z $RELEASE_VER ]
then
        RELEASE_VER=$VER_DEF
fi

MAJOR=$(echo $RELEASE_VER | cut -d'.' -f1)
MINOR=$(echo $RELEASE_VER | cut -d'.' -f2)
INNER=$(echo $RELEASE_VER | cut -d'.' -f3)
REVISE=$(echo $RELEASE_VER | cut -d'.' -f4)

if [ -z $MAJOR ] || [ -z $MINOR ] || [ -z $INNER ] || [ -z $REVISE ]
then
	echo "Release version formate error"
	exit 1
fi

VERDEFAULT=标准
read -p "Please enter version info[$VERDEFAULT]:" VERINFO
if [ -z $VERINFO ]
then
	VERINFO=$VERDEFAULT
fi

echo "[$DEVNAME]" > $VER_FILE
echo "[version_info]" >> $VER_FILE
echo "devName=$DEVNAME" >> $VER_FILE
echo "verMajor=$MAJOR" >> $VER_FILE
echo "verMinor=$MINOR" >> $VER_FILE
echo "verInner=$INNER" >> $VER_FILE
echo "verRev=$REVISE" >> $VER_FILE
echo "verBuild=$BUILD_VER" >> $VER_FILE
echo "verInfo=$VERINFO" >> $VER_FILE
echo "verYear=$YEAR" >> $VER_FILE
echo "verMonth=$MON" >> $VER_FILE
echo "verDay=$DAY" >> $VER_FILE

cat $VER_FILE
mv -f $VER_FILE $MKROOTFS_DIR

while true;do 
read -p "Clean app before make?(yes/no)[no]" IS_CLEAN
case $IS_CLEAN in
Y|y|YES|yes)
        IS_CLEAN=true
        break;;
N|n|NO|no)
        IS_CLEAN=false
        break;;
"")
        IS_CLEAN=false
        break;;
esac
done

if [ $IS_CLEAN = true ]
then
        cd $APP_DIR && make clean
fi

while true;do
read -p "Clean kernel before make?(yes/no)[no]" IS_CLEAN
case $IS_CLEAN in
Y|y|YES|yes)
        IS_CLEAN=true
        break;;
N|n|NO|no)
        IS_CLEAN=false
        break;;
"")
        IS_CLEAN=false
        break;;
esac
done

if [ $IS_CLEAN = true ]
then
        cd $KERNEL_DIR && make clean
fi

cd $TOP_DIR && . $TOP_DIR/env_setup.sh
cd $APP_DIR && make
cd $MKROOTFS_DIR && ./mkromfs.sh 

cd $KERNEL_DIR
rm -f arch/arm/boot/zImage
rm -f usr/initramfs_data.cpio.gz
make 

cd $TOP_DIR && . $TOP_DIR/cp_image.sh
cd $TOP_DIR/upgrade && ./mk-upgrade-allin.sh

echo "Build Success ! "
cd  $TOP_DIR
