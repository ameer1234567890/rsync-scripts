#!/bin/sh
rsync -ahv --delete --progress --exclude-from /storage/emulated/0/Ameer/rsync-excludes.txt rsync://user@192.168.7.1/usb1/Phone/ /storage/emulated/0
