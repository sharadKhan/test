param (
)
function Install-GCloudSDK {
        Write-Output "Installing Google Cloud SDK..."
        Invoke-WebRequest -Uri https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe -OutFile $env:TEMP\GoogleCloudSDKInstaller.exe
        Start-Process -Wait -FilePath $env:TEMP\GoogleCloudSDKInstaller.exe
}

# Main script execution
Install-GCloudSDK
