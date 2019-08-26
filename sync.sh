#!/bin/sh
host="192.168.100.44"
logger="/system/bin/log -t sync"

log() {
  echo "$@"
  $logger -p e "$@"
  termux-notification --title 'rsync' --content "$@"
}

ping -w 3 -c 1 $host >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  log "Server unavailable!"
else
  rsync rsync://$host/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
  status="$?"
  if [ "$status" != 0 ]; then
    rsync -ahv --copy-links --delete --progress --stats --partial --partial-dir=.rsync-partial --backup --backup-dir="/Ameer/Phone.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://user@$host/usb1/Ameer/Phone
    status="$?"
    if [ "$status" != 0 ]; then
      log "An error occured during backup!"
    else
      log "Backup successful!"
    fi
  else
    log "USB is not mounted at remote!"
  fi
fi
