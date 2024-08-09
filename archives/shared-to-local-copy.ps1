# Define parameters
$remoteIP = "172.29.74.154"       
$remoteUser = "m.abhishek@sonata-software.com"  
$remotePassword = "Gv@123456"
# $sharedPath = "\\BG4PHS29EPCOVM1\shared\MSIDemo.msi"
# $localPath = "D:\MSIFiles"

# Create a PSCredential object for remote login
$securePassword = ConvertTo-SecureString $remotePassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remoteUser, $securePassword)

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.210.222.182" -Force

# Script block to run on the remote machine
$scriptBlock = {

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.210.222.182" -Force
}

# Use Invoke-Command to run the script block on the remote machine
Invoke-Command -ComputerName $remoteIP -Credential $credential -ScriptBlock $scriptBlock 
# Copy-Item -Path $sharedPath -Destination $localPath -Force
# Copy-Item "${{ github.workspace }}\Readme.md" -Destination ""