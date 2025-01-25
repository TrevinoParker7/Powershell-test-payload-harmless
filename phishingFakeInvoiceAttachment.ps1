# Define the fake invoice file path
$fakeInvoicePath = "C:\ProgramData\FakeInvoice.pdf"

# Start logging
Log-Message "Starting creation of fake invoice attachment."

try {
    # Generate a dummy PDF file to simulate a phishing invoice
    $pdfContent = @"
This is a simulated phishing test invoice.
Please review and process payment immediately.

Generated for educational purposes only.
"@
    $pdfBytes = [System.Text.Encoding]::UTF8.GetBytes($pdfContent)
    [System.IO.File]::WriteAllBytes($fakeInvoicePath, $pdfBytes)

    Log-Message "Fake invoice PDF created at $fakeInvoicePath."
} catch {
    $errorMessage = "An error occurred while creating the fake invoice: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# End logging
Log-Message "Fake invoice attachment creation completed."
