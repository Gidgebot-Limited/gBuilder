<#
    This script initializes the LocalModule Classes and Functions
    /home/gbuilder/pwsh/start-localmod.ps1
#>


$psScriptRoot | get-childitem -recurse -Include "*.psm1" | Import-Module

$env:psModulePath += ";$($psScriptRoot)\classes"

$config = Get-Content -Path $psScriptRoot\config.json -Raw | ConvertFrom-Json


$today = Get-Date -Format "MM-dd-yy"

$midnightEpoch = (convertto-epoch (get-date ((Get-Date).AddDays(-1)) -Format "MM-dd-yy") )

exit