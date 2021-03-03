$rg  = Get-Date -Format "ddMMyyyyHHmm_RG"

New-AzResourceGroup -Name $rg -Location westeurope -Tags @{"Purpose"="$Purpose";"Owner"="$Owner";"Customer"="$Customer"} -Force

New-AzResourceGroupDeployment `
-ResourceGroupName $rg `
-TemplateUri "https://raw.githubusercontent.com/AIGARSJ/ARM/main/101-WindowsVirtualMachine.json" `
-TemplateParameterFile '.\101'