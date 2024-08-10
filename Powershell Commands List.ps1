 
#Connect to Exchange Online
Connect-ExchangeOnline -Credential $Credential -ShowBanner:$False

#Disconnect Exchange Online
Disconnect-ExchangeOnline -Confirm:$False
 
#Create New Office 365 Group with non-default domain
New-UnifiedGroup -DisplayName "[Display Name]" -Alias "[Alias]" ` -EmailAddresses "[Email]" -AccessType Private

#Adopt Unifi AP to externally accessible CloudKey
set-inform [External CloudKey Address]

#Pull Unifi AP Config
less /tmp/system.cfg

#Factory reset Unifi AP
syswrapper.sh restore-default


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


#To recover a backup job in SPX:
    Log in to the SPX GUI.
    Mount the most recent backup image of the OS volume with read permissions (see Restoring Files and Folders for more information).
    Navigate to the following folder on the mounted volume:
Program Data\StorageCraft\spx
    Copy the listed .json files and spx.db3 files to a temporary folder:
    spx_config.json
    spx_service_config.json
    spx.db3


#How to turn off SIP ALG on a FortiGate firewall
##Logon to your FortiGate’s console and run
config system session-helper
show
Find the entry which shows ‘set name sip’ (note the ID - it’s usually 13)
delete 13 (or the number shown on your firewall)
end
config system settings
set default-voip-alg-mode kernel-helper-based
end
config voip profile
edit default
config sip 
set status disable
end 
end
Reboot the router


#Removing wrong sharepoint / microsoft tenancy
Remove mail profile. Open regedit. \HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Identity\Identities\ remove the key that points to the old tenant. Create mail profile

config system interface
edit lan2
set status up
end
