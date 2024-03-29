
Set-PSReadlineOption -EditMode Vi
Import-Module PSColor

# function prompt {"> "}

Import-Module posh-git

# starship disabled due to performance bug
#Invoke-Expression (&starship init powershell)

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
