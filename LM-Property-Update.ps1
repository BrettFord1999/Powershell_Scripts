#pull information from a csv to update logicmonitor properties on devices

#insert API key here
$key = "********************" |convertto-securestring -AsPlainText -force

#pull data from csv to set to variables
$csv = import-csv "C:\Users\BFord\OneDrive - Magna5\Book1 Sonoco csv.csv"
$csv | ForEach-Object {
        $displayname = $_.host
        $location = $_.location
        $prod = $_.category
        Update-LogicMonitorDeviceProperty -AccessId ************ -AccessKey $key -AccountName magna5global -DisplayName $displayname -PropertyNames in.production,device.location  -PropertyValues $prod,$location
                      }
