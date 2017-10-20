function Save-WebVideo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)][String]$BaseURL,
        [Parameter(Mandatory=$true, Position=1)][String]$Destination
    )

    $Links = (Invoke-WebRequest $BaseURL).Links |
        Where-Object {$_.InnerHTML -match '.mp4'} |
        Select-Object -ExpandProperty InnerHTML
    
    Write-Verbose "BASE URL: $BaseURL"
    
    $Links | % {Write-Verbose "LINK: $_"}
    
    #$WebClient = New-Object System.Net.WebClient
    
    foreach ($Link in $Links) {
        if (!(Test-Path "$Destination\$Link")) {
            #$WebClient.DownloadFile("$BaseURL$Link", "$Destination\$Link")
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest $BaseURL$Link -OutFile "$Destination\$Link"
            Write-Verbose "Downloading $BaseURL$Link..."
        } else {
            Write-Verbose "$BaseURL$Link has already been download. Skipping..."
        }
    }
    
}