Dim objShell,objFSO
Set objShell=CreateObject("WScript.Shell")
Set objFSO=CreateObject("Scripting.FileSystemObject")

'enter the PowerShell expression you need to use short filenames and paths
strExpression=objFSO.GetParentFolderName(WScript.ScriptFullName) & "\sync.bat /S"

strCMD="powershell -nologo  -command " & Chr(34) & "&{" & strExpression &"}" & Chr(34)

'Uncomment next line for debugging
'WScript.Echo strCMD

'use 0 to hide window
objShell.Run strCMD,0
