<#
.SYNOPSIS
	Modifies a user's calendar to allow Review access to other users.
.DESCRIPTION
	Modifies a user's calendar permissions to grant Reviewer rights to the 
    Default account, allowing all users on the domain the ability to view
    the calendar owner's calendar events. 
.PARAMETER Username
	The username of the user whose calendar will be modified.
.PARAMETER Credential
    A variable containing valid O365 administrator credentials.
.NOTES
	Version:        1.0
	Author:         Corey Fonseca
	Creation Date:  5/10/17
.EXAMPLE
	Set-CalendarPermissionReviewer -Username jsmith -Credential $Credential
    Sets the calendar permissions for the user 'jsmith'
#>
function Set-CalendarPermissionReviewer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Username")][string]$Username,
        [Parameter(Mandatory=$true)][ValidateNotNull()][System.Management.Automation.PSCredential][System.Management.Automation.Credential()]$Credential
    )

    PROCESS {

        # Get the O365 Session & Store in Variable
        $Session = Get-PSSession | 
            Where-Object {$_.ComputerName -match 'outlook.office365.com' -and $_.State -match 'Opened'}

        if (-not ($Session)) {
            Connect-O365 -Credential $Credential
        }

        # Set Permissions
        Set-MailboxFolderPermission `
            -Identity $Username":\Calendar" `
            -User Default `
            -AccessRights Reviewer

        # Validate Permissions
        $Result = (Get-MailboxFolderPermission -Identity $Username":\Calendar" | Where-Object {$_.User -match 'Default' -and $_.AccessRights -match 'Reviewer'})
        
        if ($Result) {
            Write-Output $Result
        } else {
            Write-Error "Failed to update and/or validate calendar permissions."
        }
    }
}