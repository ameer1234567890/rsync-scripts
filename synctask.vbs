Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "CMD /C START /MIN " & CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\sync.bat /S", 7
Set objShell = Nothing
