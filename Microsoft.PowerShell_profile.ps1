<#
	.Synopsis
	The GUID function generates and displays a GUID.
	.Description
	The GUID function generates and displays a GUID. The value of the GUID is copied to the clipboard. There are no other parameters
#>
Function GUID {
	$guid = [guid]::NewGuid().ToString()
	echo $guid
	Set-Clipboard -Value $guid.Trim()
}
