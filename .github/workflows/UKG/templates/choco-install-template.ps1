$packageParameters = Get-PackageParameters
$space = "%space%" ## To Check
$fileLocation = $packageParameters['filelocation'] -replace $space, ' '
$logPath = $packageParameters['logpath'] -replace $space, ' '
$arguments = $packageParameters['arguments'] -replace $space, ' '

$defaultSilentArgs = '/quiet /norestart'
$silentArgs = "$defaultSilentArgs $arguments /l*vx `"$logPath`"" 

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = $fileLocation
    softwareName   = '%msiName%'
    checksum64     = '%checksum%'
    checksumType64 = 'sha256'

    silentArgs     = $silentArgs
    validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs 