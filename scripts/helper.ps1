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