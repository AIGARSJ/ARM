#Define variables for deployment
$rg  = Get-Date -Format "ddMMyyyyHHmm"

$Purpose =  "Test"
$Owner =    "aigars.jepifanovs@hortusdigital.com"
$Customer = "Hortus Digital"

<#

#$TemplateUri =             "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-load-balancer-standard-create/azuredeploy.json"
#$TemplateParameterUri =    ""

###Second Task###
$TemplateFile =            "D:\GitHub\ARM\101-Multiply-Resources\VirtualNetwork.json"
$TemplateFile =            "D:\GitHub\ARM\TEST\VirtualAdapter.json"
$TemplateFile =            "D:\GitHub\ARM\101-Multiply-Resources\VirtualMachine.json"
$TemplateFile =            "D:\GitHub\ARM\101-Multiply-Resources\VirtualMachineStaticIP.json"

#$TemplateParameterFile =   "D:\GitHub\ARM\TEST\param.json"

$TemplateFile =            "D:\GitHub\ARM\101-MBSDevEnv\101-VirtualAdapter.json"
$TemplateParameterFile =   "D:\GitHub\ARM\101-MBSDevEnv\101-VirtualAdapter.parameters.json"

$TemplateFile =            "D:\GitHub\ARM\101-MBSDevEnv\101-VirtualMachine.json"
$TemplateParameterFile =   "D:\GitHub\ARM\101-MBSDevEnv\101-VirtualMachine.parameters.json"

$TemplateFile =            "D:\GitHub\ARM\101-MBSDevEnv\101-PublicIP.json"
$TemplateParameterFile =   "D:\GitHub\ARM\101-MBSDevEnv\101-PublicIP.parameters.json"

#>

#Define variables for deployment
$rg  = Get-Date -Format "ddMMyyyyHHmm"
$Purpose =  "Test"
$Owner =    "aigars.jepifanovs@hortusdigital.com"
$Customer = "Hortus Digital"

#Create Resource Group
New-AzResourceGroup `
-Name "$rg-rg" `
-Location westeurope `
-Tags @{
    "Env"=          $Purpose
    "Owner"=        $Owner
    "BusinessName"= $Customer
} -Force

#Deploy virtual network
$TemplateFile =            "D:\GitHub\ARM\101-Multiply-Resources\VirtualNetwork.json"
New-AzResourceGroupDeployment `
-ResourceGroupName          "armdepl-test-westeu-rg" `
-TemplateFile               "$TemplateFile" `
-Name                       "$Purpose`-$rg" `
-ProjectName                "AJ" `
-Location                   "westeurope"

#Deploy VM and resources
$TemplateFile =            "D:\GitHub\ARM\101-Multiply-Resources\VirtualMachineStaticIP.json"
New-AzResourceGroupDeployment `
-ResourceGroupName          "armdepl-test-westeu-rg" `
-TemplateFile               "$TemplateFile" `
-Name                       "$Purpose`-Deployment" `
-ProjectName                "AJ" `
-Daudzums                   "3" `
-Location                   "westeurope"

#Destroy VM and all resources
Get-AzResourceGroup $rg | Remove-AzResourceGroup -Force
