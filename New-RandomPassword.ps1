<#
.SYNOPSIS
Generates a random password.

.DESCRIPTION
Generates a random password, including a text string, numbers, and special 
characters, as either a plaintext string, or a secure string. You must specify
an output type.

.PARAMETER AsString
Outputs a random password in plaintext.

.PARAMETER AsSecureString
Outputs a random password as a secure string.

.EXAMPLE
New-RandomPassword -AsString
Generates a random password, and outputs it in plaintext.

.EXAMPLE
New-RandomPassword -AsSecureString
Generates a random password, and outputs it as a SecureString.
#>
function New-RandomPassword {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName='String')][Switch]$AsString,
        [Parameter(ParameterSetName='Secure')][Switch]$AsSecureString
    )

    PROCESS {

        $Response = Invoke-RestMethod `
            -Method 'GET' `
            -Uri 'http://www.dinopass.com/password/simple'

        $SpecialCharacters = @('~','!','@','#','$','%','^','&','*','_','-','+','=','(',')','{','}',':',';','<','>',',','.','?','/')

        $RandomNums = Get-Random `
            -Minimum 1 `
            -Maximum 999

        $RandomChars = Get-Random `
            -InputObject $SpecialCharacters `
            -Count 2

        $Password = $Response + $RandomNums + $RandomChars[0] + $RandomChars[1]

    }

    END {

        if ($AsSecureString) {
            $Password = ConvertTo-SecureString $Password -AsPlainText -Force
        }
        
        Write-Output $Password

    }

}   