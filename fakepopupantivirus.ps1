# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Logging Setup
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "fakepopupantivirus.ps1"

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

# Function to Check Admin Privileges
function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# EICAR Test File Creation Functions
$eicarScriptName = "eicar.ps1"
$eicarTestString1 = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$'
$eicarTestString2 = '-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
$eicarFilePath = "C:\ProgramData\EICAR.txt"

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

# Create Fake Antivirus Popup Form
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

# Add Button to Trigger EICAR Test File Download
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,100)
$button.Size = New-Object System.Drawing.Size(120,30)
$button.Text = 'Download Malware'

$button.Add_Click({
    Log-Message "Button clicked: Attempting to create EICAR test file."

    # Check if the script is running with administrator privileges
    if (-not (Test-Admin)) {
        Log-Message "Script is not running as administrator." "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Admin privileges required!", "Error", "OK", "Error")
        return
    }

    # Create EICAR test file
    Create-FakeEicarFile
})

$form.Controls.Add($button)

# Log the action
Log-Message "Displaying simulated fake antivirus scan pop-up."

# Show the fake antivirus scan pop-up
$form.ShowDialog()
