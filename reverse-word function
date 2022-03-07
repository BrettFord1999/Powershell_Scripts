function reverse-word($string) 
{ 
$array = $string.ToCharArray()
[array]::Reverse($array)
$array = $array -join ""
return $array

}


#was initially attempting to use a foreach loop to call the reverse-word function but this ended up working better
function reverse-sentence($String) {
$array = $string -split " "
$array | ForEach-Object {

$array = $string.ToCharArray()
[array]::Reverse($array)
$array = $array -join ""
    }
return $array
}
