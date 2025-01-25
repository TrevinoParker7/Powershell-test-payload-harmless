# Define the simulated payment email content
$paymentEmail = @"
Dear Valued Customer,

Thank you for your payment of $1,250.00. 

Your receipt number is: #12345ABC
If you did not authorize this transaction, please click the link below to dispute the charge:

<a href='http://example-phishing-test.local/dispute'>Dispute This Charge</a>

Thank you,
Billing Team
"@

# Define the output file
$emailFilePath = "C:\ProgramData\FakePaymentEmail.html"

# Log the action
Log-Message "Creating simulated payment confirmation email."

try {
    # Write the email content to a file
    $paymentEmail | Out-File -FilePath $emailFilePath -Force -Encoding UTF8
    Log-Message "Simulated payment confirmation email created at $emailFilePath."
} catch {
    $errorMessage = "An error occurred while creating the simulated payment email: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# Optional: Open the email in a browser for testing
Start-Process "msedge.exe" -ArgumentList $emailFilePath
