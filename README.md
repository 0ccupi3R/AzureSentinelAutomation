# AzureSentinelAutomation
This repository contains the collection of script for Azure Sentinel

## Convert Azure Sentinel ARM (JSON) Rules to YAML File

1. Export one or many analytics rules from Azure Sentinel (you will get JSON file)
2. Donwload the this Powershell script and Exeute the below command with the approrpiate path.
```shell
ConvertARMToYAML -Filename "C:\User\Download\AnalyticsRules.json"
```
3. Finally, you will get all the YAML files in current folder.
