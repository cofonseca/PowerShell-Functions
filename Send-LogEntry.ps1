<#
.SYNOPSIS
    Sends a message to LogEntries
.DESCRIPTION
    Sends a message to LogEntries via TCP using the provided token.
.PARAMETER Message
    The message to be sent.
.PARAMETER Token
    The LogEntries token for the desired desination log.
.EXAMPLE
    Send-LogEntry -Message "Error" -Token 643fb425-560b-43bf-a2f3-c78c7b5d4175
    Sends an entry with a body of "Error" to the log associated with the specified token.
#>
function Send-LogEntry {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,Position=0)][string]$Message,
        [Parameter(Mandatory=$true,Position=1)][string]$Token
    )

    $Address = 'data.logentries.com'
    $Port = 514

    $TCP = New-Object System.Net.Sockets.TCPClient($Address, $Port)
    $Stream = $TCP.GetStream()

    $Writer = New-Object System.IO.StreamWriter($Stream)
    $Writer.WriteLine("$token $Message")

    $Writer.Close()
    $Stream.Close()
    if ($TCP) {
        $TCP.Close()
    }

}