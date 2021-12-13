#Disables Fast startup
#Clears temp files
#Clears recycle bin
#Deletes Zip files older than 30 days
#Dynamically allocates disk space to your page file
#Runs disk cleanup
#Forces Windows updates
#Defrags/optimizes C drive
#Runs DISM cleanup and restore health




#Disable Fast Startup
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d "0" /f

#Clear temp files
$User = $env:UserName
Remove-item -path "C:\users\$user\AppData\Local\Temp" -Recurse -Force -ErrorAction SilentlyContinue

#Clear recycle bin
Remove-Item -path 'C:\$RECYCLE.BIN' -Recurse -Force 

@'#Delete Zip files older than 30 days
$Onedrive = Read-Host "Is the user using onedrive? [Y for Yes] [N for No]" 
if ($Onedrive -ne "y") {
           $deletiondate = 30
           $deletiondate = "-$deletiondate"
                $CurrentDate = Get-Date
                $DatetoBeDeleted = $CurrentDate.AddDays($deletiondate)
get-childitem C:\users\$user -filter "*.zip" -recurse   |where-object {$_.CreationTime -lt $datetobedeleted} |remove-item
                       } '@

#Check if pagefile is smaller than the amount of ram available, check vs available space as well
$pagefilesize = Get-CimInstance -Class Win32_PageFileUsage |Format-Table allocatedbasesize -HideTableHeaders |out-string
$pagefilesize = $pagefilesize.replace(" ","")
$pagefilesize = $pagefilesize / 1000
$pagefilesize = [Math]::Round($pagefilesize)
    $MemoryCapacity = Get-WmiObject win32_physicalmemory | Format-Table Capacity -HideTableHeaders | Out-String
    $MemoryCapacity = $MemoryCapacity.replace(" ","")
    $MemoryCapacity = $MemoryCapacity / 1073741824
    $Freespace = get-volume|Where-Object {$_.FileSystemLabel -match "osdisk"} |ft sizeremaining -HideTableHeaders|out-string
    $Freespace = $Freespace.replace(" ","")
    $Freespace = $Freespace / 1073741824
    $Freespace = [Math]::Round($Freespace)
    
        if (($MemoryCapacity -gt $pagefilesize) -and ($Freespace -gt $MemoryCapacity))
        {
            $MemoryCapacity = $MemoryCapacity * 1000
                $WMIsetting = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
                $WMIsetting.AutomaticManagedPagefile = $False;
                $WMIsetting.Put();
                        $pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
                        $pagefile.InitialSize = $MemoryCapacity;
                        $pagefile.MaximumSize = $MemoryCapacity;
                        $pagefile.Put();
        }


#Run disk cleanup
Cleanmgr /sagerun:1 /verylowdisk

#Check for Windows Updates
Install-Module -Name PSWindowsUpdate -Force
Get-WindowsUpdate -ForceDownload

#Defrag C drive
Optimize-Volume -driveletter C -Verbose
#Dism
DISM.exe /Online /Cleanup-Image /Restorehealth
