# Define the Log-Message function
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] $message"
    $logFile = "C:\ProgramData\phishingLog.txt"  # Specify the path where the log should be stored
    Add-Content -Path $logFile -Value $logEntry
}

# Function to simulate an antivirus scan
function Simulate-AntivirusScan {
    Write-Host "Starting antivirus scan..."
    Start-Sleep -Seconds 2
    Write-Host "Scanning C:\Program Files..."
    Start-Sleep -Seconds 2
    Write-Host "Scanning C:\Windows..."
    Start-Sleep -Seconds 2
    Write-Host "Warning: Malware detected in C:\Users\Public!"
    Start-Sleep -Seconds 1
    Write-Host "Critical: Your system is infected. Click the link below to remove the virus."
    Write-Host "Visit: http://example-phishing-test.local/remove-virus"
}

# Log the action
Log-Message "Simulated antivirus scan initiated."

# Start the simulation
Simulate-AntivirusScan
