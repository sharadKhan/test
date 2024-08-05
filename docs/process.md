# GitHub Actions

## create-package

## install-customer-packages

### Strategies

- **Parallel Execution** \
  Run the build and deployment processes in parallel rather than sequentially using  GitHub Actions Parallel Jobs
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
    
#### Links  
[Parallel Execution on Same Runner](https://github.com/orgs/community/discussions/26769)
### Steps

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

  #### Rollback steps
