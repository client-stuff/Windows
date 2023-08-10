<#
.SYNOPSIS
  Name: Add-language-pack.ps1
.DESCRIPTION
Ändrar start order
.NOTES
    Updated: 2017-11-21
    Release Date: 2017-11-21
   
  Author: Pontus Wendt
#>

#Set Executionpolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

# Make some Variables
$ISO = "C:\temp\Add-Language-pack\ISO\sources\install.wim"
$temp_ISO = "C:\temp\Add-Language-pack\temp_ISO"
$Language_files = "C:\temp\Add-Language-pack\Language_files\Microsoft-Windows-Client-Language-Pack_x64_sv-se.cab"
$Scratch = "C:\temp\Add-Language-pack\Scratch"




#What Index Name do you want to modify?
Dism /Get-ImageInfo /ImageFile:$ISO

$Index_NAme = "Windows 10 Enterprise N"

#Mount your ISO with that specific index and put it in a temporary folder.
Dism /Mount-Image /ImageFile:$ISO /Name:$Index_NAme /MountDir:$temp_ISO

#Time to add the language pack
Dism /Image:$temp_ISO /ScratchDir:$Scratch /Add-Package /PackagePath:$Language_files

#Do changes in the mounted Image
Dism /Commit-Image /MountDir:$temp_ISO

#Unmounting the ISO file and saving it..
dism /unmount-Wim /MountDir:$temp_ISO /commit

#DONE!
