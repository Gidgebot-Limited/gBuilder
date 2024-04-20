# gBuilder: Laravel Application PowerShell Manager

**gBuilder** is an innovative PowerShell tool designed to streamline the deployment, setup, and management of Laravel applications. Leveraging the power of PowerShell, gBuilder makes it easy to execute complex Laravel project tasks such as object initialization, continuous deployment, and more, directly from your command line.

## Features

- **Laravel Deployment**: Simplify the deployment process of Laravel applications with automated commands.
- **Continuous Deployment Manager**: Use `Deploy-Continuously.psm1` to keep your Laravel application up to date with the latest changes in your development environment.
- **Laravel Application and Object Initialization**: Leverage `Initialize-LaravelApp.psm1` and `Initialize-LaravelObject.psm1` modules to quickly set up new Laravel projects and essential components within your application.
- **Data Management**: Manage your application's data layers with the `DataObject.psm1` module, facilitating efficient interaction with Laravel Eloquent or other ORM layers.
- **Docker Integration**: Seamlessly manage Docker containers as part of your Laravel project setup, ensuring consistent development and production environments.

## Getting Started

To get started with gBuilder, you will need a system with PowerShell installed.

1. Clone the gBuilder repository to your local machine.
2. Ensure Docker and docker compose are installed if you plan to use containerization features.
3. Import the necessary modules into your PowerShell session with `Import-Module`.
4. Begin using gBuilder by initializing a new Laravel project or managing existing projects with the provided command modules.

# Usage

## Below are some examples of how to use gBuilder for common Laravel project tasks:

### ...First...:
```bash
# Access the gBuilder tool
cd .../gBuilder
docker compose up -d
```
### ...And Then...:
Apache's index.html will display at localhost.

## Enter gBuilder cli:
```bash
docker exec -it gbuilder pwsh
```

## Initializing a New Laravel Application:

### ...First...:
```powershell
# Initialize a new Laravel application
Initialize-LaravelApp -Name MyFirst-App_Name -Path /var/www/html/
```
### ...And Then...:
```powershell
# Initialize a new Laravel application
Set-ApachesDocumentRoot -NewDocumentRoot /var/www/html/MyFirst-App_Name/public
```

### ...Or...:

## Initializing amd Serving on HTTP with Apache2

To publish your Laravel app using Apache, use the following commands:

### ...First...:
```powershell
# Publish Laravel app to Apache server
Publish-LaravelApache -Path /var/www/html/ -Name lapache 
```

### ...And Then...:

## User Interface Installation

Add Bootstrap UI Authentication Scaffolding and optionally choose from a UI Starter Kit:

### ...First...:
```powershell
Set-Location /var/www/html/lapache 
```

### ...And Then...:

Install Bootstrap User Authentication Views:

### ...First...:
```powershell
Install-UI -Type "bootstrap" -Auth -NoInteraction
```
### ...Or...:
```powershell
Install-Breeze -Stack "livewire" -DarkMode -NoInteraction
```
### ...Or...:
```powershell
Install-Jetstream -Stack "livewire" -DarkMode -Teams -Verification -API -NoInteraction
```
### ...And Then...:
```powershell
Update-Data
```

Bootstrap user authentication views will now be available. 

## Install-Breeze Function

The `Install-Breeze` function facilitates the setup of Laravel Breeze with customizable options.

### Parameters

- `Path`: Specifies the project directory path. The default path is the current directory (".").
- `Stack`: Choose your frontend stack (`blade`, `vue`, `react`).
- `DarkMode`: Enables dark mode if specified.
- `Pest`: Installs Pest PHP testing framework alongside.
- `SSR`: Enables Server-Side Rendering.
- `TypeScript`: Enables TypeScript support.
- `Composer`: Specify a local composer path or use "global" to use the global composer installation. Default is "global".
- `NoInteraction`: Runs commands without asking for any interaction.

### Usage

```powershell
Install-Breeze -Stack "livewire" -DarkMode -NoInteraction
```

## Install-Jetstream Function

The `Install-Jetstream` function is designed to automate the installation of Laravel Jetstream with various options.

### Parameters

- `Path`: Target directory for Laravel project.
- `Stack`: Select between `livewire` and `inertia` for your frontend scaffolding.
- `DarkMode`: Enables dark theme if opted in.
- `Teams`: Installs the team management feature.
- `API`: Includes API support.
- `Verification`: Adds email verification support.
- `Pest`: Integrates Pest PHP testing framework.
- `SSR`: Enables Server-Side Rendering support.
- `Composer`: Define path to composer or use "global" for global composer. Default to "global".
- `NoInteraction`: Executes the command without any interactive prompts.

### Usage

```powershell
Install-Jetstream -Stack "livewire" -DarkMode -Teams -Verification -API -NoInteraction
```

These PowerShell functions streamline the setup process for Laravel Breeze and Jetstream, making it simpler to jumpstart your Laravel application development.

# Initializing and Updating Models with Custom Fields

### To create and update models with specific data fields, referencing custom modules:

```powershell
# Use custom DataObject module for advanced model handling
using module '/home/gbuilder/pwsh/classes/DataObject/DataObject.psm1'

# Initialize a new model name 'Upload'
Initialize-Model -Name Upload

# Define URL as a primary string field
$dfURL = [DataField]::new("url", "string")
$dfURL.SetAsPrimary()

# Define a nullable JSON properties field
$dfProperties = [DataField]::new("properties", "json")
$dfProperties.SetAsNullable()

# Define a foreign key relationship to the 'users' table
$dfUserID = [DataField]::new("user_id", "unsignedBigInteger")
$dfUserID.SetAsForeign("users", "id")

# Gather all fields into a collection
$DataFields = @($dfURL, $dfProperties, $dfUserID)

# Create a new DataObject for 'Upload' with defined fields
$DataObject = [DataObject]::new("Upload", "Uploads", $DataFields)

# Apply updates to the 'Upload' model
Update-Model -Object $DataObject
```
