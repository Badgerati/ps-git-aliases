<#
.SYNOPSIS
Restores a branch back to a specified commit
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Branch,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Commit,

    [switch]
    $Push
)

# check there are no changes
gs -ThrowExists

# checkout to branch
gco $Branch -Pull

# create new temp branch
Write-Host 'Creating temp restoration branch' -ForegroundColor Cyan
gco "$($Branch)_temp" -New

# hard reset branch to commit
Write-Host 'Resetting branch to commit' -ForegroundColor Cyan
git reset --hard $Commit
if (!$?)
{
    throw 'Failed to hard reset to commit'
}

# delete old branch
Write-Host 'Deleting original branch' -ForegroundColor Cyan
git branch -D $Branch
if (!$?)
{
    throw 'Failed to delete original branch'
}

# re-creating original branch from temp one for restored commit
Write-Host 'Re-creating restored original branch' -ForegroundColor Cyan
gco $Branch -New
if (!$?)
{
    throw 'Failed to re-create restored original branch'
}

# delete temp branch
Write-Host 'Deleting temp branch' -ForegroundColor Cyan
git branch -D "$($Branch)_temp"
if (!$?)
{
    throw 'Failed to delete the temp branch'
}

# check if pushing, and delete from remote
if ($Push)
{
    # delete from remote
    Write-Host 'Deleting original branch in remote' -ForegroundColor Cyan
    git push origin --delete $Branch
    if (!$?)
    {
        throw 'Failed to delete the original branch in remote'
    }

    # push new restored branch
    gpush $Branch
}