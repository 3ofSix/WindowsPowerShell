
<#
	.Synopsis
	The GUID function generates and displays a GUID.
	
	.Description
	The GUID function generates and displays a GUID. The value of the GUID is copied to the clipboard. Use the param -Count to get a list of GUIDs. 
	The first is copied to the clipboard
	
	.PARAMETER Count
	Specifies the number of GUIDs to be produced
	
	.EXAMPLE
	PS> guid
	GUID copied to clipboard: 5ba076d0-1d26-42fe-909d-d7c38ab1b0e8

	GUID
	----
	5ba076d0-1d26-42fe-909d-d7c38ab1b0e8
	
	.EXAMPLE
	PS> guid -Count 3

	GUID copied to clipboard: e4d1ba0e-707f-475a-af32-5470e68da332

	GUID
	----
	193665f7-e90a-47fa-b27c-e8308e917b69
	d01ff24a-6456-40a6-b30d-aa1785143c51
	e4d1ba0e-707f-475a-af32-5470e68da332
#>
Function global:Get-GUID {
	
	param ([int]$Count = 1)
	
	$guids = @()
    for ($i = 0; $i -lt $Count; $i++) {
        $guids += [guid]::NewGuid().ToString()
    }
	
	$script:color = 'Green'
	Write-Host "`nGUID`n----" -ForegroundColor $script:color
	$guids | ForEach-Object {
		$script:color = if ($script:color -eq 'Green') { 'Yellow' } else { 'Green' }
		Write-Host $_ -ForegroundColor $script:color
    }

    Write-Host "`nFirst GUID copied to clipboard:" -ForegroundColor Green
	Write-Host "$($guids[0])`n" -ForegroundColor Yellow
    Set-Clipboard -Value $guids[0].Trim()
}