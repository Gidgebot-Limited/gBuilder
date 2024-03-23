function Update-Data {
    
    [CmdletBinding()]
    param (
        [string]$Path = "."
    )
    sl $Path
    composer update
    composer install
    php artisan install
    npm install
    npm run dev

}
function Install-Breeze {
    
    [CmdletBinding()]
    param (
        [string]$Path = "."
    )
    sl $Path
    composer require laravel/breeze
    php artisan breeze:install

}
function Install-BootstrapAuth {
    
    [CmdletBinding()]
    param (
        [string]$Path = "."
    )
    sl $Path
    composer require laravel/ui
    php artisan ui bootstrap --auth

}
Function Publish-LaravelApache {

    [CmdletBinding()]
    param (
        [string]$Name = (Get-Date -Format "yyyyMMddHHmmss"),
        [string]$Path = "/home/gbuilder/"
    )

    Initialize-LaravelApp -Name $Name -Path $Path

    $appPath = $Path + $Name

    set-location  $appPath

    php artisan migrate

    Set-ApacheDocumentRoot -NewDocumentRoot ($appPath + "/public")

}
Function Initialize-LaravelApp {
    [CmdletBinding()]
    param (
        [string]$Name = (Get-Date -Format "yyyyMMddHHmmss"),
        [string]$Path = "/home/gbuilder/"
    )

    # Navigate to the directory where you want to create the Laravel app
    Set-Location -Path $Path

    # Install Composer if not already installed
    if (-not (Test-Path -Path "/usr/local/bin/composer")) {
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        php composer-setup.php --install-dir=/usr/local/bin --filename=composer
        php -r "unlink('composer-setup.php');"
    }

    # Create a new Laravel project
    composer create-project --prefer-dist laravel/laravel $Name

    # Navigate into the newly created Laravel app directory
    Set-Location -Path $Name

    # Set up environment configuration
    Copy-Item -Path ".env.example" -Destination ".env"
    Update-EnvDatabase -EnvFilePath ".env" -Connection "pgsql" -Host "builderdb" -Port "5432" -Database "gidgebot" -Username "gidgebot" -Password "gidgebot"


    php artisan key:generate

    chown -R www-data:www-data storage bootstrap 
    chmod -R 775 storage bootstrap 

}


Function Update-EnvVariable {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [Parameter(Mandatory = $true)]
        [string]$VariableName,
        [Parameter(Mandatory = $true)]
        [string]$NewValue
    )

    # Read the content of the .env file
    $envContent = Get-Content -Path $FilePath

    # Check if the variable exists in the content
    $existingVariable = $envContent | Where-Object { $_ -match "^$VariableName=" }

    if ($existingVariable) {
        # Variable exists, update its value
        $envContent = $envContent -replace "^$VariableName=.*", "$VariableName=$NewValue"
    }
    else {
        # Variable doesn't exist, create it with the new value
        $envContent += "$VariableName=$NewValue"
    }

    # Save the updated content back to the .env file
    $envContent | Set-Content -Path $FilePath
}
Function Update-EnvDatabase {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$EnvFilePath,
        [Parameter(Mandatory = $true)]
        [string]$Connection,
        [Parameter(Mandatory = $true)]
        [string]$Host,
        [Parameter(Mandatory = $true)]
        [string]$Port,
        [Parameter(Mandatory = $true)]
        [string]$Database,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [string]$Password
    )

    # Uncomment database configuration variables if they are commented out
    $envContent = Get-Content -Path $EnvFilePath
    $envContent = $envContent -replace "# DB_HOST=", "DB_HOST="
    $envContent = $envContent -replace "# DB_PORT=", "DB_PORT="
    $envContent = $envContent -replace "# DB_DATABASE=", "DB_DATABASE="
    $envContent = $envContent -replace "# DB_USERNAME=", "DB_USERNAME="
    $envContent = $envContent -replace "# DB_PASSWORD=", "DB_PASSWORD="

    # Save the updated content back to the .env file
    $envContent | Set-Content -Path $EnvFilePath -Force

    # Update database configuration variables
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_CONNECTION" -NewValue $Connection
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_HOST" -NewValue $Host
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_PORT" -NewValue $Port
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_DATABASE" -NewValue $Database
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_USERNAME" -NewValue $Username
    Update-EnvVariable -FilePath $EnvFilePath -VariableName "DB_PASSWORD" -NewValue $Password
}
Function Set-ApacheDocumentRoot {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$NewDocumentRoot
    )

    # Update Apache configuration file with new document root
    $apacheConfigFile = "/etc/apache2/sites-available/000-default.conf"
    $apacheConfigContent = Get-Content -Path $apacheConfigFile
    $apacheConfigContent = $apacheConfigContent -replace '/var/www/html', "$NewDocumentRoot"
    $apacheConfigContent | Set-Content -Path $apacheConfigFile

    # Restart Apache service
    service apache2 restart
}