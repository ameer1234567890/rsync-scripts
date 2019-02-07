#!/bin/sh
rsync -ahv --delete --progress --backup --backup-dir="/Phone.old/backup_$(date +%Y-%m-%d)" --exclude-from /storage/emulated/0/rsync-excludes.txt /storage/emulated/0/ rsync://pi@192.168.100.34/hdd/Phone
status="$?"
if [ "$status" != 0 ]; then
  termux-notification --title "Error!" --content "An error occured during backup!"
else
  termux-notification --title "Success" --content "Backup successful"
fi
