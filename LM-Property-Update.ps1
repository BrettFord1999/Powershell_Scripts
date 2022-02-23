#Update Device properties

#insert API key here
$key = "********************" |convertto-securestring -AsPlainText -force

#pull data from csv to set to variables
$csv = import-csv "Path to csv file"
$csv | ForEach-Object {
        $displayname = $_.host
        $location = $_.location
        $prod = $_.category
        Update-LogicMonitorDeviceProperty -AccessId ************ -AccessKey $key -AccountName ******** -DisplayName $displayname -PropertyNames in.production,device.location  -PropertyValues $prod,$location
                      }

###################################################################################################################
#Create dynamic groups

$csv = Import-Csv "C:\Users\BFord\Downloads\groupsimport.csv"
$csv | ForEach-Object {
       $location = $_.location
       $appliesto = $_.appliesto


$table = @{
    
    name = "$location"
            parentId = ""
            appliesTo = "$appliesto"
        }
Add-LogicMonitorDeviceGroup -AccessId ************* -AccessKey $key -AccountName ******** -Properties $table
}
