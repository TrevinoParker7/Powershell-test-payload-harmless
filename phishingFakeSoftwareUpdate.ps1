# Define the log file path for the fake update pop-up
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

# Function to show a fake software update alert and log the button click
function Show-FakeUpdatePopUp {
    Add-Type -AssemblyName PresentationFramework
    $result = [System.Windows.MessageBox]::Show(
        "A critical software update is required for your system. Click 'OK' to download and install the update now.",
        "Software Update",
        [System.Windows.MessageBoxButton]::OKCancel,
        [System.Windows.MessageBoxImage]::Warning
    )
    if ($result -eq [System.Windows.MessageBoxResult]::OK) {
        Log-Message "User clicked 'OK' on the fake software update pop-up."
        # Trigger the fake EICAR file creation when 'OK' is clicked
        Create-FakeEicarFile
    } else {
        Log-Message "User clicked 'Cancel' on the fake software update pop-up."
    }
}

# Define the log file path for the EICAR test file creation
$eicarScriptName = "eicar.ps1"

# Function to log messages for EICAR test file creation
function Log-EicarMessage {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$eicarScriptName] $message"
    Add-Content -Path $logFile -Value $logEntry
}

# EICAR Test String
$eicarTestString1 = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$'
$eicarTestString2 = '-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Define the file path where EICAR file will be created
$eicarFilePath = "C:\ProgramData\EICAR.txt"

# Function to create EICAR test file
function Create-FakeEicarFile {
    Log-EicarMessage "Starting creation of EICAR test file."
    try {
        # Check if the file already exists, and if it does, delete it first
        if (Test-Path -Path $eicarFilePath) {
            Remove-Item -Path $eicarFilePath -Force
            Log-EicarMessage "Existing EICAR file found and deleted."
        }

        # Create the EICAR test file
        "$($eicarTestString1)EICAR$($eicarTestString2)" | Out-File -FilePath $eicarFilePath -Force
        Log-EicarMessage "EICAR test file created at $eicarFilePath."

    } catch {
        $errorMessage = "An error occurred while creating the EICAR file: $_"
        Write-Host $errorMessage
        Log-EicarMessage $errorMessage "ERROR"
    }

    # End logging for EICAR creation
    Log-EicarMessage "EICAR test file creation completed."
}

# Log the action
Log-Message "Displaying simulated fake software update pop-up."

# Show the fake update pop-up
Show-FakeUpdatePopUp
