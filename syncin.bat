@ECHO OFF

:menu
CHOICE /C YN /M "Are you sure you want to sync data in:" 
IF ERRORLEVEL 2 GOTO reset
IF ERRORLEVEL 1 GOTO deltemp

:deltemp
@rsync -rtv --delete --progress --no-perms --no-owner --no-group --modify-window=5 --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt rsync://user@192.168.7.1/usb1/Laptop/ /cygdrive/d
@GOTO theend

:reset
ECHO "Exiting now!"
@GOTO theend

:theend
@PAUSE
