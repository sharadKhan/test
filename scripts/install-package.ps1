param (
    [string]$version,
    [string]$msiName,
    [string]$msiArguments,
    [string]$remote_host,
    [string]$workingDirectory
)
Set-Location -Path $workingDirectory
$logDir = "logs"
$logFile = "$logDir/install-package-log.log"

# Function to install Chocolatey if it's not already installed.
function Install-Choco {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
    }
}

# Function to install a new version of a package.
function Install-NewVersion {
    param ([string]$packageName, [string]$version, [string]$packageParameters, [string]$remote_host)

    Write-Host "$env:ADMIN_USER $env:ADMIN_PASSWORD"
    $securePassword = ConvertTo-SecureString $env:ADMIN_PASSWORD -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($env:ADMIN_USER, $securePassword)

    $scriptBlock = {
        param ($packageName, $version, $packageParameters, $jFrogUrl, $jFrogRepository, $jFrogUserId, $jFrogPassword)
        $chocoInstallOutput = choco install $packageName --version $version --package-parameters=`"`'$packageParameters`'`" --source "$jFrogUrl/artifactory/api/nuget/$jFrogRepository/" --user=" $jFrogUserId" --password="$jFrogPassword" -y --force
        return $chocoInstallOutput
    }
    $result = Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $packageName, $version, $packageParameters, $env:JFROG_ARTIFACTORY_URL, $env:JFROG_REPOSITORY, $env:JFROG_USERID, $env:JFROG_PASSWORD
    Write-Host "Remote command result:"
    Write-Host $result
    return $true
}

# Function to get the installed version of a package.
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

# Function to get the current timestamp.
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# Function to write output with timestamp to the log file.
function Write-Log {
    param (
        [string]$message
    )
    $timestampedMessage = "$(Get-Timestamp) - $message"
    $timestampedMessage | Out-File -FilePath $logFile -Append
    Write-Output $timestampedMessage
}

# Create log directory if it doesn't exist.
if (-not (Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir
}

# Create log file if it doesn't exist.
if (-not (Test-Path -Path $logFile)) {
    New-Item -ItemType File -Path $logFile
}

# Main script.
Install-Choco

if (Install-NewVersion -packageName $msiName -version $version -packageParameters $msiArguments -remote_host $remote_host) {
    Write-Output "$msiName version $version installed successfully."
}
else {
    # Add rollback
}
