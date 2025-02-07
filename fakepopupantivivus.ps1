Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Anti-Virus Scan'
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(380,40)
$label.Text = 'Your PC has been scanned and no viruses were found.'
$form.Controls.Add($label)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,100)
$button.Size = New-Object System.Drawing.Size(75,23)
$button.Text = 'Download Malware'
$button.Add_Click({
    Invoke-WebRequest -Uri 'Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/TrevinoParker7/Powershell-test-payload-harmless/main/fakepopupantivivus.ps1' -OutFile 'C:\programdata\fakepopupantivivus.ps1'
})
$form.Controls.Add($button)

$form.ShowDialog()
