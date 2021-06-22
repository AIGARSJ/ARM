How to use ARM template test
Get-ChildItem *.ps1, *.psd1, *.ps1xml, *.psm1 -Recurse | Unblock-File
Import-Module ./arm-ttk.psd1
Test-AzTemplate -TemplatePath /path/to/template