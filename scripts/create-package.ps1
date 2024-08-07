param (
    [string]$version,
    [string]$msiPath
)

# Dot-source the helper script
. .\scripts\helper.ps1

$workingDirectory = Get-Location

# Extract filename and Remove space as there should not be any spaces for .nuspec file.
$msiName = [System.IO.Path]::GetFileNameWithoutExtension($msiPath) -replace ' ', ''

# Get checksum.
$checksum = Get-FileHash -Path $msiPath -Algorithm SHA256 | Select-Object -ExpandProperty Hash

# Assign path for choco packages.
$packagePath = './packs'

if (-Not (Test-Path -Path $packagePath)) {
    # Create the path if it doesn't exist.
    New-Item -Path $packagePath -ItemType Directory -Force
    Write-Output "Created directory: $packagePath"
}

# Set paths.
Set-Location -Path $packagePath
$packageDir = Join-Path -Path (Get-Location) -ChildPath $msiName
$nuspecPath = Join-Path -Path $packageDir -ChildPath "$msiName.nuspec"
$toolsDir = Join-Path -Path $packageDir -ChildPath "tools"
$installScriptPath = Join-Path -Path $packageDir -ChildPath "tools\chocolateyinstall.ps1"

# Create a new Chocolatey package.
choco new $msiName --version $version --force

# Remove the files which are not required.
Remove-FilesExcept -DirectoryPath $packageDir -FilePathToKeep $nuspecPath
Remove-FilesExcept -DirectoryPath $toolsDir -FilePathToKeep $installScriptPath

# Edit .nuspec file.
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

# Edit chocolateyinstall.ps1 file.
$installScriptContent = @"
`$packageParameters = Get-PackageParameters
`$fileLocation = `$packageParameters['filelocation'] -replace '%space%', ' '
`$logPath = `$packageParameters['logpath'] -replace '%space%', ' '
`$defaultArgs = '/quiet /norestart'
`$arguments = `$packageParameters['arguments'] -replace '%space%', ' '
`$finalArgs = "`$defaultArgs `$arguments /l*vx ``"`$logPath``"" 

Write-Output "filelocation =  `$fileLocation"
Write-Output "Arguments = `$finalArgs"

`$packageArgs = @{
    packageName    = `$env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = `$fileLocation
    softwareName   = '$msiName'
    checksum64     = '$checksum'
    checksumType64 = 'sha256'

    silentArgs     = `$finalArgs
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

"@

Set-Content -Path $installScriptPath -Value $installScriptContent

# Create .nupkg file.
choco pack $nuspecPath

Set-Location -Path $workingDirectory
Write-Host "Package processed successfully: $msiName"
