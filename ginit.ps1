<#
.SYNOPSIS
Initialises a git repo on your local machine
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteUrl
)

Write-Host 'Initialising new local git repo' -ForegroundColor Cyan
git init
if (!$?)
{
    throw 'Failed to initialise new local git repo'
}

gac "Initial commit"

Write-Host 'Setting up remote origin link' -ForegroundColor Cyan
git remote add origin $RemoteUrl
if (!$?)
{
    throw 'Failed to setup remote origin for branch'
}

gpush -Upstream