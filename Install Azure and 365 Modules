#This script will be blocked by hueristic based EPPS/AVs
#Still handy to keep and copy/paste lines unless the file path can be whitelisted within the EPP/AV

Set-ExecutionPolicy RemoteSigned
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PowerShellGet -Force
winrm set winrm/config/client/auth '@{Basic="true"}'
Install-Module -Name ExchangeOnlineManagement
Install-Module -Name MSOnline
Install-Module –Name AzureAD
Install-Module –Name Microsoft.Online.SharePoint.PowerShell
Install-Module –Name MicrosoftTeams
