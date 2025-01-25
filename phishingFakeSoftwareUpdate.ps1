# Function to show a fake software update alert
function Show-FakeUpdatePopUp {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "A critical software update is required for your system. Click 'OK' to download and install the update now.",
        "Software Update",
        "OKCancel",
        "Warning"
    )
}

# Log the action
Log-Message "Displaying simulated fake software update pop-up."

# Show the fake update pop-up
Show-FakeUpdatePopUp
