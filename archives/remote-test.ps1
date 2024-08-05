param (
    [string]$remote_host="172.29.74.27",
    [string]$remote_user="m.abhishek@sonata-software.com",
    [string]$remote_password="Gv@123456"
)

# Create a secure credential object
$securePassword = ConvertTo-SecureString $remote_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($remote_user, $securePassword)

$scriptBlock = {

    # Install the nupkg file using Chocolatey
    # choco install MSIDemo --version 10.0.1 --package-parameters="'/filelocation:D:\CHOCO\MSIDemo.msi /arguments:/qn&space;/norestart'"  -source="\\BG4PHS29EPCOVM1\shared"  -y --force
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Chocolatey is not installed. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; 
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
        iwr https://community.chocolatey.org/install.ps1 -UseBasicParsing | iex
      } else {
        Write-Output "Chocolatey is already installed."
    }
    
    # choco install MSIDemo --version '2.0.0'  --package-parameters="'/filelocation:\\BG4PHS29EPCOVM1\shared\MSIDemo.msi /arguments:/qn&space;/norestart'" --source "https://sonatapoc.jfrog.io/artifactory/api/nuget/chocopackages-nuget/" -y --force --user="sharad1" --password="Sharad@123"
    choco install MSIDemo --version 5.0.0 --package-parameters="'/filelocation:\\BG4PHS29EPCOVM1\shared\MSIDemo.msi /arguments:/qn%space%/norestart'" --source 'https://sonatapoc.jfrog.io/artifactory/api/nuget/chocopackages-nuget/' -y --force --user='sharad1' --password='Sharad@123'


}

Invoke-Command -ComputerName $remote_host -Credential $credential -ScriptBlock $scriptBlock
