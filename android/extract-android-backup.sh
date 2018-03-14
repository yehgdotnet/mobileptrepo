#!/usr/bin/env bash

# Myo Soe, https://yehg.net

echo ""
echo "Extracting backup.ab using zpipe - Myo Soe, https://yehg.net"
echo ""
echo "Warning: removing backup.zlib and backup.tar in existing directory"
echo ""
rm backup.zlib
rm backup.tar
rm -rf backup
mkdir ./backup
dd if=backup.ab bs=24 skip=1 of=backup.zlib
./zpipe -d < backup.zlib > backup.tar
tar xvf backup.tar -C ./backup/
rm backup.zlib
ls -ls echo > ./backup/backup-file-listing.txt
cat ./backup/backup-file-listing.txt

