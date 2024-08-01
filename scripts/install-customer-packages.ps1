param ([string]$customerName)

# Load JSON file
$jsonFilePath = ".\config\config.json"
$jsonContent = Get-Content $jsonFilePath -Raw
$data = ConvertFrom-Json $jsonContent

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

$currentPath = Get-Location

foreach ($vm in $virtualMachines) {
    $ipAddress = $vm.ipAddress
    $msis = $vm.msis

    # Run the Install-MSIs function in parallel for each VM
    $jobs += Start-Job -ScriptBlock {
        param ([string]$ipAddress, [string]$versionToInstall, [array]$msis , [string]$scriptFilePath, [string]$currentPath)
        
        function Install-MSIs {
            param ([string]$ipAddress, [string]$version, [array]$msis, [string]$currentPath)

            foreach ($msi in $msis) {
                $msiName = $msi.msi
                $msiPath = $msi.msipath
                $arguments = $msi.arguments
        
                # Construct the MSI install command
                $argumentString = "/filelocation:$msiPath /arguments:/qn%space%/norestart"
                foreach ($key in $arguments.Keys) {
                    $argumentString += "%space%/$key='$($arguments[$key])'"
                }
                &  $currentPath/scripts/install-package.ps1 -version $version -msiName $msiName -msiArguments ""$argumentString"" -remote_host $ipAddress -currentPath $currentPath
                Write-Output "Installing in VM"
                #Invoke-Expression $installCommand
            }
        }

        Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis -currentPath $currentPath
    } -ArgumentList $ipAddress, $versionToInstall, $msis, $installScriptFilePath, $currentPath
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
