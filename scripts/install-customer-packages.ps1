param (
    [string]$customerName
)

# Load JSON file
$jsonFilePath = "..\config\config.json"
$jsonContent = Get-Content $jsonFilePath -Raw
$data = ConvertFrom-Json $jsonContent

# Main script

# Retrieve customer information
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

foreach ($vm in $virtualMachines) {
    $ipAddress = $vm.ipAddress
    $msis = $vm.msis

    # Run the Install-MSIs function in parallel for each VM
    $jobs += Start-Job -ScriptBlock {
        param ([string]$ipAddress, [string]$versionToInstall, [array]$msis)
        function Install-MSIs {
            param ([string]$ipAddress, [string]$version, [array]$msis)
        
            foreach ($msi in $msis) {
                $msiName = $msi.msi
                $msiPath = $msi.msipath
                $arguments = $msi.arguments
        
                # Construct the MSI install command
                $argumentString = "/filelocation:$msiPath"
                foreach ($key in $arguments.Keys) {
                    $argumentString += " /$key='$($arguments[$key])'"
                }
                $installCommand = "install-package.ps1 -version $versionToInstall -msiName $msiName -msiArguments $argumentString"
                Invoke-Command -ComputerName $ipAddress -ScriptBlock {
                   param (
                        $installCommand
                     )
                    & $installCommand
                } -ArgumentList $installCommand
            }
        }

        Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis
    } -ArgumentList $ipAddress, $versionToInstall, $msis
}

# Wait for all jobs to complete
$jobs | ForEach-Object { $_ | Wait-Job | Receive-Job }
Write-Output "Installation process completed for customer $customerName."


# sample to run the script with arguments
# .\install-customer-packages.ps1 -customerName 'CustomerA'
#$startTime = Get-Date
#Write-Output "[$startTime] Installing $msiName on $ipAddress with command: $installCommand"
#Start-Sleep -Seconds 3
#$endTime = Get-Date
#Write-Output "[$endTime] Completed installation of $msiName on $ipAddress"
