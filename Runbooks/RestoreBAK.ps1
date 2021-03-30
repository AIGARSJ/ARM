<#

Import this modules before run this runbook

Az.Accounts
Az.Automation
Az.Sql

To create or delete management locks, you must have access to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions.
Of the built-in roles, only Owner and User Access Administrator are granted those actions.

#>

#Get variables values from Azure Automation Account variables
$sourceDatabaseNames = Get-AutomationVariable -Name 'Database'
$resourceGroupName = Get-AutomationVariable -Name 'ResourceGroup'
$serverName = Get-AutomationVariable -Name 'SQLServer'
$LockName = Get-AutomationVariable -Name "LockName"
$RunbookName = Get-AutomationVariable -Name "RunbookName"
$AutomationAccountName = Get-AutomationVariable -Name "AutomationAccountName"


$connectionName = "AzureRunAsConnection"

try {

# Get the connection "AzureRunAsConnection "
$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

"Logging in to Azure..."
Connect-AzAccount -ServicePrincipal -TenantId $servicePrincipalConnection.TenantId -ApplicationId $servicePrincipalConnection.ApplicationId -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint -SubscriptionId $servicePrincipalConnection.SubscriptionId

#Set SQL subscription as the working subscription
Get-AzSubscription -TenantId $servicePrincipalConnection.TenantId -SubscriptionId $servicePrincipalConnection.SubscriptionId | Set-AzContext

[string[]] $sourceDatabaseNames = $sourceDatabaseNames -split ","

#Remove Lock
Write-Output "Removing from ResourcesGroup $resourceGroupName Lock $LockName ..."
Get-AzResourceGroup -Name $resourceGroupName | Remove-AzResourceLock -LockName $LockName -Force

foreach ($sourceDatabaseName in $sourceDatabaseNames) {

$replicaDb = (Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -DatabaseName $sourceDatabaseName.Replace("PROD","BAK") -ServerName $serverName -ErrorAction SilentlyContinue)
$replicaDb = $replicaDb.DatabaseName
$sourceTags = (Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -DatabaseName $sourceDatabaseName -ServerName $serverName).Tags

if($replicaDb)
{
    "Removing existing $replicaDb ..."
    Remove-AzSqlDatabase -ResourceGroupName $resourceGroupName -DatabaseName $sourceDatabaseName.Replace("PROD","BAK") -ServerName $serverName

}

"Creating new $replicaDb ..."
New-AzSqlDatabaseCopy -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $sourceDatabaseName -CopyResourceGroupName $resourceGroupName -CopyServerName $serverName -CopyDatabaseName $sourceDatabaseName.Replace("PROD","BAK") -tags $sourceTags

"Set S0 performance level for $replicaDb and Basic service tier for OBJECT database ..."
if ($sourceDatabaseName -like "*_OBJ_*")
{
    Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $sourceDatabaseName.Replace("PROD","BAK") -Edition "Basic" -tags $sourceTags
}
else
{
    Set-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $sourceDatabaseName.Replace("PROD","BAK") -Edition "Standard" -RequestedServiceObjectiveName "S0" -tags $sourceTags
}
                                                    }

#Setup Lock
Get-AzResourceGroup -Name $resourceGroupName | Set-AzResourceLock -LockName $LockName -LockLevel CanNotDelete -LockNotes "Don't delete production resources" -Force
Write-Output "Setting up to ResourcesGroup $resourceGroupName Lock $LockName ..."

Start-AzAutomationRunbook -AutomationAccountName $automationAccountName -Name $runbookName -ResourceGroupName $resourceGroupName

}

catch {
Write-Error -Message $_.Exception
throw $_.Exception
}