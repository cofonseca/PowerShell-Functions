<#
.SYNOPSIS
	Returns the .NET Framework version.
.DESCRIPTION
	Returns the version of .NET Framework on a local or remote machine.
.PARAMETER ComputerName
	The name of a remote computer.
.NOTES
	Version:        1.0
	Author:         Corey Fonseca
	Creation Date:  5/22/17
.EXAMPLE
	Get-DotNetVersion
    Returns the .NET Framework version on the local computer.
.EXAMPLE
    Get-DotNetVersion -ComputerName Computer01
    Returns the .NET Framework version on Computer01.

#>
function Get-DotNetVersion {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$True)][string]$ComputerName
    )

    BEGIN {

        if($ComputerName) {

            $NetVersion = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full\').Release
            }

        } else {

            $NetVersion = (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full').Release

        }

    }

    PROCESS {

        switch ($NetVersion) {

            378389 {Write-Output ".NET Framework 4.5"}
            378675 {Write-Output ".NET Framework 4.5.1"}
            378758 {Write-Output ".NET Framework 4.5.1"}
            379893 {Write-Output ".NET Framework 4.5.2"}
            393295 {Write-Output ".NET Framework 4.6"}
            393297 {Write-Output ".NET Framework 4.6"}
            394254 {Write-Output ".NET Framework 4.6.1"}
            394271 {Write-Output ".NET Framework 4.6.1"}
            394802 {Write-Output ".NET Framework 4.6.2"}
            394806 {Write-Output ".NET Framework 4.6.2"}
            460798 {Write-Output ".NET Framework 4.7"}
            460805 {Write-Output ".NET Framework 4.7"}
            default {Write-Output "Unknown .NET Framework Version: $NetVersion"}

        }

    }

}