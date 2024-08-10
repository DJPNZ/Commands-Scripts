 
#Connect to Exchange Online
Connect-ExchangeOnline -Credential $Credential -ShowBanner:$False

#Disconnect Exchange Online
Disconnect-ExchangeOnline -Confirm:$False
 
#Create New Office 365 Group with non-default domain
New-UnifiedGroup -DisplayName "[Display Name]" -Alias "[Alias]" ` -EmailAddresses "[Email]" -AccessType Private

#Adopt Unifi AP to externally accessible CloudKey
set-inform [External CloudKey Address]

#Email delegation with no mapping
Add-MailboxPermission -Identity [Target Email] -User [Email] -AccessRights FullAccess -AutoMapping $false

#Pull delegation list (shared mailboxes and user mailboxes)
Get-Mailbox -resultsize unlimited | Get-MailboxPermission | Select Identity, User, Deny, AccessRights, IsInherited| Export-Csv -Path "c:\temp\mailboxpermissions.csv" –NoTypeInformation

#Testing IRM (For email encryption)
Set-ExecutionPolicy Unrestricted (type A for Yes to All)
Install-Module -Name ExchangeOnlineManagement
Update-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName [Email] (change email to the admin email address of the tenant)
Test-IRMConfiguration -Sender [Sender Email] -Recipient [Recipient Email] (change sender and recipient to the correct email addresses)

#Enable IRM (For email encryption)
Connect-ExchangeOnline
Install-Module -Name AIPService
Connect-AIPService
Enable-AIPService
$rmsConfig = Get-AIPServiceConfiguration
$licenseUri = $rmsConfig.LicensingIntranetDistributionPointUrl
$irmConfig = Get-IRMConfiguration
$list = $irmConfig.LicensingLocation
if (!$list) { $list = @() }
if (!$list.Contains($licenseUri)) { $list += $LicenseUri }
Set-IRMConfiguration -LicensingLocation $list
Set-IRMConfiguration -AzureRMSLicensingEnabled $True -InternalLicensingEnabled $True
Set-IRMConfiguration -SimplifiedClientAccessEnabled $True

#Connect to SharePoint
Connect-SPOService -Url [Sharepoint URL] -Credential [Admin Email]

#Remove "Add Shortcuts to OneDrive" link from SharePoint
Set-SPOTenant -DisableAddShortcutsToOneDrive $True

#Purge all (or individual) deleted users from M365
Get-MsolUser -ReturnDeletedUsers | Remove-MsolUser -RemoveFromRecycleBin -Force
Remove-MsolUser -UserPrincipalName ‘DemoUser5@Priasoft.mail.onmicrosoft.com’ -RemoveFromRecycleBin

#Removing wrong sharepoint / microsoft tenancy
Remove mail profile. Open regedit. \HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Identity\Identities\ remove the key that points to the old tenant. Create mail profile


