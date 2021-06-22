#Define variables for deployment
$date  =                    Get-Date -Format "ddMMyyyyHHmm"
$rg =                       "$date-rg"
$Purpose =                  "Test"
$Owner =                    "aigars.jepifanovs@hortusdigital.com"
$Customer =                 "Hortus Digital"

#Create Resource Group
New-AzResourceGroup `
-Name                       "$rg" `
-Location                   "westeurope" `
-Tags @{
                            "Env"=          $Purpose
                            "Owner"=        $Owner
                            "BusinessName"= $Customer
} -Force

#Deploy virtual network
$TemplateFile =             "D:\GitHub\ARM\101-Multiply-Resources\VirtualNetwork.json"
New-AzResourceGroupDeployment `
-ResourceGroupName          "$rg" `
-TemplateFile               "$TemplateFile" `
-Name                       "VirtualNetwork`-$Date" `
-ProjectName                "AJ" `
-Location                   "westeurope"

#Deploy VM and resources
$TemplateFile =             "D:\GitHub\ARM\101-Multiply-Resources\VirtualMachineStaticIP.json"
New-AzResourceGroupDeployment `
-ResourceGroupName          "$rg" `
-TemplateFile               "$TemplateFile" `
-Name                       "VirtualMachines`-$Date" `
-ProjectName                "AJ" `
-Daudzums                   "3" `
-Location                   "westeurope"

#Destroy VM and all resources
Get-AzResourceGroup $rg | Remove-AzResourceGroup -Force
