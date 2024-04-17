
# gBuilder: Laravel Application Powershell Manager

**gBuilder** is an innovative PowerShell tool designed to streamline the deployment, setup, and management of Laravel applications. Leveraging the power of PowerShell, gBuilder makes it easy to execute complex Laravel project tasks such as object initialization, continuous deployment, and more, directly from your command line.

## Features

- **Laravel Deployment**: Simplify the deployment process of Laravel applications with automated commands.
- **Continuous Deployment Manager**: Use `Deploy-Continuously.psm1` to keep your Laravel application up-to-date with the latest changes in your development environment.
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
