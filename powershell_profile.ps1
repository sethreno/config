$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }
Write-Host "persistent history enabled ($HistoryFilePath)"

Set-PSReadlineOption -EditMode Vi
Write-Host "vi mode enabled :D"

Import-Module PSColor

