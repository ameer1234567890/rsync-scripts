#!/bin/sh
host="home.ameer.io"
port=1022
logger="/system/bin/log -t sync"

log() {
  echo "$2"
  $logger -p "$1" "$2"
  termux-notification --title 'rsync' --content "$2"
}

ping -w 3 -c 1 $host >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  log "e" "Server unavailable!"
else
  rsync -e "ssh -p $port" pi@$host:/mnt/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
  status="$?"
  if [ "$status" != 0 ]; then
    rsync -ahv -e "ssh -p $port" --copy-links --delete --progress --stats --partial --partial-dir=.rsync-partial --backup --backup-dir="/mnt/usb1/Ameer/OnePlusNordN10.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ pi@$host:/mnt/usb1/Ameer/OnePlusNordN10
    status="$?"
    if [ "$status" != 0 ]; then
      log "e" "An error occured during backup!"
    else
      log "i" "Backup successful!"
    fi
  else
    log "e" "USB is not mounted at remote!"
  fi
fi
