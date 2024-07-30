param (
    [string]$customer_name,
    [string]$remote_host,
    [string]$remote_user,
    [string]$remote_password
)

# Create a secure credential object
$securePassword = ConvertTo-SecureString $remote_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remote_user, $securePassword)

# Define the script block to run on the remote machine
$scriptBlock = {
    param (
        [string]$customer_name
    )

    # Define paths
    $configFile = "C:\Temp\Repo\test.json"
    $workspacePath = "C:\Temp\Repo"

    # Read the configuration file
    $config = Get-Content -Raw -Path $configFile | ConvertFrom-Json

    # Get the MSI details for the specified customer
    $msiDetails = $config.$customer_name.msifile1[0]

    $name = $msiDetails.name
    $version = $msiDetails.version
    $msipath = Join-Path -Path $workspacePath -ChildPath $msiDetails.msipath
    $msiargs = $msiDetails.msiargs
    $nupkgpath = Join-Path -Path $workspacePath -ChildPath $msiDetails.nupkgpath
    $upgrade = $msiDetails.upgrade

    # Install the nupkg file using Chocolatey
    choco install $name --version=$version --source=$nupkgpath -y
}

# Define a script block to copy files to the remote host
$copyScriptBlock = {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )

    # Ensure the destination directory exists
    if (-not (Test-Path -Path $destinationPath)) {
        New-Item -ItemType Directory -Path $destinationPath | Out-Null
    }

    # Copy files to the remote machine
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
}

# Copy the repository to the remote host
$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "*"
$destinationPath = "C:\Temp\Repo"
Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $copyScriptBlock -ArgumentList $sourcePath, $destinationPath

# Execute the installation script on the remote machine
Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $customer_name
