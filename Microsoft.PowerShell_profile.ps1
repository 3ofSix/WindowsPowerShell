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

<#
	.Synopsis
	Add or remove a path
	.Description
	Add or remove a path to the PATH variable
#>
Function Set-PathVariable {
    param (
        [string]$AddPath,
        [string]$RemovePath
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath'){
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath'){
        $regexPaths += [regex]::Escape($RemovePath)
    }
    
    $arrPath = $env:Path -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object {$_ -notMatch "^$path\\?"}
    }
    $env:Path = ($arrPath + $addPath) -join ';'
}

# Set PATH to include notepad++
Set-PathVariable -AddPath 'C:\Program Files\Notepad++\'

# Alias
Set-Alias -Name np -Value notepad++
