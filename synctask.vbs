Dim objShell, objFSO
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

objShell.Run "CMD /C START /MIN " & objFSO.GetParentFolderName(WScript.ScriptFullName) & "\sync.bat /S", 7
