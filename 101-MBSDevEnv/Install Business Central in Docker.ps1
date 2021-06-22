#Business Central 14.7 W1 Abavas Dārzi database
$artifactUrl =              Get-BcArtifactUrl -type OnPrem -country w1 -version 14.7
$credential =               New-Object pscredential 'hortus', (ConvertTo-SecureString -String 'Password1!' -AsPlainText -Force)
$appBacpacUri =             "https://hortusdigitalinstalls.blob.core.windows.net/backups/BC147_OBJ_W1_PROD-2021-4-9-11-41.bacpac?sp=r&st=2021-04-09T11:14:05Z&se=2021-04-09T19:14:05Z&spr=https&sv=2020-02-10&sr=b&sig=R3ht5luAUTVXE5to2vtNMxzGmYjJ0INpRtS3IfKoPvM%3D"
$tenantBacpacUri =          "https://hortusdigitalinstalls.blob.core.windows.net/backups/BC147_ABAVAS_W1_PROD-2021-4-9-11-42.bacpac?sp=r&st=2021-04-09T11:13:37Z&se=2021-04-09T19:13:37Z&spr=https&sv=2020-02-10&sr=b&sig=NpDSGRRjykeNsHUgw9%2B8PtRF4wVZgPlBzSAhhU2cPWY%3D"
$licensefile =              "https://hortusdigitalinstalls.blob.core.windows.net/deployment/NAV/Licenses/Developer/BC_14_DEV_W1_23062021.flf?sv=2020-04-08&st=2021-04-09T11%3A06%3A25Z&se=2021-04-10T11%3A06%3A25Z&sr=b&sp=r&sig=v2IbWRACz2ErCpjXPQRkh%2FYCgE7nXdXwr61qvpeLcaM%3D"
$additionalParameters +=    @("--env appbacpac=$appBacpacUri","--env tenantbacpac=$tenantBacpacUri")
New-BCContainer -accept_eula -containerName bc14w1 -artifactUrl $artifactUrl -updateHosts -licenseFile $licensefile -Credential $credential -includeAL -auth NavUserPassword -multitenant -includeCSide -clickonce -additionalParameters $additionalParameters
