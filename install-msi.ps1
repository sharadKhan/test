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

# Install the nupkg file using Chocolatey
choco install $name  --source=$nupkgpath -y
