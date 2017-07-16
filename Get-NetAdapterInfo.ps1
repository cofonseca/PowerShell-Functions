<#
.SYNOPSIS
	Returns common information about all network interfaces.
.DESCRIPTION
	Returns common information, such as the name, IP Address, MAC Address, 
    Status, and Link Speed, of all network adapters on the machine that contain
    an IP Address.
.PARAMETER ComputerName
	The name of a remote computer to check.
.NOTES
	Version:        1.0
	Author:         Corey Fonseca
	Creation Date:  5/3/17
.EXAMPLE
	Get-NetAdapterInfo
    Returns network adapter information of the local machine.
.EXAMPLE
    Get-NetAdapterInfo -ComputerName COMPUTER01
    Returns network adapter information of COMPUTER01

#>
function Get-NetAdapterInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True,Position=0)][string]$ComputerName
    )

    PROCESS{

        if ($ComputerName) {
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                $IPAddresses = Get-NetIPAddress | 
                Where-Object {$_.IPAddress -and $_.IPAddress -notmatch '127.0.0.1' -and $_.IPAddress -notmatch ':' -and $_.IPAddress -notmatch '169.254' -and $_.InterfaceAlias -notmatch 'Bluetooth' -and $_.InterfaceAlias -notmatch 'Tunnel' -and $_.InterfaceAlias -notmatch 'isatap'}

                [PSObject[]]$OutputObject = New-Object -TypeName psobject

                foreach ($IPAddress in $IPAddresses) {
                    $MacAddress = Get-NetAdapter -InterfaceAlias $IPAddress.InterfaceAlias
                    $AdapterObject = New-Object -TypeName PSObject
                    $AdapterObject | Add-Member -MemberType NoteProperty -Name 'InterfaceAlias' -Value $IPAddress.InterfaceAlias
                    $AdapterObject | Add-Member -MemberType NoteProperty -Name 'IPAddress' -Value $IPAddress.IPAddress
                    $AdapterObject | Add-Member -MemberType NoteProperty -Name 'MacAddress' -Value $MacAddress.MacAddress
                    $AdapterObject | Add-Member -MemberType NoteProperty -Name 'Status' -Value $MacAddress.Status
                    $AdapterObject | Add-Member -MemberType NoteProperty -Name 'LinkSpeed' -Value $MacAddress.LinkSpeed
                    $OutputObject += $AdapterObject
                }
                return $OutputObject
            }
        } else {

            $IPAddresses = Get-NetIPAddress | 
            Where-Object {$_.IPAddress -and $_.IPAddress -notmatch '127.0.0.1' -and $_.IPAddress -notmatch ':' -and $_.IPAddress -notmatch '169.254' -and $_.InterfaceAlias -notmatch 'Bluetooth' -and $_.InterfaceAlias -notmatch 'Tunnel' -and $_.InterfaceAlias -notmatch 'isatap'}

            [PSObject[]]$OutputObject = New-Object -TypeName psobject

            foreach ($IPAddress in $IPAddresses) {
                $MacAddress = Get-NetAdapter -InterfaceAlias $IPAddress.InterfaceAlias
                $AdapterObject = New-Object -TypeName PSObject
                $AdapterObject | Add-Member -MemberType NoteProperty -Name 'InterfaceAlias' -Value $IPAddress.InterfaceAlias
                $AdapterObject | Add-Member -MemberType NoteProperty -Name 'IPAddress' -Value $IPAddress.IPAddress
                $AdapterObject | Add-Member -MemberType NoteProperty -Name 'MacAddress' -Value $MacAddress.MacAddress
                $AdapterObject | Add-Member -MemberType NoteProperty -Name 'Status' -Value $MacAddress.Status
                $AdapterObject | Add-Member -MemberType NoteProperty -Name 'LinkSpeed' -Value $MacAddress.LinkSpeed
                $OutputObject += $AdapterObject
            }
        }
        Write-Output $OutputObject
    }
}