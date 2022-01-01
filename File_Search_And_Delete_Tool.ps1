#note to revisit this
$ErrorActionPreferencedefault = $ErrorActionPreference

do {
$prompt5 = Read-Host "Would you like to search one of your drives? Y for Yes N for No"


while($prompt5 -eq "Y") {

    $DriveDisplay = Get-PSDrive -PSProvider 'FileSystem' |format-table root -HideTableHeaders
    if ($drivedisplay -ne "C:\" ) {
#List Current Volumes so that user is not guessing what drives are available
        $DriveDisplay = Get-PSDrive -PSProvider 'FileSystem'
        write-output $DriveDisplay
        $Disk = (read-host "Enter the letter of the disk you want to search EX 'c' 'd'") 
        $disk = "$disk :\"
        $disk = $disk.replace(' ','')
        $disk
                                }
        if (Test-path "$disk") { 
            $prompt4 = read-host "How would you like to search files 
            [A to search by name] [B to search by creation date]"

            if ($prompt4 -eq "A") {
                $string1 = read-host "Enter the name or file type you are searching for"
                get-childitem "$disk" -filter "*$string1*" -recurse
                write-output "Search complete" 
            }
            if ($prompt4 -eq "B") {
                $Date1 = Read-host "Search files newer than... days"
                $date1 = "-$date1"
                $CurrentDate = Get-Date
                $Datetosearch = $CurrentDate.AddDays($date1)
                $ErrorActionPreference = "SilentlyContinue" 
                get-childitem $disk -recurse -exclude *.pak,*.etl,*.pf,*.ini,*.pnf |where-object {$_.CreationTime -ge $datetosearch} |Format-Table -autosize
                $ErrorActionPreference = $erroractionpreferencedefault
                write-output "Search complete" 
            }
        } Else {write-output "disk not found"}
    
    $prompt5 = read-host "Would you like to search? Y for yes N for No"
    }

Do {
    #prompt for path
    $path = read-host "Please enter the path of the file or folder"

    #Verify that the path is valid
    $pathValid = Test-Path $path
    if($pathValid){
    
        

            #choose which section of the script you would like to run
            $option = read-host "Please select functionality 
            [A to delete all files] [B to delete by name] [C to delete by date] [D to exit script]"

            if ($option -eq "D") {exit} 
            #Exite out the script
    
            if ($option -eq "A") {
                #remove folder or file
                Get-childitem $path 
                $prompt2 = read-host "Would you like to delete the listed files? Y for Yes N for No"
                if ($prompt2 -eq "Y"){
                    remove-item $path -force -recurse
                }
            }


            if ($option -eq "B"){
                #delete files including a specified string
                $string = read-host "Delete files including... '.txt' '.bak' "
                get-childitem $path -filter "*$string*" -recurse
                $prompt2 = read-host "Would you like to delete the listed files? Y for Yes N for No"
                if ($prompt2 -eq "Y") {
                    get-childitem $path -filter "*$string*" -recurse |Remove-Item
                }
            }

 
            if ($option -eq "C") {
                #delete all files older than a specified date
                $deletiondate = Read-host "Delete files older than... days: "
                $deletiondate = "-$deletiondate"
                $CurrentDate = Get-Date
                $DatetoBeDeleted = $CurrentDate.AddDays($deletiondate)
                get-childitem $path -recurse|where-object {$_.CreationTime -lt $datetobedeleted}
                $Prompt3 = read-host "Would you like to delete the listed files? Y for yes N for No" 
                if ($prompt3 -eq "Y") {
                    get-childitem $path -recurse|where-object {$_.CreationTime -lt $datetobedeleted} |Remove-Item  -recurse -force
                }
            }
            $promptrestart = read-host "Would you like to Change file pathing? Y for Yes N for No"
    
    }else{
        write-output "That file path was incorrect." #Lets user know that the file path was incorrect
        
    }

 } while ($promptrestart -eq "Y")

 $restart = Read-Host "Would you like to restart?"
} while ($restart -ne "n")
