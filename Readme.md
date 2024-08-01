# Enable PowerShell Remoting

```powershell
Enable-PSRemoting -Force
```

# Allow PowerShell Remoting through Windows Firewall

```powershell
Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any
```

# Set the WinRM service to start automatically

```powershell
Set-Service -Name WinRM -StartupType Automatic
```

# Start the WinRM service

```powershell
Start-Service -Name WinRM
```

# Add a computer to the trusted hosts list

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "RemoteComputerName"
```
