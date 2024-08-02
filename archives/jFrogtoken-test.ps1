
$jFrogToken = ''

$header = @{
    Authorization = "Bearer $jFrogToken"
}


choco install MSIDemo --version '5.0.0'  --package-parameters="'/filelocation:D:\CHOCO\MSIDemo.msi'" --source "https://sonatapoc.jfrog.io/artifactory/api/nuget/chocopackages-nuget/" -y --force --headers $header