#requires -version 5
<#
.SYNOPSIS
  Capitalized the first letter of a word, and removes any characters or whitespace.
.DESCRIPTION
  This function will properly format a word by capitalizing the first letter,
  reducing all other letters to lowercase, and removing any whitespace or
  special characters within the word.
.PARAMETER Word
  The word to be formatted.
.NOTES
  Version:        1.0
  Author:         Corey Fonseca
  Creation Date:  3/16/17
  Purpose/Change: Initial script development
.EXAMPLE
  Format-Word -Word 'cat'
  Formats 'cat' into 'Cat'
.EXAMPLE
  Format-Word 'tree'
  Formats 'tree' into 'Tree'
.EXAMPLE
  Format-Word 'jo$ hn'
  Formats 'jo$ hn' into 'John'
#>
function Format-Word {
    [CmdletBinding()]Param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)][string]$Word
    )

    PROCESS {

        $RegEx = '[^a-zA-Z]'
        $Word = $Word -Replace $RegEx, ''
        $Word = $Word.Substring(0,1).toupper()+$Word.Substring(1).tolower()
        
    }

    END {

        Write-Output $Word

    }

}