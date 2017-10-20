<#
.SYNOPSIS
Modifies an AD User's Primary Group

.DESCRIPTION
Modifies an AD User's Primary Group

.PARAMETER Username
The username of the user.

.PARAMETER PrimaryGroupName
The name of the new Primary Group.

.EXAMPLE
Set-ADUserPrimaryGroup -Username 'jsmith' -PrimaryGroupName 'External Clients'
Changes jsmith's primary group to 'External Clients'

.NOTES
A user's primary group is set to 'Domain Users' by default, but you cannot
remove them from 'Domain Users' without first changing their primary group.
This function solves the problem of changing the primary group.
#>
function Set-ADUserPrimaryGroup {
    [CmdletBinding()]param(
        [Parameter(Mandatory=$true)][String]$Username,
        [Parameter(Mandatory=$true)][String]$PrimaryGroupName
    )

    Import-Module ActiveDirectory
    Write-Verbose "Getting the token for $PrimaryGroupName"
    $Token = `
        Get-ADGroup $PrimaryGroupName -Properties PrimaryGroupToken |
        Select-Object -ExpandProperty PrimaryGroupToken

    Write-Verbose "Setting $Username's primary group token to $Token"
    Set-ADUser `
        -Identity $Username `
        -Replace @{PrimaryGroupID="$Token"} `
        -Server 'BOSDC01'
}