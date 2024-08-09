param (
    [string]$remote_host="172.29.74.154",
    [string]$remote_user="m.abhishek@sonata-software.com",
    [string]$remote_password="Gv@123456"
)

# Create a secure credential object
$securePassword = ConvertTo-SecureString $remote_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remote_user, $securePassword)

$scriptBlock = {

    ping google.com

}

Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock
























# # Server IP and credentials
# $serverIP = "172.29.74.154"
# $username = "SONATA\m.abhishek"
# $password = "GV@123456"

# # Shared folder path and local destination on the server
# $sharedFolder = "\\BG4NB1280\Shared"
# $localDestination = "C:\Program Files"

# # Convert the password to a secure string
# $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# # Script block to run on the remote server
# $scriptBlock = {
#     param($sharedFolder, $localDestination, $credential)
    
#     # Map the shared network drive
#     New-PSDrive -Name Z -PSProvider FileSystem -Root $sharedFolder -Credential $credential -Persist
    
#     # Copy the file to the local destination
#     Copy-Item -Path "Z:\test.txt" -Destination $localDestination -Force
    
#     # Optionally remove the network drive mapping
#     Remove-PSDrive -Name Z
# }

# # Execute the script block on the remote server
# Invoke-Command -ComputerName $serverIP -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $sharedFolder, $localDestination, $credential

