param (
    [string]$customer_name,
    [string]$remote_host,
    [string]$remote_user,
    [string]$remote_password
)

# Create a credential object
$securePassword = ConvertTo-SecureString $remote_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remote_user, $securePassword)

# Define the script block to run on the remote machine
$scriptBlock = {
    param (
        [string]$customer_name
    )

    # Define the path to the configuration file and workspace
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

# Copy the repository to the remote host
Copy-Item -Path $PSScriptRoot\* -Destination \\$remote_host\c$\Temp\Repo -Recurse -Force

# Execute the script block on the remote machine
Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $customer_name

