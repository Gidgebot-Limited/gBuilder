using module '/home/gbuilder/pwsh/classes/DataObject/DataObject.psm1'
Function Install-UploadModel {
  
    [CmdletBinding()]
    
    param (
        [string]$Path = "."
    )
    [Parameter(Mandatory = $true, HelpMessage = "Specify the DataObject instance.")]
    [psCustomObject]$Object

    Set-Location $Path

    Initialize-Model -Name Upload
    Update-Model -Object $Object 

}

Function Install-UploadMigration {
  
    [CmdletBinding()]
    
    param (
        [string]$Path = ".",
    
        [Parameter(Mandatory = $true, HelpMessage = "Specify the [DataObject] instance.")]
        [psCustomObject]$Object
    )
    Set-Location $Path

    Initialize-Migration -Object $Object -Create "Uploads" -NoInteraction
    # Update-Migration -Object $Object 

}

Function Get-UploadObject {
    $dfURL = [DataField]::new("url", "string")
    $dfURL.SetAsPrimary()

    $dfProperties = [DataField]::new("properties", "json")
    $dfProperties.SetAsNullable()

    $dfUserID = [DataField]::new("user_id", "unsignedBigInteger")
    $dfUserID.SetAsForeign("users", "id")

    $DataFields = @($dfURL, $dfProperties, $dfUserID)

    $DataObject = [DataObject]::new("Upload", "Uploads", $DataFields)
    return $DataObject
}
Function Install-Upload {
  
    [CmdletBinding()]
    
    param (
        [string]$Path = "."
    )
    [Parameter(Mandatory = $true, HelpMessage = "Specify the DataObject instance.")]
    [psCustomObject]$Object

    # $dfUserID = [DataField]::new("user_id", "unsignedBigInteger")
    # $dfUserID.SetAsForeign("users", "id")
    # $dfURL = [DataField]::new("url", "string")
    # $dfURL.SetAsPrimary()
    # $dfProperties = [DataField]::new("properties", "json")
    # $dfProperties.SetAsNullable()
    # $DataFields = @($dfURL, $dfProperties, $dfUserID)
    # $DataObject = [DataObject]::new("Upload", "Uploads", $DataFields)
    
    Set-Location $Path
    Install-UploadModel -Path $path -Object $Object
    Install-UploadMigration -Path $path -Object $Object

    Update-Data
}