<#
.SYNOPSIS
Checkout to branch and update it, or create new branch from current
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Branch,

    [switch]
    $Pull,

    [switch]
    $New
)

# check there are no changes to add/commit
gs -ThrowExists

# check if creating new branch, or just moving to another one
if ($New)
{
    Write-Host 'Creating new branch' -ForegroundColor Cyan
    git checkout -b $Branch
}
else
{
    # fetch new data from remote
    gfetch

    # checkout to other branch
    Write-Host 'Checking out to branch' -ForegroundColor Cyan
    git checkout $Branch
    if (!$?)
    {
        throw 'Failed to checkout'
    }

    # pull down new data from remote, if enabled
    if ($Pull)
    {
        gpull
    }
}

Write-Host "Current branch: $(gbc)" -ForegroundColor Cyan