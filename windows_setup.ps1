iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco install ConEmu --yes --verbose
choco install slickrun --yes --verbose
choco install git --yes --verbose
choco install poshgit --yes --verbose
choco install vim --yes --verbose
choco install vscode --yes

#choco install sql-server-express
#choco install mssql2014express-defaultinstance --yes --verbose
#choco install visualstudio2019professional --yes
#manual install of the following becaue their choco package doesn't work or doesn't exist
# vs addin - vsvim
# vs addin - tabgroupjumber
# vs addin - rebracer
# vs addin - editorconfig
# vs addin - resharper

#enable colors for ls command
Install-Module PSColor

