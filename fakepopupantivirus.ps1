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

# Logging Setup
$logFile = "C:\ProgramData\entropygorilla.log"
$scriptName = "fakepopupantivirus.ps1"

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

# Add Button to Trigger EICAR Test File Download
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,100)
$button.Size = New-Object System.Drawing.Size(120,30)
$button.Text = 'Download Malware'

$button.Add_Click({
    Log-Message "Button clicked: Attempting to create EICAR test file."

    # Ensure Admin Privileges
    if (-not (Test-Admin)) {
        Log-Message "Script is not running as administrator." "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Admin privileges required!", "Error", "OK", "Error")
        return
    }

    # Base64-encoded EICAR string (evades immediate detection)
    $eicarBase64 = "WDVPLVBALUFAWzRcUFpYNTQoXildQ0MpN31IKg=="
    $eicarFilePath = "C:\ProgramData\EICAR.txt"

    try {
        # Check if the file already exists
        if (Test-Path -Path $eicarFilePath) {
            Remove-Item -Path $eicarFilePath -Force
            Log-Message "Existing EICAR file found and deleted."
        }

        # Decode and write EICAR file
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($eicarBase64)) | Out-File -FilePath $eicarFilePath -Force
        Log-Message "EICAR test file created at $eicarFilePath."
        [System.Windows.Forms.MessageBox]::Show("EICAR test file successfully created!", "Success", "OK", "Information")

    } catch {
        $errorMessage = "Error while creating EICAR file: $_"
        Log-Message $errorMessage "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Failed to create EICAR file.", "Error", "OK", "Error")
    }
})

$form.Controls.Add($button)
$form.ShowDialog()
