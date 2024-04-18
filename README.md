
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
2. Ensure Docker is installed if you plan to use containerization features.
3. Import the necessary modules into your PowerShell session with `Import-Module`.
4. Begin using gBuilder by initializing a new Laravel project or managing existing projects with the provided command modules.

## Usage

Below are some examples of how to use gBuilder for common Laravel project tasks:

### Initializing a New Laravel Application

```powershell
# Initialize a new Laravel application
Initialize-LaravelApp -Name "YourAppName" -WithAuth $true
```

### Managing Data Objects

```powershell
# Creating a new Eloquent Model and Migration
New-DataObject -Name "BlogPost" -Attributes "title:string, content:text"
```

### Publishing Laravel with Apache

To publish your Laravel app using Apache, use the following commands:

```powershell
# Access the gBuilder tool
docker exec -it gbuilder pwsh

# Publish Laravel app to Apache server
Publish-LaravelApache -Name "ThisSaturday" -Path "/var/www/html/"
Update-data
service apache2 restart
```

### User Interface Installation

For adding user interface schemes to your Laravel application, such as Bootstrap, Jetstream, or Breeze, use the following commands:

```powershell
# Install UI components
Install-UI -Type "bootstrap" -Auth
Install-UI -Type "jetstream"
Install-UI -Type "breeze"
```

### Initializing and Updating Models with Custom Fields

To create and update models with specific data fields, referencing custom modules:

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
