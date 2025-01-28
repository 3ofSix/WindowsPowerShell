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

<#
.SYNOPSIS
    Imports a list of script files from the same directory as the PowerShell profile.

.DESCRIPTION
    The `Import-ScriptsFromProfileDirectory` function loads and imports a list of specified script files 
    from the directory where the PowerShell profile is located. This is useful for organizing and 
    managing multiple script files that you want to be available in every PowerShell session.

.PARAMETER ScriptFiles
    Specifies an array of script file names to be imported from the profile directory.

.EXAMPLE
    Import-ScriptsFromProfileDirectory -ScriptFiles @("Get-BaconIpsum.ps1", "AnotherScript.ps1")
    This example imports the `Get-BaconIpsum.ps1` and `AnotherScript.ps1` files from the profile directory.

.NOTES
    The function uses the `Split-Path` cmdlet to determine the profile directory and the `Join-Path` cmdlet 
    to construct the full path to each script file. It then checks if each script file exists using the 
    `Test-Path` cmdlet and imports it if found.
#>
function Import-ScriptsFromProfileDirectory {
    param (
        [string[]]$ScriptFiles
    )

    $profileDirectory = Split-Path -Path $PROFILE -Parent

    foreach ($scriptFile in $ScriptFiles) {
        $scriptPath = Join-Path -Path $profileDirectory -ChildPath $scriptFile
        if (Test-Path $scriptPath) {
            try {
                . $scriptPath -Scope Global
                Write-Host "Imported script: $scriptFile"
            } catch {
                Write-Warning "Failed to import script: $scriptFile"
            }
        } else {
            Write-Warning "Script file '$scriptFile' not found in profile directory."
        }
    }
}

# Import scripts
Import-ScriptsFromProfileDirectory -ScriptFiles @("Get-BaconIpsum.ps1", "Get-GUID.ps1")

# Set PATH to include notepad++
Set-PathVariable -AddPath 'C:\Program Files\Notepad++\'

# Aliases
Set-Alias -Name np -Value notepad++
Set-Alias -Name guid -Value Get-GUID
Set-Alias -Name Get-Bacon -Value Get-BaconIpsum
Write-Host "Aliases: np, guid, Get-Bacon"