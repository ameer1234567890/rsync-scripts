#!/bin/bash

host="nas1.lan"
logger="/system/bin/log -t sync"

log() {
  echo "$2"
  $logger -p "$1" "$2"
  #termux-notification --title 'rsync' --content "$2"
}

ping -c 1 gadhamoo.lan > /dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  vpnrequired=true
  am broadcast -n com.tailscale.ipn/.IPNReceiver -a com.tailscale.ipn.CONNECT_VPN
  sleep 5
fi
ping -w 3 -c 1 $host >/dev/null 2>&1
status="$?"
if [ "$status" != 0 ]; then
  log "e" "Server unavailable!"
  curl -k "https://printer.lan:5001/api/push/tdWHLN5ZQ7?status=down&msg=Error:+Server+unavailable&ping="
else
  rsync rsync://$host/usb1/USB_NOT_MOUNTED >/dev/null 2>&1
  status="$?"
  if [ "$status" != 0 ]; then
    rsync -ahv --copy-links --delete --progress --stats --partial --partial-dir=.rsync-partial --backup --backup-dir="/Ameer/OnePlusNordCE3.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://$host/usb1/Ameer/OnePlusNordCE3
    status="$?"
    if [ "$status" != 0 ]; then
      log "e" "An error occured during backup!"
      curl -k "https://printer.lan:5001/api/push/tdWHLN5ZQ7?status=down&msg=Error:+$status&ping="
    else
      log "i" "Backup successful!"
      curl -k "https://printer.lan:5001/api/push/tdWHLN5ZQ7?status=up&msg=OK&ping="
    fi
  else
    log "e" "USB is not mounted at remote!"
    curl -k "https://printer.lan:5001/api/push/tdWHLN5ZQ7?status=down&msg=Error:+USB+not+mounted&ping="
  fi
fi

if [ $vpnrequired ]; then
  am broadcast -n com.tailscale.ipn/.IPNReceiver -a com.tailscale.ipn.DISCONNECT_VPN
fi
