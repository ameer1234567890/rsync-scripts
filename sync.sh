#!/bin/bash

host="nas1.lan"
backup_usb="usb1"
this_device="Ameer/OnePlusNordCE3"
uptime_kuma_host="printer.lan:3001"
uptime_kuma_slug="hdNaLPFVI1uGFAHQwOswARI7w2OhCMQg"
logger="/system/bin/log -t sync"

log() {
  echo "$2"
  $logger -p "$1" "$2"
  #termux-notification --title 'rsync' --content "$2"
}

start_t=$(date +%s)
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
  curl -k "https://$uptime_kuma_host/api/push/$uptime_kuma_slug?status=down&msg=Error:+Server+unavailable&ping="
else
  cd "$(dirname "$0")" || exit
  rsync rsync://$host/$backup_usb/USB_NOT_MOUNTED >/dev/null 2>&1
  status="$?"
  if [ "$status" != 0 ]; then
    rsync -ahv --copy-links --delete --progress --stats --partial --partial-dir=.rsync-partial --log-file=backup.log --backup --backup-dir="/$this_device.old/backup_$(date +%Y-%m-%d_%H.%M.%S)" --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt /storage/emulated/0/ rsync://$host/$backup_usb/$this_device
    status="$?"
    end_t=$(date +%s)
    run_t=$(expr "$end_t" - "$start_t")
    if [ "$status" != 0 ]; then
      error_msg=$(tail -1 backup.log)
      error_msg=${error_msg#*]}
      error_msg=$(echo $error_msg | sed -e 's:%:%25:g;s: :%20:g;s:<:%3C:g;s:>:%3E:g;s:#:%23:g;s:{:%7B:g;s:}:%7D:g;s:|:%7C:g;s:\\:%5C:g;s:\^:%5E:g;s:~:%7E:g;s:\[:%5B:g;s:\]:%5D:g;s:`:%60:g;s:;:%3B:g;s:/:%2F:g;s:?:%3F:g;s^:^%3A^g;s:@:%40:g;s:=:%3D:g;s:&:%26:g;s:\$:%24:g;s:\!:%21:g;s:\*:%2A:g')
      log "e" "Error: $error_msg"
      curl -k "https://$uptime_kuma_host/api/push/$uptime_kuma_slug?status=down&msg=Error:+$error_msg&ping=$run_t"
    else
      log "i" "Backup successful!"
      curl -k "https://$uptime_kuma_host/api/push/$uptime_kuma_slug?status=up&msg=OK&ping=$run_t"
    fi
  else
    log "e" "USB is not mounted at remote!"
    curl -k "https://$uptime_kuma_host/api/push/$uptime_kuma_slug?status=down&msg=Error:+USB+not+mounted&ping=$run_t"
  fi
fi

if [ $vpnrequired ]; then
  am broadcast -n com.tailscale.ipn/.IPNReceiver -a com.tailscale.ipn.DISCONNECT_VPN
fi
