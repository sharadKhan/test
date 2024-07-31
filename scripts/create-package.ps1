param (
    [string]$version,
    [string]$msiName,
    [string]$packagePath,
    [string]$msiPath
)

$currentPath = Get-Location

# Remove space as there should not be any spaces got .nuspec file
$msiName = $msiName -replace ' ', ''

# Get checksum
$checksum = Get-FileHash -Path $msiPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash


if (-Not (Test-Path -Path $packagePath)) {
    # Create the path if it doesn't exist
    New-Item -Path $packagePath -ItemType Directory -Force
    Write-Output "Created directory: $packagePath"
}

# Set paths
Set-Location -Path $packagePath
$packageDir = Join-Path -Path (Get-Location) -ChildPath $msiName
$nuspecPath = Join-Path -Path $packageDir -ChildPath "$msiName.nuspec"
$installScriptPath = Join-Path -Path $packageDir -ChildPath "tools\chocolateyinstall.ps1"


# Create a new Chocolatey package
choco new $msiName --version $version

$xml = [xml](Get-Content $nuspecPath)
$xml.package.metadata.id = $msiName
$xml.package.metadata.title = $msiName
$xml.package.metadata.summary = ""
$xml.package.metadata.description = $msiName
$projectUrlNode = $xml.package.metadata.SelectSingleNode("projectUrl")
$authorsNode = $xml.package.metadata.SelectSingleNode("authors")
if ($projectUrlNode) {
    $xml.package.metadata.RemoveChild($projectUrlNode)
}
if ($authorsNode) {
    $xml.package.metadata.RemoveChild($authorsNode)
}
$xml.Save($nuspecPath)

$installScriptContent = @"
`$pp = Get-PackageParameters
Write-Host `$pp['filelocation']
Write-Host `$pp['arguments']
`$fileLocation = `$pp['filelocation']
`$finalargs = `$pp['arguments'] -replace '&space;', ' '
Write-Host "final arguments `$finalargs"

`$packageArgs = @{
    packageName    = `$env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = `$fileLocation
    softwareName   = '$msiName'
    checksum64     = '$checksum'
    checksumType64 = 'sha256'

    silentArgs     = `$finalargs
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 

"@
Set-Content -Path $installScriptPath -Value $installScriptContent

# Pack the package
choco pack $nuspecPath
Set-Location -Path $currentPath
Write-Output "Package processed successfully: $msiName"



# sample to run the script with arguments
# .\create-package.ps1 -version '10.0.1' -msiName 'MSIDemo' -packagePath 'D:\CHOCO\packs' -msiPath '..\builds\MSIDemo.msi'

