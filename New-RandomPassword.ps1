<#
.Synopsis
    Generates a random password and copies it to the clipboard.

.Description
    Changed Creates a random password using upper-case letters, lower-case letters,
    numbers, and special characters. The generated password is written to
    the console and copied to the clipboard for easy pasting.

.PARAMETER Count
    The length of the password to generate.
    Defaults to 16 characters.

.EXAMPLE
    New-RandomPassword

    Generates a 16-character password and copies it to the clipboard.

.EXAMPLE
    New-RandomPassword -Count 24

    Generates a 24-character password and copies it to the clipboard.
#>

function global:New-RandomPassword {
 
    param (
        [Parameter(Mandatory = $false)]
        [ValidateRange(1,128)]
        [int]$Count = 16
    )

    $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+'

    $password = -join (1..$Count | ForEach-Object {
        $characters[(Get-Random -Max $characters.Length)]
    })

    $password | Set-Clipboard
    $color = 'Green'
    Write-Host "`nPassword copied to clipboard:" 
    Write-Host "$password`n" -ForegroundColor $color
}