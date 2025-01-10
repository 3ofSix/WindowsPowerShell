<#
	.NOTES
	  Version:        1.01
	  Author:         Garrett Vernon
	  Last change Date:  2024-12-11
 #>
 
 function GetVersionInfo {
  $notes = $null
  $notes = @{}

  # Get the .NOTES section of the script header comment.
  $notesText = (Get-Help -Full $PSCommandPath).alertSet.alert.Text

  # Split the .NOTES section by lines.
  $lines = ($notesText -split '\r?\n').Trim()

  # Iterate through every line.
  foreach ($line in $lines) {
      if (!$line) {
          continue
      }

      $name  = $null
      $value = $null

      # Split line by the first colon (:) character.
      if ($line.Contains(':')) {
          $nameValue = $null
          $nameValue = @()

          $nameValue = ($line -split ':',2).Trim()

          $name = $nameValue[0]

          if ($name) {
              $value = $nameValue[1]

              if ($value) {
                  $value = $value.Trim()
              }

              if (!($notes.ContainsKey($name))) {
                  $notes.Add($name, $value)
              }
          }
      }
  }

  return $notes
}

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
Function GUID {
	
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

function Get-MrParameterCount {
    param (
        [string[]]$ParameterName
    )

    foreach ($Parameter in $ParameterName) {
        $Results = Get-Command -ParameterName $Parameter -ErrorAction SilentlyContinue

        [pscustomobject]@{
            ParameterName = $Parameter
            NumberOfCmdlets = $Results.Count
        }
    }
}

# Set PATH to include notepad++
Set-PathVariable -AddPath 'C:\Program Files\Notepad++\'

# Alias
Set-Alias -Name np -Value notepad++
