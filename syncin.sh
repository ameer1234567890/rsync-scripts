#!/bin/sh
rsync rsync://miwifimini/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  rsync -ahv --delete --progress --append --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt rsync://user@192.168.7.1/usb1/Phone/ /storage/emulated/0
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
