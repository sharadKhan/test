const fs = require("fs");

var customer = process.env.Customer;
var location = process.env.Location;
var version = process.env.Version;
var workingDirectory = process.env.github.workspace;

const customersFilePath = workingDirectory + "//docs//sample.json";
var response = [];

const customers = JSON.parse(fs.readFileSync(customersFilePath, "utf-8"));

// Function to fetch customer details
function getCustomerDetails(cust) {
  return customers.filter((c) => c.customer === cust);
}

// Function to fetch customer details by location
const getCustomerDetailsByLocation = (loc) => {
  return customers.filter((c) => c.location === loc);
};

function getVersion(versionParameters, v) {
  return versionParameters.find((vp) => vp.version === v);
}

if (customer) {
  filteredCustomers = getCustomerDetails(customer);
} else if (location) {
  filteredCustomers = getCustomerDetailsByLocation(location);
}
if (!filteredCustomers) {
  return [];
}
for (let index = 0; index < filteredCustomers.length; index++) {
  const cust = filteredCustomers[index];
  var result = getVersion(cust.versionParameters, version).virtualMachines;
  console.log(result);

  for (let index = 0; index < result.length; index++) {
    const msis = result[index].msis;
    for (let i = 0; i < msis.length; i++) {
      const msi = msis[i];
      var res = {};
      res.ipAddress = result.ipAddress;
      res.msiPath = msi.msiPath;
      res.destinationPath = msi.destinationPath;
      response.push(res);
    }
  }
}
console.log(response);
return response;
