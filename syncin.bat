@ECHO OFF
SET HOST="miwifimini.lan"

:menu
CHOICE /C YN /M "Are you sure you want to sync data in:" 
IF ERRORLEVEL 2 GOTO :RESET
IF ERRORLEVEL 1 GOTO :SYNC

:SYNC
rsync rsync://%HOST%/usb1/USB_NOT_MOUNTED >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% NEQ 0 rsync -rhtv --delete --progress --stats --partial --partial-dir=.rsync-partial --no-perms --no-owner --no-group --modify-window=5 --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt rsync://user@%HOST%/usb1/Laptop/ /cygdrive/d
IF %STATUS% EQU 0 ECHO "USB is not mounted at remote! Exiting..."
PAUSE
GOTO :eof

:RESET
ECHO "Exiting now!"
PAUSE
GOTO :eof
