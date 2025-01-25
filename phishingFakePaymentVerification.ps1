# Define the fake payment verification link
$verificationLink = "http://example-phishing-test.local/verify-payment"

# Simulate a payment verification email
$paymentVerificationEmail = @"
Subject: Action Required - Payment Verification Needed

Dear User,

We detected a payment of $500.00 from your account. If you made this payment, no action is required.

If you did not authorize this transaction, click the link below to verify and secure your account:

<a href='$verificationLink'>Verify Payment</a>

Thank you,
Billing Department
"@

# Define the output file
$emailFilePath = "C:\ProgramData\PaymentVerificationPhish.html"

# Log the action
Log-Message "Creating simulated payment verification phishing email."

try {
    # Write the email content to a file
    $paymentVerificationEmail | Out-File -FilePath $emailFilePath -Force -Encoding UTF8
    Log-Message "Simulated payment verification email created at $emailFilePath."
} catch {
    $errorMessage = "An error occurred while creating the payment verification email: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# Optional: Open the email in a browser for testing
Start-Process "msedge.exe" -ArgumentList $emailFilePath
