# Check if SharePoint Online Management Shell Module is installed
$moduleName = "Microsoft.Online.SharePoint.PowerShell"
$module = Get-Module -ListAvailable -Name $moduleName

if (-not $module) {
    # Module not installed, installing from PowerShell Gallery
    Write-Host "The $moduleName module is not installed. Installing now..."
    Install-Module -Name $moduleName -Force -AllowClobber
} else {
    Write-Host "$moduleName module is already installed."
}

# Import the SharePoint Online Management Shell Module
Import-Module $moduleName -DisableNameChecking
Write-Host "$moduleName module has been imported."

# Connect to SharePoint Online Admin Center
$adminUrl = "https://[Tenant]-admin.sharepoint.com"
Connect-SPOService -Url $adminUrl

# List all SharePoint sites (showing only the site name)
try {
    $sites = Get-SPOSite

    if ($sites.Count -gt 0) {
        Write-Host "Here is a list of all available SharePoint site names:" -ForegroundColor Yellow
        $sites | ForEach-Object { 
            # Extract and display only the site name (last part of the URL)
            $siteName = $_.Url -replace '^.+/sites/', ''
            Write-Host $siteName 
        }
    } else {
        Write-Host "No SharePoint sites were found." -ForegroundColor Red
        return
    }
}
catch {
    Write-Host "An error occurred while fetching the site list: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# Function to update external sharing settings
function Update-ExternalSharing {
    param (
        [string]$siteUrl
    )

    try {
        # Set sharing settings to Anyone
        Set-SPOSite -Identity $siteUrl -SharingCapability ExternalUserAndGuestSharing
        Write-Host "External sharing has been updated to allow sharing with anyone for the site: $siteUrl" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        # Disconnect the SharePoint Online service
        Disconnect-SPOService
    }
}

# Prompt for the site name
$siteName = Read-Host "Enter the name of the SharePoint site you want to update"
$siteUrl = "https://[Tenant].sharepoint.com/sites/$siteName"

# Output the site URL for confirmation
Write-Host "Updating site: $siteUrl" -ForegroundColor Yellow

# Update the external sharing settings
Update-ExternalSharing -siteUrl $siteUrl
