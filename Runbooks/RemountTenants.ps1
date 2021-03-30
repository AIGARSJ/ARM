<#

Import this modules before run this runbook:

Az.Acccouts
Az.Compute

#>

#Define Azure VM via Automation Account variables
$resourceGroupName = Get-AutomationVariable -Name 'ResourceGroup'
$VMNames = Get-AutomationVariable -Name 'VMName'
$uri = Get-AutomationVariable -Name 'URI'

    #----------------------------------------------------------------------------------#
    #---------------------LOGIN TO AZURE AND SELECT THE SUBSCRIPTION-------------------#
    #----------------------------------------------------------------------------------#

    $connectionName = "AzureRunAsConnection"
    try
    {
        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         
    
    Write-Output "Logging into Azure subscription using Az cmdlets..."
    
        Connect-AzAccount `
            -ServicePrincipal `
            -TenantId $servicePrincipalConnection.TenantId `
            -ApplicationId $servicePrincipalConnection.ApplicationId `
            -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint `
            -SubscriptionId $servicePrincipalConnection.SubscriptionId
    
    Write-Output "Successfully logged into Azure subscription using Az cmdlets..."

Write-Output "Downloading script from Azure Storage..."
#Download from Azure Storage blob your prepared script
Invoke-WebRequest $uri -outfile "script.ps1"
Write-Output "Successfully downloaded script from Azure Storage..."

[string[]] $VMNames = $VMNames -split ","

foreach ($VMName in $VMNames) {

Write-Output "Executing script on $VMName..."
#Run on defined VM your downloaded script with your parameters
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -Name $vmname -CommandId 'RunPowerShellScript' -ScriptPath "script.ps1" -Confirm:$false
Write-Output "Execution of script on $VMName finished..."

}

}

catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
    }