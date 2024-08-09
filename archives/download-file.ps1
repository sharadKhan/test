param (
    [string]$remote_host="172.29.74.35",
    [string]$remote_user="m.abhishek@sonata-software.com",
    [string]$remote_password="Gv@123456"
)

$sharedFolder = "\\BG4NB1280\Shared"
$localDestination = "C:\Program Files"

# Create a secure credential object
$securePassword = ConvertTo-SecureString $remote_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remote_user, $securePassword)

$scriptBlock = {

    param($sharedFolder, $localDestination, $credential)
        $reremote_user="sharad.k@sonata-software.com"
        $reremote_password="July2024@123"
    
        $ssecurePassword = ConvertTo-SecureString $reremote_password -AsPlainText -Force
        $ccredential = New-Object System.Management.Automation.PSCredential ($reremote_user, $ssecurePassword)

        $Session = New-PSSession -ComputerName "172.29.74.10" -Credential $ccredential
        $destinationPath = "C:\CHOCO"

        $filePath = Invoke-Command -Session $Session -ScriptBlock{
            $filePath = Get-WmiObject -Class Win32_Share -Filter "Name='sharad'"
            return $filePath.Path
        }

        Copy-Item "$filePath\New Text Document.txt" -Destination "$destinationPath" -FromSession $Session
}

Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $sharedFolder , $localDestination, $credential























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
    
#     ping google.com
#     # Map the shared network drive
#     # New-PSDrive -Name Z -PSProvider FileSystem -Root $sharedFolder -Credential $credential -Persist
    
#     # # Copy the file to the local destination
#     # Copy-Item -Path "Z:\test.txt" -Destination $localDestination -Force
    
#     # # Optionally remove the network drive mapping
#     # Remove-PSDrive -Name Z
# }

# # Execute the script block on the remote server
# Invoke-Command -ComputerName $serverIP -Credential $credential -ScriptBlock $scriptBlock -ArgumentList $sharedFolder, $localDestination, $credential

































