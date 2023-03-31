# Usage
# 1. Export one or many analytics rules from Azure Sentinel (you will get JSON file)
# 2. Donwload the this Powershell script and Exeute the below command with the approrpiate path.
# ConvertARMToYAML -Filename "C:\User\Download\AnalyticsRules.json"

param (
    [parameter(mandatory = $true)][string]$FileName

)

$Rules = (Get-Content -Path $FileName | ConvertFrom-Json)

$SentinelARConverterModule = Get-InstalledModule -Name SentinelARConverter -ErrorAction SilentlyContinue
if ($null -eq $SentinelARConverterModule) {
    Write-Warning "The SentinelARConverter PowerShell module is not found"
    Write-Warning "Installing SentinelARConverter module to current user Scope"
    Install-Module -Name SentinelARConverter  -Scope CurrentUser -Force
    Write-Host ""
}

foreach ($Rule in $Rules.resources) {
    $RuleContent = ($Rule | ConvertTo-Json -Depth 10)
    $UpdatedRule = @"
{
    "`$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspace": {
            "type": "String"
        }
    },
    "resources": [
        $RuleContent
    ]
}
"@

    $NewFileName = $Rule.properties.displayName -Replace '[^0-9A-Z]', ' '
    $NewFileName = ((Get-Culture).TextInfo.ToTitleCase($NewFileName) -Replace ' ') + '.yaml'
    Write-Host "$($Rule.properties.displayName) --> $NewFileName" 
    Convert-SentinelARArmToYaml -Data $UpdatedRule -OutFile $NewFileName
}
