<#
.Synopsis
    CBS_E_STORE_CORRUPTION_0x800F0831_KB4103725.ps1
.DESCRIPTION
    Created: 2018-01-23
    Version: 1.0

    Author : Pontus Wendt
    Twitter: @pontuswendt
    Blog   : https://clientstuff.blog

    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and 
    is not supported by the author or DeploymentArtist..
.EXAMPLE
    NA
#>

# 1. Download the .MSU file from Microsoft. https://www.catalog.update.microsoft.com/Search.aspx?q=KB4103725 

# 2. Put it in the C:\Temp folder.

# 3. Locate the folder
Set-location C:\temp

# 4. Extract .msu file.
expand windows8.1-kb4103725-x64_cdf9b5a3be2fd4fc69bc23a617402e69004737d9.msu -f:* C:\TEMP

# 5. Install the update again, 
DISM.exe /Online /Add-Package /PackagePath:C:\TEMP\Windows8.1-KB4103725-x64.cab

# 6. Your done. Try to install the new patch again.