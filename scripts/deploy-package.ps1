param (
    [string]$customerName='CustomerA'
)

# Load JSON file
$jsonFilePath = "..\config\config.json"
$jsonContent = Get-Content $jsonFilePath -Raw
$data = ConvertFrom-Json $jsonContent

# Main script

# Retrieve customer information
$customer = $data.customers | Where-Object { $_.customer -eq $customerName }

if ($null -eq $customer) {
    Write-Output "Customer not found."
    exit
}


$customerName = $customer.customer
$versionToInstall = $customer.versionToInstall
$virtualMachines = $customer.virtualMachines

if ($virtualMachines.Count -gt 0) {
    $jobs = @()

    foreach ($vm in $virtualMachines) {
        $ipAddress = $vm.ipAddress
        $msis = $vm.msis

        # Run the Install-MSIs function in parallel for each VM
        $jobs += Start-Job -ScriptBlock {
            param (
                $ipAddress,
                $versionToInstall,
                $msis
            )
            function Install-MSIs {
                param (
                    [string]$ipAddress,
                    [string]$version,
                    [array]$msis
                )
            
                foreach ($msi in $msis) {
                    $msiName = $msi.msi
                    $msiPath = $msi.msipath
                    $arguments = $msi.arguments
            
                    # Construct the MSI install command
                    $argumentString = ""
                    foreach ($key in $arguments.Keys) {
                        $argumentString += "/$key=$($arguments[$key]) "
                    }
                    $installCommand = "msiexec /i $msiPath $argumentString"
            
                    $startTime = Get-Date
                    Write-Output "[$startTime] Installing $msiName on $ipAddress with command: $installCommand"
                    Start-Sleep -Seconds 3
                    $endTime = Get-Date
                    Write-Output "[$endTime] Completed installation of $msiName on $ipAddress"
                    # Invoke-Command -ComputerName $ipAddress -ScriptBlock {
                    #     param (
                    #         $installCommand
                    #     )
                    #     Invoke-Expression $installCommand
                    # } -ArgumentList $installCommand
                }
            }

            Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis

        } -ArgumentList $ipAddress, $versionToInstall, $msis
    }

    # Wait for all jobs to complete
    $jobs | ForEach-Object { $_ | Wait-Job | Receive-Job }
} else {
    Write-Output "No virtual machines specified for customer $customerName."
}

Write-Output "Installation process completed for all customers."


# sample to run the script with arguments
# .\deploy-package.ps1 -customerName 'CustomerA'
