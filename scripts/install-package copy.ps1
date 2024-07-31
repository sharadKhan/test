# param (
#     [string]$version,
#     [string]$msiname,
#     [string]$jfrogarifactoryurl,
#     [string]$jfrogarifactorytoken,
#     [string]$jfrogarifactoryuserId
# )

$version = '22.0.0.43559'
$msiname = 'MSIDemo'
$jfrogarifactoryurl = 'https://sonatapoc.jfrog.io/artifactory/api/nuget/chocopackages-nuget/'
$jfrogarifactorytoken = 'Sharad@123'
$jfrogarifactoryuserId = 'sharad1'

# Function to install Chocolatey if it's not already installed
function Install-Choco {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    }
}

# Function to get the installed version of a package
function Get-PreviousVersion {
    param (
        [string]$packageName
    )

    $package = choco list --exact --include-programs $packageName
    foreach ($line in $package) {
        if ($line -match "$packageName (\d+\.\d+\.\d+)") {
            return $matches[1]
        }
    }
    return $null
}

# Function to install a new version of a package
function Install-NewVersion {
    param (
        [string]$packageName,
        [string]$version,
        [string]$sourceUrl,
        [string]$userId,
        [string]$userToken
    )

    try {
        $installCommand = "choco install $packageName --version $version --source=$sourceUrl --user=$userId --password=$userToken -y"
        Write-Output "Running command: $installCommand"
        Invoke-Expression $installCommand
        if ($LASTEXITCODE -eq 0) {
            return $true
        } else {
            Write-Error "Error during installation: $LASTEXITCODE"
            return $false
        }
    } catch {
        Write-Error "Exception: $_"
        return $false
    }
}

# Function to rollback to the previous version
function Rollback-Version {
    param (
        [string]$packageName,
        [string]$version,
        [string]$sourceUrl,
        [string]$userId,
        [string]$userToken
    )

    Write-Output "Rolling back to version $version..."
    choco install $packageName --version $version --source="$sourceUrl" --user=$userId --password=$userToken
}

# Main script
Install-Choco

$previousVersion = Get-PreviousVersion -packageName $msiname
Write-Output "Previous version of $msiname : $previousVersion"

if (Install-NewVersion -packageName $msiname -version $version -sourceUrl $jfrogarifactoryurl -userId $jfrogarifactoryuserId -userToken $jfrogarifactorytoken) {
    Write-Output "$msiname version $version installed successfully."
} else {
    Write-Error "Error occurred during installation of $msiname version $version."
    if ($previousVersion) {
        Rollback-Version -packageName $msiname -version $previousVersion -sourceUrl $jfrogarifactoryurl -userId $jfrogarifactoryuserId -userToken $jfrogarifactorytoken
    } else {
        Write-Error "No previous version to rollback to."
    }
}
