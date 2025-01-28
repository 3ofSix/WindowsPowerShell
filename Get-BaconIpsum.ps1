<#
.SYNOPSIS
    Retrieves placeholder text from the Bacon Ipsum API and copies the result to the clipboard.

.DESCRIPTION
    The `Get-BaconIpsum` function makes a GET request to the Bacon Ipsum API to generate placeholder text. 
    The generated text is then copied to the clipboard for easy use in other applications. 
    This function is useful for generating sample text for testing or demonstration purposes.

.PARAMETER Paragraphs
    Specifies the number of paragraphs to generate. The default value is 1.

.PARAMETER Type
    Specifies the type of text to generate. Options are "all-meat" or "meat-and-filler". 
    The default value is "meat-and-filler".

.EXAMPLE
    Get-BaconIpsum -Paragraphs 3 -Type "all-meat"
    This example generates 3 paragraphs of all-meat text and copies the result to the clipboard.

.EXAMPLE
    Get-BaconIpsum -Paragraphs 2 -Type "meat-and-filler"
    This example generates 2 paragraphs of meat and filler text and copies the result to the clipboard.

.NOTES
    The function uses the `Invoke-RestMethod` cmdlet to make a GET request to the Bacon Ipsum API.
    The response is joined into a single string with double newlines between paragraphs.
    The resulting text is copied to the clipboard using the `Set-Clipboard` cmdlet.
#>
function global:Get-BaconIpsum {
    param (
        [int]$Paragraphs = 1,
        [string]$Type = "meat-and-filler"
    )

    $url = "https://baconipsum.com/api/?type=$Type&paras=$Paragraphs"
    $response = Invoke-RestMethod -Uri $url -Method Get
    $text = $response -join "`n`n"

    # Copy the result to the clipboard
    $text | Set-Clipboard

    return $text
}