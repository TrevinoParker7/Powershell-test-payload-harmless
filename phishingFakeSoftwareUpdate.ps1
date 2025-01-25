# Define the log file path
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "FakeUpdatePopUp.ps1"

# Function to log messages
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$scriptName] $message"
    Add-Content -Path $logFile -Value $logEntry
}

# Function to show a fake software update alert
function Show-FakeUpdatePopUp {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "A critical software update is required for your system. Click 'OK' to download and install the update now.",
        "Software Update",
        [System.Windows.MessageBoxButton]::OKCancel,
        [System.Windows.MessageBoxImage]::Warning
    )
}

# Log the action
Log-Message "Displaying simulated fake software update pop-up."

# Show the fake update pop-up
Show-FakeUpdatePopUp
