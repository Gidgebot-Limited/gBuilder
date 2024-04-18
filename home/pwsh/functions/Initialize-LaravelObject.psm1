using module '/home/gbuilder/pwsh/classes/DataObject/DataObject.psm1'

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
        [Parameter(Mandatory = $true, HelpMessage = "Specify the -Name for the migration.")]
        [string]$Name,
        [DataObject]$Object,
        [string]$Create,
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

    # $lowName = $Object.TableName.ToLower()
    $command = "php artisan make:migration ${$Name} ${$options}"
    Invoke-Expression $command
}
Function Get-MigrationFromSchema {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Specify the DataObject schema string.")]
        [string]$SchemaString
    )

    # Parse the schema string and split it into DataField sets
    $fieldSets = $SchemaString.Split('::')

    # Construct the migration content based on the parsed schema
    $migrationContent = "public function up(): void`n{`n    Schema::create('$($fieldSets[0])', function (Blueprint `$table) {`n        `$table->id();`n"

    # Process each DataField set to add corresponding schema elements
    for ($i = 1; $i -lt $fieldSets.Count; $i++) {
        $field = $fieldSets[$i].Split(':')
        $name = $field[0]
        $type = $field[1]

        $migrationContent += "        `$table->$type('$name')"

        # Check for additional modifiers in the schema
        for ($j = 2; $j -lt $field.Count; $j++) {
            $modifier = $field[$j]
            switch ($modifier) {
                'nullable' {
                    $migrationContent += "->nullable()"
                }
                'primary' {
                    $migrationContent += "->primary()"
                }
                default {
                    # Handle foreign key modifier
                    if ($modifier -eq 'foreign' -and $j + 2 -lt $field.Count) {
                        $foreignTable = $field[$j + 1]
                        $foreignKey = $field[$j + 2]
                        $migrationContent += "->foreign('$name')->references('$foreignKey')->on('$foreignTable')->onDelete('cascade')"
                        $j += 2  # Skip the next two elements as they are used
                    }
                }
            }
        }

        $migrationContent += ";`n"
    }

    # Add timestamps and close the Schema::create block
    $migrationContent += "        `$table->timestamps();`n    });`n}"

    # Output the generated migration content
    Write-Output $migrationContent
}

Function Update-Migration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Specify the path where the migration file should be updated.")]
        [string]$Path = "database/migrations",
        [Parameter(Mandatory = $true, HelpMessage = "Specify the DataObject instance.")]
        [DataObject]$Object, 
        [Parameter(Mandatory = $true, HelpMessage = "Specify the Migration Filename.")]  
        [string]$MigrationFileName
    )

    $migrationFilePath = Join-Path -Path $Path -ChildPath $MigrationFileName
    if (Test-Path $migrationFilePath) {
        Write-Host "Migration file found: $migrationFilePath"
        $existingContent = Get-Content -Path $migrationFilePath -Raw

        # Define the regular expression pattern to match the entire up() method content
        $pattern = "(?sm)(?<=public function up\(\): void\s*\{).*?(?=\s*public function down\(\): void\s*\{)"
        Write-Host "Regex pattern: $pattern"

        # Test the regular expression
        $match = $existingContent -match $pattern
        if ($match) {
            Write-Host "Match found!"
            $matchContent = $matches[0]
            Write-Host "Match content:"
            Write-Host $matchContent

            # Get the new schema based on the DataObject
            $newSchema = Get-MigrationFromSchema -SchemaString $Object.GetMigrationSchema()

            # Update the matched content with the new schema
            $updatedContent = $existingContent -replace $pattern, $newSchema

            # Update the existing migration file with the modified content
            Set-Content -Path $migrationFilePath -Value $updatedContent -Force
            Write-Host "Migration file updated."
        }
        else {
            Write-Host "No match found for the up() method content."
        }
    }
    else {
        # Migration file doesn't exist, output a message
        Write-Output "Migration file '$migrationFileName' not found in path '$Path'. No action taken."
    }
}
# Call the Update-Migration function
# Update-Migration -MigrationFileName "2024_03_26_000338_create_uploads_table.php" -Object $UploadObject
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
    Initialize-Migration -Object $Object -NoInteraction
    Initialize-Controller -Name "${Object.Name}Controller" -Resource -Requests
}