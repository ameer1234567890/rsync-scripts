#!/bin/sh
rsync -ahv --delete --progress --backup --backup-dir="/Phone.old/backup_$(date +%Y-%m-%d)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://user@192.168.7.1/usb1/Phone
status="$?"
if [ "$status" != 0 ]; then
  termux-notification --title "Error!" --content "An error occured during backup!"
else
  termux-notification --title "Success" --content "Backup successful"
fi
