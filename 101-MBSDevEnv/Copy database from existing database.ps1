#Copy database from existing database
New-AzSqlDatabaseCopy -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $sourceDatabaseName -CopyResourceGroupName $resourceGroupName -CopyServerName $serverName -CopyDatabaseName $sourceDatabaseName
#Modify SQL Tables ()
# ...
#Set Storage Account
$resourceGroupName = "Management"
$StorageAccount = "hortusdigitalinstalls"
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $StorageAccount).context
$SAS = New-AzStorageAccountSASToken -Context $context -Service Blob -ResourceType Service,Container,Object -Permission rwlac
#Get SQL Secret
$kv = Get-AzKeyVault -ResourceGroupName "mgmt-prod-westeu-rg" -VaultName "mgmt-prod-westeu-kv"
$Password = Get-AzKeyVaultSecret -VaultName $kv.VaultName -Name "vmAdminPassword" -AsPlainText
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
#Export database
$serverName = "hdsaassqlserver"
$sourceDatabaseName = "BC147_ABAVAS_W1_PROD-2021-4-9-11-42"
$resourceGroupName = "bc365-prod-westeu-rg"
New-AzSqlDatabaseExport -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $sourceDatabaseName `
-StorageKeyType "SharedAccessKey" `
-StorageKey $SAS `
-StorageUri "https://hortusdigitalinstalls.blob.core.windows.net/backups/$sourceDatabaseName.bacpac"`
-AdministratorLogin "admin-hortus" `
-AdministratorLoginPassword $Password `
-AuthenticationType "Sql" `
-WhatIf



