<#
.SYNOPSIS
Push changes for current branch
#>
param(
    [switch]
    $Upstream
)

# ensure there are no changes
gs -ThrowExists

# push current branch to remote
Write-Host 'Pushing branch to remote' -ForegroundColor Cyan
$branch = gbc

if ($Upstream)
{
    git push -u origin $branch
}
else
{
    git push origin $branch
}

if (!$?)
{
    throw 'Failed to push branch to remote'
}