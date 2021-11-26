@ECHO OFF

SET IS_SILENT=0
IF "%1"=="/S" SET IS_SILENT=1

SET HOST="home.ameer.io"
SET PORT=1022

PING -w 3 %HOST% >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% NEQ 0 GOTO :ERRNOSRV
rsync -e "ssh -p 1022" pi@%HOST%:/mnt/usb1/USB_NOT_MOUNTED >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :ERRNOUSB
powershell ^(Get-Date^).ToString('yyyy-MM-dd_hh.mm.ss') > %~dp0\timestamp.txt
SET /P TIMESTAMP=<%~dp0\timestamp.txt
DEL %~dp0\timestamp.txt
SET TIMESTAMP=backup_%TIMESTAMP%

IF %STATUS% NEQ 0 rsync -rhtvz --copy-links --delete --progress --stats --partial --fuzzy --delete-delay --modify-window=5 --partial-dir=.rsync-partial --backup --backup-dir="/mnt/usb1/Ameer/Laptop.old/%TIMESTAMP: =0%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt -e "ssh -p %PORT%" /cygdrive/d/ pi@%HOST%:/mnt/usb1/Ameer/Laptop
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :SUCCESS
IF %STATUS% NEQ 0 GOTO :ERRNOBKP

:SUCCESS
powershell -Command "Write-EventLog -LogName Application -Source SysAdmin -EntryType Information -Message 'Backup completed successfully!' -EventId 1"
IF %IS_SILENT% EQU 1 EXIT
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup completed successfully!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Information'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Info'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :EOF

:ERRNOBKP
powershell -Command "Write-EventLog -LogName Application -Source SysAdmin -EntryType Error -Message 'An error occured during backup!' -EventId 1"
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='An error occured during backup! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOSRV
powershell -Command "Write-EventLog -LogName Application -Source SysAdmin -EntryType Error -Message 'Backup server unavailable!' -EventId 1"
ECHO "Backup server unavailable! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup server unavailable! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF

:ERRNOUSB
powershell -Command "Write-EventLog -LogName Application -Source SysAdmin -EntryType Error -Message 'USB is not mounted at remote!' -EventId 1"
ECHO "USB is not mounted at remote! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='USB is not mounted at remote! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
IF %IS_SILENT% EQU 1 EXIT
PAUSE
GOTO :EOF
