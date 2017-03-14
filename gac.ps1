<#
.SYNOPSIS
Add changes and commit them, with optional pushing to remote
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Message,

    [switch]
    $Push
)

# ensure there are changes to add/commit
gs -ThrowNotExists


Write-Host 'Adding local changes to branch' -ForegroundColor Cyan
git add --all .
if (!$?)
{
    throw 'Failed to add changes to local branch'
}

Write-Host 'Committing local changes' -ForegroundColor Cyan
git commit -m $Message
if (!$?)
{
    throw 'Failed to commit branch to remote'
}

if ($Push)
{
    gpush
}