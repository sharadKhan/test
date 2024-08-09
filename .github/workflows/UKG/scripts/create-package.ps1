param (
    [string]$version,
    [string]$buildPath,
    [string]$checksum
)

# Dot-source the helper script
. .\scripts\helper.ps1

$workingDirectory = Get-Location


# Assign path for choco packages.
$packagePath = './packs'

if (-Not (Test-Path -Path $packagePath)) {
    # Create the path if it doesn't exist.
    New-Item -Path $packagePath -ItemType Directory -Force
    Write-Output "Created directory: $packagePath"
}

# Extract filename and Remove space as there should not be any spaces for .nuspec file.
$msiName = [System.IO.Path]::GetFileNameWithoutExtension($buildPath) -replace ' ', ''

# Set paths.
$packageDir = Join-Path -Path $packagePath -ChildPath $msiName
$nuspecPath = Join-Path -Path $packageDir -ChildPath "$msiName.nuspec"
$toolsDir = Join-Path -Path $packageDir -ChildPath "tools"
$installScriptPath = Join-Path -Path $packageDir -ChildPath "tools\chocolateyinstall.ps1"

# Create a new Chocolatey package.
Set-Location -Path $packagePath
choco new $msiName --version $version --force

# Remove the files which are not required.
Remove-FilesExcept -DirectoryPath $packageDir -FilePathToKeep $nuspecPath
Remove-FilesExcept -DirectoryPath $toolsDir -FilePathToKeep $installScriptPath

# Edit .nuspec file.
$xml = [xml](Get-Content $nuspecPath)
$metadata = $xml.package.metadata;
$metadata.id = $msiName
$metadata.title = $msiName
$metadata.summary = ""
$metadata.description = $msiName
$projectUrlNode = $metadata.SelectSingleNode("projectUrl")
if ($projectUrlNode) {
    $xml.package.metadata.RemoveChild($projectUrlNode)
}
$authorsNode = $metadata.SelectSingleNode("authors")
if ($authorsNode) {
    $xml.package.metadata.RemoveChild($authorsNode)
}
$xml.Save($nuspecPath)

# Edit chocolateyinstall.ps1 file.
$installScriptContent = Get-Content -Path $templatePath -Raw
$installScriptContent = $installScriptContent -replace '%msiName%', $msiName -replace '%checksum%', $checksum
Set-Content -Path $installScriptPath -Value $installScriptContent

# Create .nupkg file.
choco pack $nuspecPath

Set-Location -Path $workingDirectory

