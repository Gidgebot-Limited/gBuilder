Function Initialize-Model {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Specify the name of the model.")]
        [string]$Name,
        [switch]$All,
        [switch]$Controller,
        [switch]$Factory,
        [switch]$Force,
        [switch]$Migration,
        [switch]$MorphPivot,
        [switch]$Policy,
        [switch]$Seed,
        [switch]$Pivot,
        [switch]$Resource,
        [switch]$Api,
        [switch]$Requests,
        [switch]$Test,
        [switch]$Pest,
        [switch]$PhpUnit
    )

    $options = @()
    if ($All) { $options += "--all" }
    if ($Controller) { $options += "--controller" }
    if ($Factory) { $options += "--factory" }
    if ($Force) { $options += "--force" }
    if ($Migration) { $options += "--migration" }
    if ($MorphPivot) { $options += "--morph-pivot" }
    if ($Policy) { $options += "--policy" }
    if ($Seed) { $options += "--seed" }
    if ($Pivot) { $options += "--pivot" }
    if ($Resource) { $options += "--resource" }
    if ($Api) { $options += "--api" }
    if ($Requests) { $options += "--requests" }
    if ($Test) { $options += "--test" }
    if ($Pest) { $options += "--pest" }
    if ($PhpUnit) { $options += "--phpunit" }

    $command = "php artisan make:model $Name $options"
    Invoke-Expression $command
}
Function Update-Model {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Specify the path where the model file should be created/updated.")]
        [string]$Path = "app\Models",
        [Parameter(Mandatory = $true, HelpMessage = "Specify the DataObject instance.")]
        [psCustomObject]$Object
    )

    # Check if the model file already exists
    $modelFilePath = Join-Path -Path $Path -ChildPath "$($Object.Name).php"
    if (Test-Path $modelFilePath) {
        # Read the existing content of the model file
        $existingContent = Get-Content -Path $modelFilePath -Raw

        # Update fillable fields if they exist
        $fillableRegex = '(?s)(?<=protected \$fillable\s*=\s*\[).*?(?=\]\s*;)'
        if ($existingContent -match $fillableRegex) {
            $existingContent = $existingContent -replace $fillableRegex, {
                "`n        " + ($Object.Fields.ForEach({ "'$($_.Name)'," }) -join "`n        ") + "`n    "
            }
        }
        else {
            # Add the fillable section if it doesn't exist
            $existingContent = $existingContent -replace '(?=\})', {
                "`n    protected `$fillable = [`n        " + ($Object.Fields.ForEach({ "'$($_.Name)'," }) -join "`n        ") + "`n    ];`n"
            }
        }

        # Update the existing model file with the modified content
        Set-Content -Path $modelFilePath -Value $existingContent -Force
    }
    else {
        # Model file doesn't exist, output a message
        Write-Output "Model file '$($Object.Name).php' not found in path '$Path'. No action taken."
    }
}

Function Initialize-Migration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Specify the [DataObject] for the migration.")]
        [psCustomObject]$object,
        [string]$Create,
        [string]$Table,
        [string]$Path = "database/migrations",
        [switch]$NoInteraction,
        [ValidateRange(0, 3)]
        [int]$VerboseLevel = 0
    )
    
    $options = @()
    if ($Create) { $options += "--create=$Create" }
    if ($Table) { $options += "--table=$Table" }
    if ($Path) { $options += "--path=$Path" }
    if ($NoInteraction) { $options += "--no-interaction" }

    $verbosity = "-".PadRight($VerboseLevel + 1, 'v')
    $options += $verbosity

    $command = "php artisan make:migration create_${$object.TableName}_table ${$options}"
    Invoke-Expression $command
}


Function Initialize-Controller {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Specify the name of the controller.")]
        [string]$Name,
        [switch]$Api,
        [string]$Type,
        [switch]$Force,
        [switch]$Invokable,
        [string]$Model,
        [string]$Parent,
        [switch]$Resource,
        [switch]$Requests,
        [switch]$Singleton,
        [switch]$Creatable,
        [switch]$Test,
        [switch]$Pest,
        [switch]$PhpUnit
    )

    $options = @()
    if ($Api) { $options += "--api" }
    if ($Type) { $options += "--type=$Type" }
    if ($Force) { $options += "--force" }
    if ($Invokable) { $options += "--invokable" }
    if ($Model) { $options += "--model=$Model" }
    if ($Parent) { $options += "--parent=$Parent" }
    if ($Resource) { $options += "--resource" }
    if ($Requests) { $options += "--requests" }
    if ($Singleton) { $options += "--singleton" }
    if ($Creatable) { $options += "--creatable" }
    if ($Test) { $options += "--test" }
    if ($Pest) { $options += "--pest" }
    if ($PhpUnit) { $options += "--phpunit" }

    $command = "php artisan make:controller $Name $options"
    Invoke-Expression $command
}
Function Initialize-DataObject {

    [CmdletBinding()]
    param (
        [string]$Path = ".",
        [Parameter(Mandatory = $true)]
        [DataObject]$Object
    )

    


    Set-Location -Path $Path
    
    Initialize-Model -Name $Object.Name
    Update-Model -Object $Object

    Initialize-Migration -Name "create_${$Object.TableName.ToLower()}_table.php" -NoInteraction
    

    Initialize-Controller -Name "${Object.Name}Controller" -Resource -Requests
}