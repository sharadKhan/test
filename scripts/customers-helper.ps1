param (
    [string]$customers,
    [string]$customer,
    [string]$location
)


# Function to fetch customer details
function Get-CustomerDetails {
    param (
        [string]$customer
    )
    $customers | Where-Object { $_.customer -eq $customer }
}

# Function to fetch customer details by location
function Get-CustomerDetailsByLocation {
    param (
        [string]$location
    )
    $customers | Where-Object { $_.location -eq $location }
}

if ($customer) {
    $customers = Get-CustomerDetails -customer $customer
} elseif ($location) {
    $customers = Get-CustomerDetailsByLocation -location $location
}
if(!$customers){
    exit
}