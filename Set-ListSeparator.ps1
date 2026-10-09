<#
    .Synopsis
    Sets the Windows regional list separator.

    .Description
    Updates the current user's Windows regional list separator
    (HKCU:\Control Panel\International\sList).

    By default, the separator is set to a semicolon (;).

    Some applications may require a restart, sign out, or
    sign in before the change is fully recognised.

    .PARAMETER Separator
    Specifies the list separator to use.

    Default value is ';'.

    .EXAMPLE
    PS> Set-ListSeparator

    Current list separator: ;

    .EXAMPLE
    PS> Set-ListSeparator -Separator ,

    Current list separator: ,

#>
Function global:Set-ListSeparator {

    [CmdletBinding()]
    param (
        [char]$Separator = ';'
    )

    $Path = 'HKCU:\Control Panel\International'

    try {
		$PreviousValue = (Get-ItemProperty -Path $Path -Name 'sList').sList
		
        Set-ItemProperty -Path $Path -Name 'sList' -Value $Separator -ErrorAction Stop

        $CurrentValue = (Get-ItemProperty -Path $Path -Name 'sList').sList

        Write-Host "`nList Separator updated from:  " -NoNewline -ForegroundColor Green
		Write-Host $PreviousValue -ForegroundColor Yellow
		Write-Host "----------------------" -ForegroundColor Green
        Write-Host "Current list separator: " -NoNewline -ForegroundColor Green
        Write-Host $CurrentValue -ForegroundColor Yellow
        Write-Host ''
    }
    catch {
        Write-Error "Failed to set list separator. $($_.Exception.Message)"
    }
}
