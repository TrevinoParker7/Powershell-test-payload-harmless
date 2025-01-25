# Function to show a pop-up alert
function Show-PhishingPopUp {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "We have detected suspicious activity on your account. Click 'OK' to secure your account now.",
        "Security Alert",
        "OKCancel",
        "Warning"
    )
}

# Log the action
Log-Message "Displaying phishing simulation pop-up alert."

# Show the pop-up
Show-PhishingPopUp
