OUTPUT=output
rm -fr $OUTPUT
mkdir  $OUTPUT
cp ../mkrootfs/VersionInfo.txt  $OUTPUT  -f
cp upgrade.sh $OUTPUT -f
cp ../image/* $OUTPUT -f
./upgrade-x86 -C $OUTPUT
mv *.bin $OUTPUT -f
#mv $OUTPUT ../ -f

