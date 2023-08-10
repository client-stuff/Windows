function New-Popup{
#This is using VBScript popup, more info about it can be found here https://ss64.com/vb/popup.html
param(
[String]$Title = "",
[String]$Text,
$Type = 0,
[Switch]$Type:OkOnly,
[Switch]$Type:OkCancel,
[Switch]$Type:AbortRetryIgnore,
[Switch]$Type:YesNoCancel,
[Switch]$Type:YesNo,
[Switch]$Type:RetryCancel,
$Icon = 0,
[Switch]$Icon:Critical,
[Switch]$Icon:Question,
[Switch]$Icon:Exclamation,
[Switch]$Icon:Information,
[Switch]$ReturnText
)

switch($Type){
"OKOnly" { $Type = 0 }
"OkCancel" { $Type = 1 }
"AbortRetryIgnore" { $Type = 2 }
"YesNoCancel" { $Type = 3 }
"YesNo" { $Type = 4 }
"RetryCancel" { $Type = 5 }
default { if($Type -notmatch '^[0-9]+$'){ $Type = 0 } }
}

switch($Icon){
"Critical" { $Icon = 16 }
"Question" { $Icon = 32 }
"Exclamation" { $Icon = 48 }
"Information" { $Icon = 64 }
default { if($Icon -notmatch '^[0-9]+$'){ $Icon = 0 } }
}

$stringReturns = @{
"1" = "OK"
"2" = "Cancel"
"3" = "Abort"
"4" = "Retry"
"5" = "Ignore"
"6" = "Yes"
"7" = "No"
}

$return = (New-Object -ComObject WScript.Shell).Popup($Text, 0, $Title, $($Type+$Icon))

#If $Type+$Icon is a number that VBS Popup don't support no popup is shown, if so show an OkOnly popup without any icons
if($return -eq $NULL){
$return = (New-Object -ComObject WScript.Shell).Popup($Text, 0, $Title, 0)
}

if($ReturnText){
$return = $stringReturns["$return"]
}

return $return
}