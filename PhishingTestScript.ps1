# Define the log file path
$logFile = "C:\ProgramData\phishing_test.log"
$scriptName = "phishing_test.ps1"

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

# Define the simulated phishing email content
$phishingEmail = @"
Dear User,

We have detected suspicious activity in your account. To ensure your account security, please verify your details by clicking the link below:

<a href='http://example-phishing-test.local'>Verify Your Account</a>

If you do not verify within 24 hours, your account may be locked.

Sincerely,
Security Team
"@

# Define the output file where the phishing email will be saved
$emailFilePath = "C:\ProgramData\PhishingTestEmail.html"

# Start logging
Log-Message "Starting simulated phishing email creation."

try {
    # Check if the file already exists, and if it does, delete it first
    if (Test-Path -Path $emailFilePath) {
        Remove-Item -Path $emailFilePath -Force
        Log-Message "Existing phishing test email file found and deleted."
    }

    # Create the phishing test email
    $phishingEmail | Out-File -FilePath $emailFilePath -Force -Encoding UTF8
    Log-Message "Simulated phishing email created at $emailFilePath."

    # Optional: Open the email in the default browser for testing purposes
    Start-Process "msedge.exe" -ArgumentList $emailFilePath

} catch {
    $errorMessage = "An error occurred while creating the simulated phishing email: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# End logging
Log-Message "Simulated phishing email creation completed."
