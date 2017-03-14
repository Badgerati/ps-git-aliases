<#
.SYNOPSIS
Return the current changes for the current branch
#>
param(
    [switch]
    $ThrowNotExists,

    [switch]
    $ThrowExists
)

# get changes count
$count = (git status -s | Measure-Object).Count

# check to see if there are changes, if there are none then throw error
if ($ThrowNotExists)
{
    if ($count -eq 0)
    {
        throw 'No changes found that need to be added and committed'
    }
}

# check to see if there are no changes, if there are then throw error
elseif ($ThrowExists)
{
    if ($count -ne 0)
    {
        throw 'There are changes waiting to be added and committed'
    }
}

# otherwise, just return a list of changes to add
else
{
    if ($count -eq 0)
    {
        Write-Host 'There are no changes' -ForegroundColor Cyan
    }
    else
    {
        git status -s
        Write-Host "There have been $count changes" -ForegroundColor Cyan
    }
}