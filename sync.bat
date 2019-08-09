@ECHO OFF
SET HOST="miwifimini.lan"

PING -w 3 %HOST% >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% NEQ 0 GOTO :ERROR_NOSRV
rsync rsync://%HOST%/usb1/USB_NOT_MOUNTED >nul 2>&1
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :ERROR_NOUSB
IF %STATUS% NEQ 0 rsync -rhtv --delete --progress --partial --fuzzy --delete-delay --modify-window=5 --partial-dir=.rsync-partial --backup --backup-dir="/Ameer/Laptop.old/backup_%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%.%TIME:~3,2%.%TIME:~6,2%" --exclude-from /cygdrive/d/Ameer/rsync-excludes.txt /cygdrive/d/ rsync://user@%HOST%/usb1/Ameer/Laptop
SET STATUS=%ERRORLEVEL%
IF %STATUS% EQU 0 GOTO :SUCCESS
IF %STATUS% NQU 0 GOTO :ERROR_NOBKP

:SUCCESS
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup completed successfully!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Information'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Info'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :eof

:ERROR_NOBKP
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='An error occured during backup! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :eof

:ERROR_NOSRV
ECHO "Backup server unavailable! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='Backup server unavailable! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :eof

:ERROR_NOUSB
ECHO "USB is not mounted at remote! Exiting..."
powershell -Command "[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $objNotifyIcon=New-Object System.Windows.Forms.NotifyIcon; $objNotifyIcon.BalloonTipText='USB is not mounted at remote! Please try again later!'; $objNotifyIcon.Icon=[system.drawing.systemicons]::'Error'; $objNotifyIcon.BalloonTipTitle='Backup'; $objNotifyIcon.BalloonTipIcon='Error'; $objNotifyIcon.Visible=$True; $objNotifyIcon.ShowBalloonTip(5000);"
PAUSE
GOTO :eof
