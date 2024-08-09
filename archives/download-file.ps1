# Server IP and credentials
$serverIP = "172.29.74.154"
$username = "m.abhishek@sonata-software.com"
$password = "GV@123456" # Use environment variables or GitHub Secrets

# Shared folder path and local destination on the server
$sharedFolder = "\\BG4NB1280\Shared"
$localDestination = "C:\Program Files"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Script block to run on the remote server
$scriptBlock = {
    param($sharedFolder, $localDestination, $credential)
    
    # Map the shared network drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root $sharedFolder -Credential $credential -Persist
    
    # Copy the file to the local destination
    Copy-Item -Path "Z:\test.txt" -Destination $localDestination -Force
    
    # Optionally remove the network drive mapping
    Remove-PSDrive -Name Z
}

# Execute the script block on the remote server
Invoke-Command -ComputerName $serverIP -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $sharedFolder, $localDestination, $credential

