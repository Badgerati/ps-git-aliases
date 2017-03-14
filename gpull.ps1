<#
.SYNOPSIS
Pull changes for current branch
#>
param(
    [switch]
    $Fetch
)

# check there are no changes
gs -ThrowExists

# pull new branch data from remote
Write-Host 'Pulling down remote changes' -ForegroundColor Cyan
$branch = gbc
git pull origin $branch
if (!$?)
{
    throw 'Failed to pull changes from remote'
}

if ($Fetch)
{
    gfetch
}