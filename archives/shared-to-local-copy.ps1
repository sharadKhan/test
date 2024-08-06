# Define parameters
$remoteIP = "172.29.74.24"       
$remoteUser = "m.abhishek@sonata-software.com"  
$remotePassword = "Gv@123456"
$sharedPath = "\\BG4PHS29EPCOVM1\shared\MSIDemo.msi"
$localPath = "D:\MSIFiles"

# # Create a PSCredential object for remote login
# $securePassword = ConvertTo-SecureString $remotePassword -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential ($remoteUser, $securePassword)

# # Script block to run on the remote machine
# $scriptBlock = {
#     param (
#         [string]$sharedPath,
#         [string]$localPath
#     )

#     # Copy the file from the shared location to the local drive
#     Copy-Item -Path $sharedPath -Destination $localPath -Force
# }

# # Use Invoke-Command to run the script block on the remote machine
# Invoke-Command -ComputerName $remoteIP -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $sharedPath, $localPath
# Copy-Item -Path $sharedPath -Destination $localPath -Force
Copy-Item "${{ github.workspace }}\Readme.md" -Destination ""