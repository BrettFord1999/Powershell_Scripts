#This pulls a huge amount of data from 365 tenants, useful for making tenant configs


#Connect 365 Services
Connect-AzureAD 
Connect-ExchangeOnline
Connect-MsolService 
#Pulls the SharepointURL so that you can connect to sharepoint online
$365tenantname = Get-OrganizationConfig |Format-table sharepointurl -HideTableHeaders | out-string
$364 = $365tenantname.IndexOf('.sharepoint')
$362 = $365tenantname.Substring(0,$364)
Connect-SPOService -Url $362-admin.sharepoint.com

#Deletes any existing txt files that might conFLict with this script
If (test-path -path C:\cabs\securitybaseline*.txt) {Remove-Item C:\cabs\securitybaseline*.txt}

"-------------------------Organization Config-------------------------" | out-file C:\cabs\securitybaseline1.txt 
Get-OrganizationConfig|Format-List publicfoldersenabled,ActivityBasedAuthenticationTimeoutEnabled,ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled,ActivityBasedAuthenticationTimeoutInterval,MaskClientIpInReceivedHeadersEnabled,IPListBlocked,ExternalCloudAccessEnabled,PublicComputersDetectionEnabled,IntuneManagedStatus,AzurePremiumSubscriptionStatus,MapiHttpEnabled,RealTimeLogServiceEnabled,OAuth2ClientProfileEnabled,ConnectorsEnabled,AuditDisabled,AutoEnableArchiveMailbox,SendFromAliasEnabled,BasicAuthBlockedApps,IsMailboxForcedReplicationDisabled,MailboxDataEncryptionEnabled,DefaultAuthenticationPolicy|out-file C:\cabs\securitybaseline1.txt -Append

"--------------------------Transport Config---------------------------" | out-file C:\cabs\securitybaseline2.txt
Get-TransportConfig |Format-List SmtpClientAuthenticationDisabled,JournalArchivingEnabled,VoicemailJournalingEnabled,VerifySecureSubmitEnabled,LegacyArchiveJournalingEnabled,AddressBookPolicyRoutingEnabled|out-file C:\cabs\securitybaseline2.txt -Append

"-------------------------AntiPhishing Policy-------------------------" | out-file C:\cabs\securitybaseline3.txt
Get-AntiPhishPolicy |Format-List Identity,IsValid,IsDefault,EnableSpoofIntelligence,EnableUnauthenticatedSender | out-file C:\cabs\securitybaseline3.txt -Append

"------------------------Admin Audit Log Config-----------------------" | out-file C:\cabs\securitybaseline4.txt
Get-AdminAuditLogConfig|Format-List AdminAuditLogEnabled,AdminAuditLogAgeLimit | out-file C:\cabs\securitybaseline4.txt -Append

"-------------------Azure ADMS Authorization Policy-------------------" | out-file C:\cabs\securitybaseline5.txt
Get-AzureADMSAuthorizationPolicy |Format-List DefaultUserRolePermissions,AllowEmailVerifiedUsersToJoinOrganization | out-file C:\cabs\securitybaseline5.txt -append

"---------------------Conditional Access Policies---------------------" | out-file C:\cabs\securitybaseline6.txt
Get-AzureADMSConditionalAccessPolicy |Format-Table displayname,state | out-file C:\cabs\securitybaseline6.txt -append

"--------------------------IRM Configuration--------------------------" | out-file C:\cabs\securitybaseline7.txt
Get-IRMConfiguration |Format-List EDiscoverySuperUserEnabled,SearchEnabled,ClientAccessServerEnabled,TransportDecryptionSetting | out-file C:\cabs\securitybaseline7.txt -Append

"----------------------Device Registration Policy---------------------" | out-file C:\cabs\securitybaseline8.txt
Get-MsolDeviceRegistrationServicePolicy |Format-List| out-file C:\cabs\securitybaseline8.txt -append

"-----------------------MSOL Company Information----------------------" | out-file C:\cabs\securitybaseline9.txt
Get-MsolCompanyInformation |Format-List TechnicalNotificationEmails,SelfServePasswordResetEnabled,UsersPermissionToCreateGroupsEnabled,UsersPermissionToCreateLOBAppsEnabled,UsersPermissionToReadOtherUsersEnabled,UsersPermissionToUserConsentToAppEnabled,DirectorySynchronizationEnabled | out-file C:\cabs\securitybaseline9.txt -append

"-----------------------Sharepoint Tenant Info------------------------" | out-file C:\cabs\securitybaseline10.txt
Get-SPOTenant|Format-List|out-file C:\cabs\securitybaseline10.txt -append
Get-Sposite -identity $365tenantname |Format-Table AnonymousLinkExpirationInDays |out-file C:\cabs\baselinefull10.txt -Append
#Full Report no filtering #####################################################################################################################################################################################################################################################################################################################
If (test-path -path C:\cabs\baselineFull*.txt) {Remove-Item C:\cabs\baselineFull*.txt}

"----------------------------Organization Config----------------------------" | out-file C:\cabs\baselinefull1.txt 
Get-OrganizationConfig|Format-List|out-file C:\cabs\baselinefull1.txt -Append

"-----------------------------Transport Config------------------------------" | out-file C:\cabs\baselinefull2.txt
Get-TransportConfig |Format-List|out-file C:\cabs\baselinefull2.txt -Append

"----------------------------AntiPhishing Policy----------------------------" | out-file C:\cabs\baselinefull3.txt
Get-AntiPhishPolicy |Format-List| out-file C:\cabs\baselinefull3.txt -Append

"---------------------------Admin Audit Log Config--------------------------" | out-file C:\cabs\baselinefull4.txt
Get-AdminAuditLogConfig|Format-List| out-file C:\cabs\baselinefull4.txt -Append

"----------------------Azure ADMS Authorization Policy----------------------" | out-file C:\cabs\baselinefull5.txt
Get-AzureADMSAuthorizationPolicy |Format-List| out-file C:\cabs\baselinefull5.txt -append

"------------------------Conditional Access Policies------------------------" | out-file C:\cabs\baselinefull6.txt
Get-AzureADMSConditionalAccessPolicy |Format-Table| out-file C:\cabs\baselinefull6.txt -append

"-----------------------------IRM Configuration-----------------------------" | out-file C:\cabs\baselinefull7.txt
Get-IRMConfiguration |Format-List| out-file C:\cabs\baselinefull7.txt -Append

"-------------------------Device Registration Policy------------------------" | out-file C:\cabs\baselinefull8.txt
Get-MsolDeviceRegistrationServicePolicy |Format-List| out-file C:\cabs\baselinefull8.txt -append

"-------------------------MSOL Company Information--------------------------" | out-file C:\cabs\baselinefull9.txt
Get-MsolCompanyInformation |Format-List|out-file C:\cabs\baselinefull9.txt -append

"--------------------------Audit Config-------------------------------------" | out-file C:\cabs\baselinefull10.txt
Get-AuditConfig |Format-List|out-file C:\cabs\baselinefull10.txt -append

"----------------------ActiveSync Organization Settings---------------------" | out-file C:\cabs\baselinefull11.txt
Get-ActiveSyncOrganizationSettings|Format-List|out-file C:\cabs\baselinefull11.txt -append

"--------------------------Sync Config--------------------------------------" | out-file C:\cabs\baselinefull12.txt
Get-SyncConfig|Format-List|out-file C:\cabs\baselinefull12.txt -append

"--------------------------Smime Config-------------------------------------" | out-file C:\cabs\baselinefull13.txt
Get-SmimeConfig|Format-List|out-file C:\cabs\baselinefull13.txt -append

"-------------------------Policy Config-------------------------------------" | out-file C:\cabs\baselinefull14.txt
Get-PolicyConfig|Format-List|out-file C:\cabs\baselinefull14.txt -append

"--------------------------Azure ADMS Applications--------------------------" | out-file C:\cabs\baselinefull15.txt
Get-AzureADMSApplication|Format-List|out-file C:\cabs\baselinefull15.txt -append

"--------------------------Sharepoint Tenant Info---------------------------" | out-file C:\cabs\baselinefull16.txt
Get-SPOTenant|Format-List|out-file C:\cabs\baselinefull16.txt -append
Get-Sposite -identity $365tenantname |Format-Table AnonymousLinkExpirationInDays |out-file C:\cabs\baselinefull16.txt -Append

Get-Content C:\cabs\securitybaseline*.txt |out-file C:\cabs\CloudSecurityAuditLog.txt
Get-Content C:\cabs\baselinefull*.txt |out-file C:\cabs\CloudSecurityAuditLogFull.txt
Remove-Item C:\cabs\securitybaseline*.txt
Remove-item C:\cabs\baselinefull*.txt

