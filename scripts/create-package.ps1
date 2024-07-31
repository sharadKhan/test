param (
    [string]$version,
    [string]$msiname,
    [string]$packagepath,
    [string]$msipath
)

$currentPath = Get-Location

# Remove space as there should not be any spaces got .nuspec file
$msiname = $msiname -replace ' ', ''

# Get checksum
$checksum = Get-FileHash -Path $msipath -Algorithm SHA256 | Select-Object -ExpandProperty Hash


if (-Not (Test-Path -Path $PackagePath)) {
    # Create the path if it doesn't exist
    New-Item -Path $PackagePath -ItemType Directory -Force
    Write-Output "Created directory: $PackagePath"
}

# Set paths
Set-Location -Path $PackagePath
$packageDir = Join-Path -Path (Get-Location) -ChildPath $msiname
$nuspecPath = Join-Path -Path $packageDir -ChildPath "$msiname.nuspec"
$installScriptPath = Join-Path -Path $packageDir -ChildPath "tools\chocolateyinstall.ps1"


# Create a new Chocolatey package
choco new $msiname --version $version

$xml = [xml](Get-Content $nuspecPath)
$xml.package.metadata.id = $msiname
$xml.package.metadata.title = $msiname
$xml.package.metadata.summary = ""
$xml.package.metadata.description = $msiname
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
`$fileLocation = `$pp['filelocation']
`$finalargs = `$pp['arguments'] -replace '&space;', ' '

`$packageArgs = @{
    packageName    = `$env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = `$fileLocation
    softwareName   = '$msiname'
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
Write-Output "Package processed successfully: $msiname"
