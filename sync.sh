#!/bin/sh
ifttt_key='YOUR_IFTTT_WEBHOOK_KEY_HERE'
rsync rsync://192.168.100.44/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  rsync -ahv --delete --progress --partial --partial-dir=.rsync-partial --backup --backup-dir="/Ameer/Phone.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://user@192.168.100.44/usb1/Ameer/Phone
  status="$?"
  if [ "$status" != 0 ]; then
    curl -s -X POST https://maker.ifttt.com/trigger/rsyc_event/with/key/$ifttt_key --data 'value1=An+error+occured+during+backup!'
  else
    curl -s -X POST https://maker.ifttt.com/trigger/rsync_event/with/key/$ifttt_key --data 'value1=Backup+successful!'
  fi
else
  echo "USB is not mounted at remote! Exiting..."
  termux-notification --title "Error!" --content "USB is not mounted at remote!"
fi
