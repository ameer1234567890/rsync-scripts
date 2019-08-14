#!/bin/sh
host="192.168.100.44"
ifttt_key="YOUR_IFTTT_WEBHOOK_KEY_HERE"
logger="/system/bin/log -t sync"

ping -w 3 -c 1 $host >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  echo "Server unavailable!"
  $logger -p e "Server unavailable!"
  curl -s -X POST https://maker.ifttt.com/trigger/rsync_event/with/key/$ifttt_key --data 'value1=Server+unavailable!' >/dev/null 2>&1
else
  rsync rsync://$host/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
  status="$?"
  if [ "$status" != 0 ]; then
    rsync -ahv --copy-links --delete --progress --stats --partial --partial-dir=.rsync-partial --backup --backup-dir="/Ameer/Phone.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://user@$host/usb1/Ameer/Phone
    status="$?"
    if [ "$status" != 0 ]; then
      echo "An error occured during backup!"
      $logger -p e "An error occured during backup!"
      curl -s -X POST https://maker.ifttt.com/trigger/rsyc_event/with/key/$ifttt_key --data 'value1=An+error+occured+during+backup!' >/dev/null 2>&1
    else
      echo "Backup successful!"
      $logger -p i "Backup successful!"
      curl -s -X POST https://maker.ifttt.com/trigger/rsync_event/with/key/$ifttt_key --data 'value1=Backup+successful!' >/dev/null 2>&1
    fi
  else
    echo "USB is not mounted at remote!"
    $logger -p e "USB is not mounted at remote!"
    curl -s -X POST https://maker.ifttt.com/trigger/rsync_event/with/key/$ifttt_key --data 'value1=USB+is+not+mounted+at+remote!' >/dev/null 2>&1
  fi
fi
