# Define the simulated voicemail email
$voicemailEmailContent = @"
Subject: New Voicemail Message

Dear User,

You have a new voicemail message. Click the link below to listen to your message:

<a href='http://example-phishing-test.local/voicemail'>Listen to Voicemail</a>

Thank you,
Voicemail Service
"@

# Define the output file
$emailFilePath = "C:\ProgramData\VoicemailPhish.html"

# Log the action
Log-Message "Creating simulated voicemail phishing email."

try {
    # Write the email content to a file
    $voicemailEmailContent | Out-File -FilePath $emailFilePath -Force -Encoding UTF8
    Log-Message "Simulated voicemail phishing email created at $emailFilePath."
} catch {
    $errorMessage = "An error occurred while creating the voicemail phishing email: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# Optional: Open the email in a browser for testing
Start-Process "msedge.exe" -ArgumentList $emailFilePath
