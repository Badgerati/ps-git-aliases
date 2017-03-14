<#
.SYNOPSIS
Fetches changes from the remote
#>
Write-Host 'Fetching remote changes' -ForegroundColor Cyan
git fetch
if (!$?)
{
    throw 'Failed to fetch changes from remote'
}

Write-Host 'Fetching remote tags changes' -ForegroundColor Cyan
git fetch --tags
if (!$?)
{
    throw 'Failed to fetch tags from remote'
}