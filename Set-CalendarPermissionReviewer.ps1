function Set-CalendarPermissionReviewer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Username")][string]$Username,
        [ValidateNotNull()][System.Management.Automation.PSCredential][System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    Connect-O365 -Credential $Credential

    $Session = Get-PSSession | 
        Where-Object {$_.ComputerName -match 'outlook.office365.com'}

    Set-MailboxFolderPermission `
        -Identity $Username":\Calendar" `
        -User Default `
        -AccessRights Reviewer
}