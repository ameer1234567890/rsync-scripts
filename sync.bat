@ECHO OFF
@rsync -rhtv --delete --progress --append --fuzzy --delete-delay --modify-window=5 --backup --backup-dir="/Laptop.old/backup_%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt /cygdrive/d/ rsync://user@192.168.7.1/usb1/Laptop
@PAUSE
