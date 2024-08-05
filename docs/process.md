# GitHub Actions

## 1. create-package
This will create a chocolatey packages for a specific MSI and upload to JFrog artifactory.

input: MSIPath, Version
### Steps

## 2. create-packages
This will generate chocolatey packages for all the MSI based on the config file and upload to JFrog artifactory.

input: Json
```json
[
  {
    "version": "6.0.0",
    "msis": [
      {
        "MSI_NAME": "MSIDemo",
        "MSI_PATH": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo.msi"
      },
      {
        "MSI_NAME": "MSIDemo2",
        "MSI_PATH": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo2.msi"
      }
    ]
  },
  {
    "version": "7.0.0",
    "msis": [
      {
        "MSI_NAME": "MSIDemo",
        "MSI_PATH": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo.msi"
      },
      {
        "MSI_NAME": "MSIDemo2",
        "MSI_PATH": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo2.msi"
      }
    ]
  }

]
````
### Steps

## 3. install-package
### Steps

## 4. install-packages
### Steps

# Strategies

- **Parallel Execution** \
  Run the build and deployment processes in parallel rather than sequentially using  GitHub Actions Parallel Jobs \
  Questions: 
  - What are the MSIs which can be deployed in parallel and what are sequential flows.
- **Concurrent Deployment** \
  Deploy MSIs concurrently to different VMs using PowerShell
- **Caching dependencies** \
  Cache dependencies to avoid downloading them in every build process.
- **Incremental Builds** \
  Implement incremental builds where only the changed components are rebuilt.
- **Optimized Scripts** \
  Ensure  build and deployment scripts are optimized for performance.
- **Containerization** \
  Use containers to ensure a consistent environment and reduce setup time. Docker can be used to create images with all necessary dependencies.
    
# Install MSI on Remote System
 [Power Shell Remoting](https://https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/docs-conceptual/learn/ps101/08-powershell-remoting.md)
 [Power Shell Remoting - Second Hop](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/main/reference/docs-conceptual/security/remoting/PS-remoting-second-hop.md)

# Configuration & Secret Management

```json
{
    "customerId": "custmerId",
    "customerName": "CustomerA",
    "location": "Location",
    "version": "3.0.0",
    "versionParamters": [
        {
            "version": "3.0.1",
            "virtualMachines": [
                {
                    "ipAddress": "172.29.74.154",
                    "msis": [
                        {
                            "msi": "MSIDemo",
                            "msipath": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo.msi",
                            "arguments": {
                                "US_LOCAL_SERVER": "sonatashrdss",
                                "US_LOCAL_AUTHENTICATION": "1",
                                "US_PASSWORD": "<<GitHub Secret>>"
                            }
                        }
                    ]
                },
                {
                    "ipAddress": "VM2",
                    "msis": [
                        {
                            "msi": "MSI3",
                            "msipath": "..\\builds\\MSIDemo.msi",
                            "arguments": {
                                "argument1": "value1",
                                "argument2": "value2"
                            }
                        },
                        {
                            "msi": "MSI4",
                            "msipath": "..\\builds\\MSIDemo.msi",
                            "arguments": {
                                "argument1": "value1",
                                "argument2": "value2"
                            }
                        }
                    ]
                }
            ]
        },
        {
            "version": "3.0.0",
            "virtualMachines": [
                {
                    "ipAddress": "172.29.74.154",
                    "msis": [
                        {
                            "msi": "MSIDemo",
                            "msipath": "\\\\BG4PHS29EPCOVM1\\shared\\MSIDemo.msi",
                            "arguments": {
                                "US_LOCAL_SERVER": "sonatashrdss",
                                "US_LOCAL_AUTHENTICATION": "1",
                                "US_PASSWORD": "<<GitHub Secret>>"
                            }
                        }
                    ]
                },
                {
                    "ipAddress": "VM2",
                    "msis": [
                        {
                            "msi": "MSI3",
                            "msipath": "..\\builds\\MSIDemo.msi",
                            "arguments": {
                                "argument1": "value3",
                                "argument2": "value4"
                            }
                        },
                        {
                            "msi": "MSI4",
                            "msipath": "..\\builds\\MSIDemo.msi",
                            "arguments": {
                                "argument1": "value5",
                                "argument2": "value6"
                            }
                        }
                    ]
                }
            ]
        }
    ]
}
```

# Below are the MSIs which needs to be deployed as part of the automation.

- Super Site Server.msi

  #### Parameters

  | Name                    | Is Sensitive | Value |
  | ----------------------- | ------------ | ----- |
  | US_LOCAL_SERVER         |              |
  | US_LOCAL_AUTHENTICATION |              |
  | US_LOCAL_USERNAME       |              |
  | US_LOCAL_PASSWORD       | Yes          |
  | US_MSDTC_MUST_REINSTALL |              |

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- Site Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- Company Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- UltiPro Enterprise Server - Super Site Edition.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- SSO Host Service.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- UltiPro Enterprise Server - Super Site Edition.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- SSO Host Service.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- Sync Service.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- Application Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- DPM Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- BackOffice Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps

- Web Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  #### Validation steps
 
  # Rollback steps

   ### References  
  [Parallel Execution on Same Runner](https://github.com/orgs/community/discussions/26769)

