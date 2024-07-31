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
choco install $msiName --version $version --source="${{ secrets.JFROG_ARTIFACTORY_URL}}api/nuget/${{secrets.JFROG_REPOSITORY}}/" -u=sharad1 -pwd=Sharad@123
# Rollback the version