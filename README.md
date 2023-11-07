# PowerShell profile
Power shell profile for useful functions

## Generate a profile
PowerShell can load a profile file from several locations. For a per user profile exceute the following

`New-Item $profile -Type File -Force`

This will create a folder `WindowsPowerShell` containing a file `Microsoft.PowerShell_profile.ps1`

Edit with notepad

`notepad $profile`
