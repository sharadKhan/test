# Function to create a checksum for a shared file accessible with credentials
function Get-FileChecksum {
    param (
        [string]$FilePath, 
        [PSCredential]$Credential, 
        [string]$Algorithm = "SHA256"
    )

    # Map the network drive with the provided credentials
    $driveLetter = "Z:"
    $networkPath = Split-Path -Path $FilePath -Parent
    $mappedDrive = New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $networkPath -Credential $Credential 

    try {
        # Get the full path to the file
        $fileFullPath = Join-Path -Path $mappedDrive.Root -ChildPath (Split-Path -Path $FilePath -Leaf)

        # Compute the checksum of the file
        $hash = Get-FileHash -Path $fileFullPath -Algorithm $Algorithm

        # Return the hash value
        return $hash.Hash
    }
    finally {
        # Remove the mapped drive
        Remove-PSDrive -Name $driveLetter -Confirm:$false
    }
}

function Remove-FilesExcept {
    param (
        [string]$DirectoryPath,
        [string]$FilePathToKeep
    )

    # Get the list of all files in the directory
    $allFiles = Get-ChildItem -Path $DirectoryPath -Recurse -File

    # Loop through each file and delete it if it's not the specified file
    foreach ($file in $allFiles) {
        if ($file.FullName -ne $FilePathToKeep) {
            Remove-Item -Path $file.FullName -Force
        }
    }
}