@ECHO OFF

SET IS_SILENT=0
IF "%1"=="/S" SET IS_SILENT=1

SET HOST="nas1.lan"
SET USER="Ameer/Laptop"
SET UPTIME_KUMA_HOST="printer.lan:3001"
SET UPTIME_KUMA_SLUG="ghQTMSZb2ApAlbUsVHIyFGLmVlGCZEQt"

FOR /F "tokens=1-4 delims=:.," %%a in ("%time%") DO (
  SET /A "START_T=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
PING -w 3 %HOST% >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% NEQ 0 GOTO :ERRNOSRV
rsync rsync://%HOST%/usb1/USB_NOT_MOUNTED >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :ERRNOUSB
powershell ^(Get-Date^).ToString('yyyy-MM-dd_hh.mm.ss') > %~dp0\timestamp.txt
SET /P TIMESTAMP=<%~dp0\timestamp.txt
DEL %~dp0\timestamp.txt
SET TIMESTAMP=backup_%TIMESTAMP%

IF %STATUS% NEQ 0 rsync -rhtv --copy-links --delete --progress --stats --partial --fuzzy --delete-delay --modify-window=5 --partial-dir=.rsync-partial --backup --backup-dir="/%USER%.old/%TIMESTAMP: =0%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt /cygdrive/d/ rsync://%HOST%/usb1/%USER%
SET STATUS=%ERRORLEVEL%
FOR /F "tokens=1-4 delims=:.," %%a in ("%time%") DO (
  SET /A "END_T=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
SET /A RUN_T=(END_T-START_T)/100
IF %STATUS% EQU 0 GOTO :SUCCESS
IF %STATUS% NEQ 0 GOTO :ERRNOBKP

:SUCCESS
curl -k "https://%UPTIME_KUMA_HOST%/api/push/%UPTIME_KUMA_SLUG%?status=up&msg=OK&ping=%RUN_T%"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOBKP
curl -k "https://%UPTIME_KUMA_HOST%/api/push/%UPTIME_KUMA_SLUG%?status=down&msg=Error:+%STATUS%&ping=%RUN_T%"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOSRV
ECHO "Backup server unavailable! Exiting..."
curl -k "https://%UPTIME_KUMA_HOST%/api/push/%UPTIME_KUMA_SLUG%?status=down&msg=Error:+Server+unavailable&ping=0"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOUSB
ECHO "USB is not mounted at remote! Exiting..."
curl -k "https://%UPTIME_KUMA_HOST%/api/push/%UPTIME_KUMA_SLUG%?status=down&msg=Error:+USB+not+mounted&ping=0"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF
