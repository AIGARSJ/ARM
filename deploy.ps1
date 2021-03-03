$rg  = Get-Date -Format "ddMMyyyyHHmm_RG"
$Purpose = "Testing"
$Owner = "Aigars Jepifanovs"
$Customer = "Hortus Digital"

New-AzResourceGroup -Name $rg -Location westeurope -Tags @{"Purpose"="$Purpose";"Owner"="$Owner";"Customer"="$Customer"} -Force

New-AzResourceGroupDeployment `
-ResourceGroupName $rg `
-TemplateUri "https://raw.githubusercontent.com/AIGARSJ/ARM/main/101-WindowsVirtualMachine/101-WindowsVirtualMachine-Template.json" `
-TemplateParameterUri "https://raw.githubusercontent.com/AIGARSJ/ARM/main/101-WindowsVirtualMachine/101-WindowsVirtualMachine-Parameter.json"