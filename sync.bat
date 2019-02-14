@ECHO OFF
@rsync rsync://miwifimini/usb1/USB_NOT_MOUNTED >nul 2>&1
@SET STATUS=%ERRORLEVEL%
@IF %STATUS% NEQ 0 rsync -rhtv --delete --progress --fuzzy --delete-delay --modify-window=5 --partial-dir=.rsync-partial --backup --backup-dir="/Laptop.old/backup_%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt /cygdrive/d/ rsync://user@192.168.7.1/usb1/Laptop
@IF %STATUS% EQU 0 ECHO "USB is not mounted at remote! Exiting..."
@PAUSE
