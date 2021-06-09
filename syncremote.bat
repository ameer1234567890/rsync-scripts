@ECHO OFF

SET IS_SILENT=0
IF "%1"=="/S" SET IS_SILENT=1

SET HOST="home.ameer.io"

PING -w 3 %HOST% >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% NEQ 0 GOTO :ERRNOSRV
rsync -e "ssh -p 1022" pi@%HOST%:/mnt/usb1/USB_NOT_MOUNTED >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :ERRNOUSB
SET TIMESTAMP=backup_%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%.%TIME:~3,2%.%TIME:~6,2%
IF %STATUS% NEQ 0 rsync -rhtvz --copy-links --delete --progress --stats --partial --fuzzy --delete-delay --modify-window=5 --partial-dir=.rsync-partial --backup --backup-dir="/mnt/usb1/Ameer/Laptop.old/%TIMESTAMP: =0%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt -e "ssh -p 1022" /cygdrive/d/ pi@%HOST%:/mnt/usb1/Ameer/Laptop
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :SUCCESS
IF %STATUS% NEQ 0 GOTO :ERRNOBKP

:SUCCESS
IF %IS_SILENT% EQU 1 EXIT
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup completed successfully!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Information'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Info'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :EOF

:ERRNOBKP
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='An error occured during backup! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOSRV
ECHO "Backup server unavailable! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup server unavailable! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOUSB
ECHO "USB is not mounted at remote! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='USB is not mounted at remote! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF
