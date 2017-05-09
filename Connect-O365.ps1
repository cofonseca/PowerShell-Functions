#requires -version 5

<#
.SYNOPSIS
	Connects to the O365 PowerShell endpoint using administrator credentials.
.DESCRIPTION
	Connects to the remote O365 endpoint for Exchange PowerShell using valid 
    administrator credentials. A credential object can be passed in in the form
    of a variable, or an e-mail address can be specified, prompting the user
    for the password.
.PARAMETER Credential
	A valid administrator credential.
.NOTES
	Version:        1.0
	Author:         Corey Fonseca
	Creation Date:  5/3/17
.EXAMPLE
	Connect-O365 -Credential admin@example.com
    Connects to O365 using admin@example.com, and prompts the user for the password.
.EXAMPLE
    Connect-O365 -Credential $Credential
    Connects to O365 using the passed-in credential object in the form of a variable.

#>
function Connect-O365 {
    [CmdletBinding()]
    param(
        [ValidateNotNull()][System.Management.Automation.PSCredential][System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    PROCESS {

        $O365Session = New-PSSession `
            -ConfigurationName Microsoft.Exchange `
            -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
            -Credential $Credential `
            -Authentication Basic `
            -AllowRedirection

        Import-Module (Import-PSSession -Session $O365Session -AllowClobber -DisableNameChecking) -Global -WarningAction SilentlyContinue

        Write-Output (Get-PSSession | Where {$_.ComputerName -match 'outlook.office365.com'}) 
    }
}