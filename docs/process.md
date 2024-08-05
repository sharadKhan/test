# GitHub Actions

## 1. create-package

## 2. create-packages

## 3. install-package

## 4. install-packages

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
    
### Steps

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

- Site Server.msi

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps


  - ServerUpdater_SuperSite.exe

  #### Parameters

  #### Pre-installation steps

  #### Post-installation steps

  
 ### References  
[Parallel Execution on Same Runner](https://github.com/orgs/community/discussions/26769)

  #### Validation steps

  #### Rollback steps
