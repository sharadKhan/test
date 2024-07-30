param (
    [string]$customer_name
)

# Read the configuration file
$config = Get-Content -Raw -Path "./test.json" | ConvertFrom-Json

# Get the MSI details for the specified customer
$msiDetails = $config.$customer_name.msifile1[0]

$name = $msiDetails.name
$version = $msiDetails.version
$msipath = $msiDetails.msipath
$msiargs = $msiDetails.msiargs
$nupkgpath = $msiDetails.nupkgpath
$upgrade = $msiDetails.upgrade

$workspacePath = $env:GITHUB_WORKSPACE

# Ensure the path to the nupkg file is correct
$nupkgFullPath = Join-Path -Path $workspacePath -ChildPath $nuppkgpath

# Install the nupkg file using Chocolatey
choco install $name  --source=$nupkgFullPath -y
