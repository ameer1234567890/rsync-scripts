#!/bin/sh
rsync -ahv --delete --progress --backup --backup-dir="/Phone.old/backup_$(date +%Y-%m-%d)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://user@192.168.7.1/usb1/Phone
printf "Press enter to exit..."
read -r
