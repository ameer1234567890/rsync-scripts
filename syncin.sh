#!/bin/sh
host="192.168.100.71"

rsync rsync://$host/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  rsync -rlpgohv --delete --progress --stats --partial --partial-dir=.rsync-partial --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt rsync://user@$host/usb1/Ameer/Phone/ /storage/emulated/0
  status="$?"
  if [ "$status" != 0 ]; then
    termux-notification --title "Error!" --content "An error occured during restore!"
  else
    termux-notification --title "Success" --content "Restore successful"
  fi
else
  echo "USB is not mounted at remote! Exiting..."
  termux-notification --title "Error!" --content "USB is not mounted at remote!"
fi
