param (
    [string]$customerName='CustomerA'
)
# Load JSON file
$jsonFilePath = "..\config\config-test.json"
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

$installScriptFilePath = (Resolve-Path .\install-package.ps1).Path
$currentPath = Get-Location
Write-Host "envpath $currentPath"

foreach ($vm in $virtualMachines) {
    $ipAddress = $vm.ipAddress
    $msis = $vm.msis

    # Run the Install-MSIs function in parallel for each VM
    $jobs += Start-Job -ScriptBlock {
        param ([string]$ipAddress, [string]$versionToInstall, [array]$msis , [string]$scriptFilePath, [string]$remote_user, [securestring]$remote_password, [string]$currentPath)
        
        function Install-MSIs {
            param ([string]$ipAddress, [string]$version, [array]$msis, [string]$remote_user, [securestring]$remote_password, [string]$currentPath)
            
            $password = ConvertFrom-SecureString -String $remote_password -AsPlainText -Force
            foreach ($msi in $msis) {
                $msiName = $msi.msi
                $msiPath = $msi.msipath
                $arguments = $msi.arguments
        
                # Construct the MSI install command
                $argumentString = "/filelocation:$msiPath /arguments:/qn%space%/norestart"
                foreach ($key in $arguments.Keys) {
                    $argumentString += "%space%/$key='$($arguments[$key])'"
                }
                # $setLocation = "Set-Location -Path 'D:\CHOCO\new\test\scripts'"
                # Invoke-Expression $setLocation
                $installCommand = "$scriptFilePath -version $version -msiName $msiName -msiArguments ""$argumentString"" -remote_host $ipAddress -remote_user $remote_user -remote_password {{}} -currentPath $currentPath"
                Write-Host "invoke $installCommand"
                Write-Output "Installing in VM"
                Invoke-Expression $installCommand
            }
        }

        Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis -remote_user $remote_user -remote_password $remote_password -currentPath $currentPath
    } -ArgumentList $ipAddress, $versionToInstall, $msis, $installScriptFilePath, $remoteUser, $secureRemotePassword, $currentPath
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
