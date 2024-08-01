function Load-EnvFile {
    param (
        [string]$envFilePath = ".env"
    )

    if (-Not (Test-Path -Path $envFilePath)) {
        throw "The .env file '$envFilePath' does not exist."
    }

    # Read the .env file line by line
    $envContent = Get-Content -Path $envFilePath

    # Parse the .env file and set environment variables
    foreach ($line in $envContent) {
        if ($line -match "^\s*#") {
            continue  # Skip comment lines
        }

        if ($line -match "^\s*$") {
            continue  # Skip empty lines
        }

        if ($line -match "^\s*([^\s=]+)\s*=\s*(.*)\s*$") {
            $key = $matches[1]
            $value = $matches[2]
            [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
        }
    }
}
