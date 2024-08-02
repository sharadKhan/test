param ([string]$customerName)

# Load JSON file.
$jsonFilePath = ".\config\config.json"
$jsonContent = Get-Content $jsonFilePath -Raw
$data = ConvertFrom-Json $jsonContent

# Retrieve customer information.
$customer = $data.customers | Where-Object { $_.customer -eq $customerName }

if ($null -eq $customer) {
    Write-Output "Customer $customerName not found."
    exit
}

$customerName = $customer.customer
$versionToInstall = $customer.versionToInstall
$virtualMachines = $customer.virtualMachines

if ($virtualMachines.Count -eq 0) {
    Write-Output "No virtual machines specified for customer $customerName."
    exit
}

$jobs = @()

$workingDirectory = Get-Location

foreach ($vm in $virtualMachines) {
    $ipAddress = $vm.ipAddress
    $msis = $vm.msis

    # Run the Install-MSIs function in parallel for each VM.
    $jobs += Start-Job -ScriptBlock {
        param ([string]$ipAddress, [string]$versionToInstall, [array]$msis , [string]$scriptFilePath, [string]$workingDirectory)
        
        function Install-MSIs {
            param ([string]$ipAddress, [string]$version, [array]$msis, [string]$workingDirectory)

            foreach ($msi in $msis) {
                $msiName = $msi.msi
                $msiPath = $msi.msipath
                $arguments = $msi.arguments
        
                # Construct the MSI install command.
                $argumentString = "/filelocation:$msiPath /arguments:"
                foreach ($key in $arguments.Keys) {
                    $argumentString += "%space%/$key='$($arguments[$key])'"
                }
                Write-Host "Installing in VM"
                &  $workingDirectory/scripts/install-package.ps1 -version $version -msiName $msiName -msiArguments $argumentString -remote_host $ipAddress -workingDirectory $workingDirectory
            }
        }

        Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis -workingDirectory $workingDirectory
    } -ArgumentList $ipAddress, $versionToInstall, $msis, $installScriptFilePath, $workingDirectory
}

# Wait for all jobs to complete.
$jobs | ForEach-Object { $_ | Wait-Job | Receive-Job }
Write-Host "Installation process completed for customer $customerName."
