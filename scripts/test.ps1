
$jsonFilePath = "config\config-test.json"
$jsonContent = Get-Content $jsonFilePath -Raw
$data = ConvertFrom-Json $jsonContent

$customer = $data.customers | Where-Object { $_.customer -eq 'CustomerA' }

$customerName = $customer.customer
$versionToInstall = $customer.versionToInstall
$virtualMachines = $customer.virtualMachines
foreach ($vm in $virtualMachines) {
    $ipAddress = $vm.ipAddress
    $msis = $vm.msis
}


function Install-MSIs {
    param ([string]$ipAddress, [string]$version, [array]$msis)

    foreach ($msi in $msis) {
        $msiName = $msi.msi
        $msiPath = $msi.msipath
        $arguments = $msi.arguments

        # Construct the MSI install command
        $argumentString = "/filelocation:$msiPath /arguments:/qn&space;/norestart"
        foreach ($key in $arguments.Keys) {
            $argumentString += "&space;/$key='$($arguments[$key])'"
        }
        $installCommand = ".\install-package.ps1 -version $version -msiName $msiName -msiArguments $argumentString"

        $scriptBlock = {
            # Run command
            $installCommand
        }
        Invoke-Command -ComputerName $ipAddress -Credential $credential -ScriptBlock $scriptBlock
        
    }
}

Install-MSIs -ipAddress $ipAddress -version $versionToInstall -msis $msis