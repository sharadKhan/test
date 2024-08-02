# Set environment variables for authentication
$env:GOOGLE_APPLICATION_CREDENTIALS = "$env:GITHUB_WORKSPACE\gcp_key.json"

# Write a document to Firestore using gcloud CLI
$project_id = $env:GCP_PROJECT
$collection = "orders"
$document = "user1"
$name = "John Doe"
$email = "john.doe@example.com"

gcloud firestore documents create $collection/$document --data="name=$name,email=$email" --project=$project_id

Write-Host "Document successfully written to Firestore."
