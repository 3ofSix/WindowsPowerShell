<#
.SYNOPSIS
Retrieves resolved Azure DevOps work items and copies them to the clipboard.

.DESCRIPTION
Queries Azure DevOps for User Stories, Bugs and Tickets that:
- Are under the specified Area Path
- Have a State of Resolved
- Have a Resolved Date on or after the specified date

Results are copied to the clipboard in the format:

US12345: User story title
TK12346: Ticket title
BUG 12346: Bug title

.PARAMETER AreaPath
Area path to search beneath.

.PARAMETER ResolvedSince
Resolved date (inclusive) in yyyy-MM-dd format.

.EXAMPLE
.\Get-ResolvedWorkItems.ps1 `
    -AreaPath 'DSD\ARTEMIS\WAMS' `
    -ResolvedSince '2026-10-05'

.EXAMPLE
.\Get-ResolvedWorkItems.ps1 `
    -AreaPath 'DSD\ARTEMIS' `
    -ResolvedSince '2026-01-01'

.NOTES
Uses the current Windows credentials to authenticate with Azure DevOps.
#>

Function global:Get-ResolvedWorkItems {
	[CmdletBinding()]
	param(
		[Parameter(
			Mandatory,
			HelpMessage = "Azure DevOps Area Path, e.g. DSD\ARTEMIS\WAMS")]
		[string]$AreaPath,

		[Parameter(
			Mandatory,
			HelpMessage = "Resolved date (inclusive) in yyyy-MM-dd format, e.g. 2026-10-01")]
		[ValidatePattern('^\d{4}-\d{2}-\d{2}$')]
		[string]$ResolvedSince
	)

	# Azure DevOps project URL
	$BaseUrl = 'https://pr-dae-tfsapp1/tfs/DARD%20ISB/DSD'

	# Build WIQL query
	$wiql = @"
	SELECT
		[System.Id]
	FROM WorkItems
	WHERE
		[System.WorkItemType] IN ('User Story', 'Bug', 'Ticket')
		AND [System.AreaPath] UNDER '$AreaPath'
		AND [System.State] = 'Resolved'
		AND [Microsoft.VSTS.Common.ResolvedDate] >= '$ResolvedSince'
	ORDER BY
		[Microsoft.VSTS.Common.ResolvedDate] DESC
"@

	$body = @{
		query = $wiql
	} | ConvertTo-Json

	Write-Host "Executing query..."

	$result = Invoke-RestMethod `
		-Uri "$BaseUrl/_apis/wit/wiql?api-version=7.1" `
		-Method POST `
		-UseDefaultCredentials `
		-ContentType "application/json" `
		-Body $body

	if (-not $result.workItems) {
		Write-Warning "No matching work items found."
		return
	}

	$ids = $result.workItems.id -join ','

	$details = Invoke-RestMethod `
		-Uri "$BaseUrl/_apis/wit/workitems?ids=$ids&api-version=7.1" `
		-UseDefaultCredentials `
		-Method GET

	$output = $details.value | ForEach-Object {

		$prefix = switch ($_.fields.'System.WorkItemType') {
			'User Story' { 'US' }
			'Ticket'     { 'TK' }
			'Bug'        { 'BUG ' }
			default      { 'WI' }
		}

		"$prefix$($_.id): $($_.fields.'System.Title')"
	}

	$output | Set-Clipboard

	Write-Host ""
	Write-Host "Copied $($output.Count) work items to clipboard."
	Write-Host ""

	return $output
}