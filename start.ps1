#To be able download modules directly from powershell check this URL:
#https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-6
#
#Search module
Find-Module Az
#Download module
Install-Module Az -Force

#If Az module already downloaded and installed
Update-Module Az -Force
Import-Module Az
$Credential = Get-Credential -Credential aigars.jepifanovs@hortusdigital.com
Connect-AzAccount -Credential $Credential -Subscription 07358cec-7b2a-42cc-9b18-d33a05f2262c

Set-AzContext -Subscription 35c284a2-be13-4b2f-9894-2440ffbbe51f

#Select another subscription
Get-AzSubscription