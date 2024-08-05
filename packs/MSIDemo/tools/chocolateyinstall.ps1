$packageParameters = Get-PackageParameters
$fileLocation = $packageParameters['filelocation']
$defaultArgs = "/quiet /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
$arguments = $packageParameters['arguments'] -replace '%space%', ' '
$finalArgs = "$defaultArgs $arguments"

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = $fileLocation
    softwareName   = 'MSIDemo'
    checksum64     = 'D726C5E50B879FA0BF828A844A090181D8C4874A9209C5AC69BFB96EA6444BC6'
    checksumType64 = 'sha256'

    silentArgs     = $finalArgs
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

