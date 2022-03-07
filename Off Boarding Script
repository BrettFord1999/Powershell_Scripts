#This doesn't run the module installation at the bottom because it gets blocked by hueristic based EPPs


#Logs all events that take place in this powershell session and log them in C:\cabs\offboardinglog.log
Start-Transcript -append C:\cabs\offboardinglog.log
#if an error is thrown this will ask if you want to continue
$ErrorActionPreference = "inquire"

if (get-installedmodule "exchangeonlinemanagement","azuread"){

# Replace variables
$name = read-host "User First + Last name"
$name
$adname = @(Get-ADUser -Filter { name -like $name } | format-table samaccountname -HideTableHeaders) | out-string
#trim is important because there are spaces at the end of the variable...
$adname = $adname.Trim()
$termdate = Get-Date -Format "MM/dd/yyyy" 
$termdate
$email = @(Get-ADUser -Filter { name -like $name } -Properties mail | Format-Table mail -HideTableHeaders) | out-string
$email
$fullname = $name
$password = read-host 'Off-boarding password'
$password

Write-Output "Please confirm the settings are correct before continuing"
Pause

# Set logonhours to logon denied
# Representing the 168 hours in a week
$LH = New-Object 'Byte[]' 21

For ($k = 0; $k -le 20; $k = $k + 1) {
    $LH[$k] = 0
} 
# Assign 21 byte array of all zeros to the logonHours attribute of the user.            
Set-ADUser $adname -Replace @{logonHours = $LH }


# Disables account and resets password 
Disable-ADAccount -identity $adname
Set-adaccountpassword -identity $adname -reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)


# Sets the Term date description and extension attribute
Set-ADUser $adname -Description "TERM DATE $termdate"
Set-ADUser $adname -Add @{extensionAttribute1 = "TERM DATE $termdate" }


# Sets the MsExchHideFromAddressLists to true
Set-ADUser $adname -Add @{MsExchHideFromAddressLists = ($persistent -ne $false) }


# Gather group membership of user before removing.
New-Item -Path "c:\cabs\Off-boarding Groupmembership\" -ItemType Directory
Get-ADPrincipalGroupMembership $adname | Select-Object name | Export-CSV "c:\cabs\Off-boarding Groupmembership\$adnamegroupmembership.csv"


# Removes the ad user from all groups
Get-ADUser -Identity $adname -Properties MemberOf | ForEach-Object {
    $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false }
  
# Adds user to awarenesstraining exclude group
Add-ADGroupMember -Identity knowbe4_exclude -Members $adname

# Disables 365 sign on 
Connect-AzureAD
Set-AzureADUser -ObjectID $email -AccountEnabled $false

# Connect Exchange online
Connect-ExchangeOnline

# Disable OWA and Activesync
Set-CASMailbox -Identity "$name" -OWAEnabled $false
Set-CASMailbox -Identity "$name" -ActiveSyncEnabled $false


#ask if you want to set someone as a forward or mailbox delegate
$Prompt1 = read-host "Will anyone recieve forwarding or mailbox access? Enter Y for Yes, N for No "

if ($Prompt1 = "Y") {
    $delegate = read-host "First + last name of the email delegate"
    $forwarddelegate = @(Get-ADUser -Filter { name -like $delegate } -Properties mail | Format-Table mail -HideTableHeaders) | out-string
    $forwarddelegate
    $mailboxdelegate = $delegate

    #ask if you want to forward email
    $prompt2 = read-host "Would you like to forward mail to $delegate?  Enter Y for Yes, N for No" 

    if ($prompt2 = "Y") {

        Set-Mailbox -Identity "$name" -ForwardingAddress "$forwarddelegate" 
    }

    $prompt3 = Read-Host "Would you like to assign full mailbox access to $delegate? Enter Y for Yes, N for No "

    if ($prompt3 = "Y") {

        Add-MailboxPermission -Identity "$name" -User "$mailboxdelegate" -AccessRights FullAccess -InheritanceType All

    }


}
}
else {
    
 write-output "Please install the Azure AD and Exchange Online Management Modules to run this command 
 This can be done by copying and pasting the following commands into an Administrative powershell session
 Set-ExecutionPolicy RemoteSigned
 Install-PackageProvider -Name NuGet -Force
 Install-Module -Name PowerShellGet -Force
 winrm set winrm/config/client/auth '@{Basic="true"}'
 Install-Module -Name ExchangeOnlineManagement
 Install-Module –Name AzureAD 
 Then retry this script"
    
}

Stop-transcript

Pause
