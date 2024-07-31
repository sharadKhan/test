param (
    [string]$version,
    [string]$filename,
    [string]$packagepath,
    [string]$msipath
)

$currentPath = Get-Location
$filename = $filename -replace ' ', ''

# Get checksum
$checksum = Get-FileHash -Path $msipath -Algorithm SHA256 | Select-Object -ExpandProperty Hash

# Set paths
Set-Location -Path $packagepath
$packageDir = Join-Path -Path (Get-Location) -ChildPath $filename
$nuspecPath = Join-Path -Path $packageDir -ChildPath "$filename.nuspec"
$installScriptPath = Join-Path -Path $packageDir -ChildPath "tools\chocolateyinstall.ps1"


# Create a new Chocolatey package
choco new $filename --version $version

$xml = [xml](Get-Content $nuspecPath)
$xml.package.metadata.id = $filename
$xml.package.metadata.title = $filename
$xml.package.metadata.authors = "UKG"
$xml.package.metadata.summary = ""
$xml.package.metadata.description = $filename
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
    softwareName   = '$filename'
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
Write-Output "Package processed successfully: $filename"
