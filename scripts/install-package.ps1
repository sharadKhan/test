param (
    [string]$version,
    [string]$msiName,
    [string]$msiArguments
)

$logDir = "logs"
$logFile = "$logDir/install-package-log.log"

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

# Function to get the current timestamp
function Get-Timestamp {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# Function to write output with timestamp to the log file
function Write-Log {
    param (
        [string]$message
    )
    $timestampedMessage = "$(Get-Timestamp) - $message"
    $timestampedMessage | Out-File -FilePath $logFile -Append
    Write-Output $timestampedMessage
}

# Function to install a new version of a package
function Install-NewVersion {
    param (
        [string]$packageName,
        [string]$version,
        [string]$packageParamters
    )

    try {
        $installCommand = "choco install $packageName --version $version --package-parameters=`"`'$packageParamters`'`" --source=`${{ vars.JFROG_ARTIFACTORY_URL }}/api/nuget/{{ vars.JFROG_REPOSITORY }}` --user=`${{ vars.JFROG_USERID }}` --password=`${{ secrets.JFROG_TOKEN }}` -y --force"
        Write-Output "Running command: $installCommand"

        # Print the output of Invoke-Expression $installCommand
        $output = Invoke-Expression -Command $installCommand
        # Save the output to the log file
        Write-Log $output

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

# Create log directory if it doesn't exist
if (-not (Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir
}

# Create log file if it doesn't exist
if (-not (Test-Path -Path $logFile)) {
    New-Item -ItemType File -Path $logFile
}

# Main script
Install-Choco

$previousVersion = Get-PreviousVersion -packageName $msiName
Write-Output "Previous version of $msiName : $previousVersion"

if (Install-NewVersion -packageName $msiName -version $version -packageParamters $msiArguments) {
    Write-Output "$msiName version $version installed successfully."
} else {
    # Add rollback
}

# sample to run the script with arguments
# .\install-package.ps1 -version '2.0.0' -msiName 'MSIDemo' -jfrogArtifactoryUrl 'https://sonatapoc.jfrog.io/artifactory/api/nuget/chocopackages-nuget/' -jfrogArtifactoryToken 'Sharad@123' -jfrogArtifactoryUserId 'sharad1'

