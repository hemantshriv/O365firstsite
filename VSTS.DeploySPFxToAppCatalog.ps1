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

Write-Host *Get Current Location*
$currentLocation = Get-Location | Select-Object -ExpandProperty Path

Write-Host *Show Current Location*
Write-Host ($currentLocation + $releaseFolder + "\config\package-solution.json")

Write-Host *Get Packate Config*
$packageConfig = Get-Content -Raw -Path ($currentLocation + $releaseFolder + "\config\package-solution.json") | ConvertFrom-Json
Write-Host "Show Packate Config: $packageConfig"

Write-Host *Get Packate paht*
$packagePath = Join-Path ($currentLocation + $releaseFolder + "\sharepoint\") $packageConfig.paths.zippedPackage -Resolve #Join-Path "sharepoint/" $packageConfig.paths.zippedPackage -Resolve
Write-Host "packagePath: $packagePath"

$skipFeatureDeployment = $packageConfig.solution.skipFeatureDeployment
Write-Host "skip Feature Deployment:$skipFeatureDeployment"

Write-Host (Connect-PnPOnline -AppId $appId -AppSecret $appSecret -Url $catalogSite)

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
