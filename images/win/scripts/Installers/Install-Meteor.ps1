################################################################################
##  File:  Install-Meteor.ps1
##  Desc:  Install Meteor
################################################################################

Choco-Install -PackageName meteor

# Since PATH has changed, we'll reload so the current shell can use it.
RefreshEnv

# Prefetch the recent Meteor releases
meteor update --release 2.0
meteor update --release 1.21.12
meteor update --release 1.11
meteor update --release 1.10.3
meteor update --release 1.10.2
meteor update --release 1.10.1
meteor update --release 1.9.3
meteor update --release 1.9.2
meteor update --release 1.9.1
meteor update --release 1.9
meteor update --release 1.8.3
meteor update --release 1.8.2
meteor update --release 1.8.1
meteor update --release 1.8.0

# Copy the meteor data to `All Users\AppData`
robocopy "$env:LOCALAPPDATA\.meteor" "C:\Users\All Users\AppData\Local\.meteor" /MIR /SEC /XJD /R:5 /W:5 /MT:32 /V /NP

# Update the permissions on the copied files so all users can execute and modify them
# Since PowerShell assigns meaning to the `(` and `)`, escape with ` (backtick)
icacls "C:\Users\All Users\AppData\Local\.meteor" /grant ("Everyone"+":(OI)(CI)F") /t /c

# Add the new Meteor installation into the PATH for all users. 
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;C:\Users\All Users\AppData\Local\.meteor"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

# The path only takes effect after logging out and back in
