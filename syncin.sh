#!/bin/sh
rsync -ahv --delete --progress --append --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt rsync://user@192.168.7.1/usb1/Phone/ /storage/emulated/0
printf "Press enter to exit..."
read -r
