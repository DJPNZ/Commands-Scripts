# Import SharePoint Online Management Shell Module
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

# Function to update external sharing settings
function Update-ExternalSharing {
    param (
        [string]$siteUrl
    )

    try {
        # Connect to SharePoint Online Admin Center
        $adminUrl = "https://followmyleadnz-admin.sharepoint.com"
        Connect-SPOService -Url $adminUrl

        # Verify the connection
        if ($?) {
            # Set sharing settings to Anyone
            Set-SPOSite -Identity $siteUrl -SharingCapability ExternalUserAndGuestSharing
            Write-Host "External sharing has been updated to allow sharing with anyone for the site: $siteUrl" -ForegroundColor Green
        }
        else {
            Write-Host "Failed to connect to SharePoint Online Admin Center." -ForegroundColor Red
        }
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
$siteUrl = "https://followmyleadnz.sharepoint.com/sites/$siteName"

# Output the site URL for confirmation
Write-Host "Updating site: $siteUrl" -ForegroundColor Yellow

# Update the external sharing settings
Update-ExternalSharing -siteUrl $siteUrl
