iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco install ConEmu --yes --verbose
choco install slickrun --yes --verbose
choco install python2 --yes --verbose
choco install python3 --yes --verbose
choco install git --yes --verbose
choco install poshgit --yes --verbose
choco install vim --yes --verbose
choco install mssql2014express-defaultinstance --yes --verbose

# yeah that's right. two hours...
# it timed out with the default of 2700 (45 minutes)
# the install still copleted, I just had to monitor it with task manager
choco install visualstudio2015professional --yes --verbose --timeout 7200

#manual install of the following becaue their choco package doesn't work or doesn't exist
# vs addin - vsvim
# vs addin - tabgroupjumber
# vs addin - rebracer
# vs addin - editorconfig
# vs addin - resharper

#enable colors for ls command
Install-Module PSColor

