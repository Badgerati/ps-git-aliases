<#
.SYNOPSIS
Return the current changes for the current branch
#>
param(
    [switch]
    $ThrowNotExists,

    [switch]
    $ThrowExists,

    [switch]
    $Count
)


function Write-Count
{
    # get current branch
    $branch = gbc

    # report the count
    if ($_count -eq 0)
    {
        Write-Host "There are no changes in $branch" -ForegroundColor Cyan
    }
    else
    {
        Write-Host "There has been $_count change(s) in $branch" -ForegroundColor Cyan
    }
}


# get changes count
$_count = (git status -s | Measure-Object).Count

# if count switch passed, just report the count of changes
if ($Count)
{
    Write-Count
    return
}

# check to see if there are changes, if there are none then throw error
if ($ThrowNotExists)
{
    if ($_count -eq 0)
    {
        throw 'No changes found that need to be added and committed'
    }
}

# check to see if there are no changes, if there are then throw error
elseif ($ThrowExists)
{
    if ($_count -ne 0)
    {
        throw 'There are changes waiting to be added and committed'
    }
}

# otherwise, just return a list of changes to add
else
{
    if ($_count -ne 0)
    {
        git status -s
    }

    Write-Count
}