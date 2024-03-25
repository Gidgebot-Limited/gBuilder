Function Install-Upload {
  
    [CmdletBinding()]
    param (
        [string]$Path = "."
    )
    Set-Location $Path
    Initialize-Model -Name Upload
    Update-Data
}