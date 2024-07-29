param (
    [string]$packagePath,
    [string]$packageName,
    [string]$packageVersion,
    [string]$gcpProject,
    [string]$gcpRepository,
    [string]$gcpRegion,
    [string]$gcpKeyFile,
    [string]$downloadPath
)
function Authenticate {
    Write-Output "Authenticating with Google Cloud..."
    & gcloud auth activate-service-account --key-file=$gcpKeyFile
}
function CreateArtifactRegistry {
    Write-Output "Creating Artifact Registry repository if it does not exist..."
    $repoExists = & gcloud artifacts repositories list --location=$gcpRegion --filter="name~$gcpRepository" --format="value(name)"
    if (-not $repoExists) {
        & gcloud artifacts repositories create $gcpRepository --repository-format=generic --location=$gcpRegion
    } else {
        Write-Output "Repository $gcpRepository already exists."
    }
}

function PushPackageToArtifactRegistry {
    Write-Output "Pushing package to Google Artifact Registry..."
    gcloud artifacts generic upload --source=$packagePath --project=$gcpProject --location=$gcpRegion --repository=$gcpRepository --package=$packageName --version=$packageVersion
}

function DownloadPackageToArtifactRegistry {
    Write-Output "Downloading package to Google Artifact Registry..."
    gcloud artifacts generic download --destination=$downloadPath --project=$gcpProject --location=$gcpRegion --repository=$gcpRepository --package=$packageName --version=$packageVersion
}

#Main script execution
Authenticate
CreateArtifactRegistry
PushPackageToArtifactRegistry

#Sample
#.\GCPServices.ps1 -packagePath "..\Choco Packages\MSIDemo.22.0.0.43559.nupkg" -packageName "MSIDemo" -packageVersion "22.0.0.43560" -gcpProject "glass-watch-430704-t2"  -gcpRepository "chocopackages" -gcpRegion "asia-south1" -gcpKeyFile "gcpkey.json"
#gcloud artifacts generic download --destination="D:\Samples\UKG" --project=glass-watch-430704-t2 --location=asia-south1 --repository=chocopackages --package="MSIDemo" --version="22.0.0.43560"