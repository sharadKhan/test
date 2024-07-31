param (
    [string]$version,
    [string]$msiname,
    [string]$jfrogarifactoryurl,
    [string]$jfrogarifactorytoken,
    [string]$jfrogarifactoryuserId,
    [string]$msipath
)

# Install choco
# Get the previous version of the package installed
# Install the new version
        choco install $msiName --version $version --source="$jfrogarifactoryurl /api/nuget/${{secrets.JFROG_REPOSITORY}}/" -u=sharad1 -pwd=Sharad@123
# Rollback the version if there is any error while installing new version