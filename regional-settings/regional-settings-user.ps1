<#
.Synopsis
    Regionalsettings-User.ps1
.DESCRIPTION
    This will change the regonalsettings on the computer, changing the following settings:
    Language order of the machine (look in the systray, language lists)
    Format ( intl.cpl first tab)
    Home Location ( intl.cpl second tab)

    The machine will always have
    Swedish,English then another language you chooses in the parameter.

    You walso need to choose what TimezoneID, specify that in the parameter.

    look at the example down below.

    Created: 2019-10-15
    Version: 1.0

    Author : Pontus Wendt
    Homepage : https://clientstuff.blog


    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and
    is not supported by the author.
.EXAMPLE
    #Primary langauge Swedish, secondary English. Format Swedish, Home location Sweden, Timezone Sweden.
    .\Regionalsettings-User.ps1 -Primary "sv-se" -Secondary "en-us" -TimezoneID "W. Europe Standard Time"
    #Primary langauge English, secondary Swedish. Format English, Home location English, Timezone Sweden.
    .\Regionalsettings-User.ps1 -Primary "en-us" -Secondary "sv-se" -TimezoneID "W. Europe Standard Time"
    NA
#>


Param(
        [Parameter(mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Primary,
        [Parameter(mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Secondary,
        [Parameter(mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $TimezoneID
    )


function Write-ScriptLog
{
param 
(
[String]$Info,
[Switch]$Error
)
if ($Error)
    {
        Write-EventLog -LogName 'Windows PowerShell' -Source PowerShell -EntryType Error -EventId 33333 -Message $Info
    }
else
    {
        Write-EventLog -LogName 'Windows PowerShell' -Source PowerShell -EntryType Information -EventId 33333 -Message $Info
    }
}


#Getting the GEOID
function Get-RegionInfo($Name='*')
{
    $cultures = [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures')
 
    foreach($culture in $cultures)
    {
       try{
           $region = [System.Globalization.RegionInfo]$culture.Name
 
           if($region.DisplayName -like $Name)
           {
                $region
           }
       }
       catch 
       {
       }
    }
}
$PrimaryLanguage = Get-RegionInfo * | where {$_.name -eq "$Primary"}

#Making Language list with the parameters
Set-WinUserLanguageList -LanguageList $Primary,$Secondary -Force

$1 = (Get-WinUserLanguageList).languagetag
if ($Primary -eq "$Primary" -and $Secondary -eq "$Secondary") 
    {
        Write-ScriptLog "Success: Winuserlanguagelist is now set to Primary language $Primary, and secondary language set to $Secondary"
    }
else
    {
        Write-ScriptLog "Error: The prefered languageorder is not correct, the order is: $((Get-WinUserLanguageList).languagetag))"
    }


#FORMAT
Set-Culture $Primary
$2 = (Get-culture).Name
if ($2 -eq $Primary)
    {
        Write-ScriptLog "Successfully changed Set-culture to $Primary"
    }
else
    {
        Write-ScriptLog "Failed to change Get-culture, the current Culture is : $((Get-Culture).name))"
    }
#CHANGE LOCATION
$geoID = $PrimaryLanguage.GeoId
Set-WinHomeLocation -GeoId $geoID
$3 = (Get-WinHomeLocation).Geoid
if ($3 -eq $geoID)
    {
        Write-ScriptLog "Successfully changed Set-WinHomeLocation to $geoID"
    }
else
    {
        Write-ScriptLog "Failed to change Set-WinHomeLocation, the current WinHomeLocation is : $((Get-WinHomeLocation).Geoid))"
    }

#CHANGE TIMEZONE
C:\windows\system32\tzutil.exe /s $timezoneID
$Timezone = (C:\windows\system32\tzutil.exe /g)
if ($Timezone  -eq "$timezoneID")
    {
        Write-ScriptLog "Successfully changed Timezone to $TimezoneID"
    }
else
    {
        Write-ScriptLog "Failed to change Timezone, the current Timezone is : $((C:\windows\system32\tzutil.exe /g))"
    }
