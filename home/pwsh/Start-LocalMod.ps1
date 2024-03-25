<#
    This script initializes the LocalModule Classes and Functions
    /home/gbuilder/pwsh/start-localmod.ps1
#>

$rzmod = '/home/gbuilder/pwsh'
Get-ChildItem $rzmod -recurse -Include "*.psm1" | Import-Module
$env:PSModulePath += ";$($rzmod)"

$config = Get-Content -Path '/home/gbuilder/pwsh/config.json' -Raw | ConvertFrom-Json

$today = Get-Date -Format "MM-dd-yy"

$midnightEpoch = (convertto-epoch (get-date ((Get-Date).AddDays(-1)) -Format "MM-dd-yy") )