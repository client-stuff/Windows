<#
.Synopsis
    Regionalsettings-Computer.ps1
.DESCRIPTION
    This will change Unicdoe apps on the machine, look in the init.cpl then third tab.

    Created: 2019-10-15
    Version: 1.0

    Author : Pontus Wendt

    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and
    is not supported by the author.
.EXAMPLE
    .\Regionalsettings-Computer.ps1 -$Primary "sv-se"
    NA
#>

Param(
        [Parameter(mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Primary
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

#CHANGE PROGRAM FOR UNICODE APPS
Set-WinSystemLocale -SystemLocale $Primary
$SystemLocale = (Get-WinSystemLocale).name
if ($SystemLocale -eq "$Primary") 
    {
        Write-ScriptLog "Successfully changed SystemLocale to $Primary"
    }
    else
    {
        Write-ScriptLog "Failed to change Get-culture, the current Culture is : $((Get-WinSystemLocale).name))"
    }