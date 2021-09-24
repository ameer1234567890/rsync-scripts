param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Write-Host 'Running with full privileges'

New-EventLog -LogName Application -Source SysAdmin

if (($?) -eq $true)  {
    Write-Host -ForegroundColor Green 'Source registration successfull!'
} else {
    Write-Host -ForegroundColor DarkRed 'Source registration failed!'
}
