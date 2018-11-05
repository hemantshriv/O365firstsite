#################
# Configuration # test checkin
#################
Param(
    [string]$appId, # => site App ID
    [string]$appSecret, # => site App Secret key 
    [string]$catalogSite, # => App Catalog site "https://<Tanent>.sharepoint.com/sites/apps"
    [string]$releaseFolder # => TFS folder where the files are extracted
)
#######
# End #
#######
Write-Host ***************************************** -ForegroundColor Yellow
Write-Host * Uploading the sppkg on the AppCatalog * -ForegroundColor Yellow
Write-Host ***************************************** -ForegroundColor Yellow
$currentLocation = Get-Location | Select-Object -ExpandProperty Path
Write-Host ($currentLocation + $releaseFolder + "\config\package-solution.json")
$packageConfig = Get-Content -Raw -Path ($currentLocation + $releaseFolder + "\config\package-solution.json") | ConvertFrom-Json
$packagePath = Join-Path ($currentLocation + $releaseFolder + "\sharepoint\") $packageConfig.paths.zippedPackage -Resolve #Join-Path "sharepoint/" $packageConfig.paths.zippedPackage -Resolve
Write-Host "packagePath: $packagePath"
$skipFeatureDeployment = $packageConfig.solution.skipFeatureDeployment

Connect-PnPOnline -AppId $appId -AppSecret $appSecret -Url $catalogSite 

# Adding and publishing the App package
If ($skipFeatureDeployment -ne $true) {
  Write-Host "skipFeatureDeployment = false"
  Add-PnPApp -Path $packagePath -Publish -Overwrite
  Write-Host *************************************************** -ForegroundColor Yellow
  Write-Host * The SPFx solution has been succesfully uploaded and published to the AppCatalog * -ForegroundColor Yellow
  Write-Host *************************************************** -ForegroundColor Yellow
}
Else {
  Write-Host "skipFeatureDeployment = true"
  Add-PnPApp -Path $packagePath -SkipFeatureDeployment -Publish -Overwrite
  Write-Host *************************************************** -ForegroundColor Yellow
  Write-Host * The SPFx solution has been succesfully uploaded and published to the AppCatalog * -ForegroundColor Yellow
  Write-Host *************************************************** -ForegroundColor Yellow
}
