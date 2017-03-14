<#
.SYNOPSIS
Creates a branch from a tag
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Branch,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Tag,

    [switch]
    $Push
)

# run a fetch to update tags
gfetch

# ensure the tag exists
$tagExists = (git tag | Where-Object { $_ -ilike "$Tag" } | Measure-Object).Count
if ($tagExists -eq 0)
{
    throw "No tag for $Tag found, cannot create branch"
}

# create new branch
Write-Host 'Creating branch from tag' -ForegroundColor Cyan
git branch $Branch $Tag
if (!$?)
{
    throw 'Failed to create branch from tag'
}

# checkout to the branch
Write-Host 'Checking out to new branch' -ForegroundColor Cyan
gco $Branch

# push to remote
if ($Push)
{
    gpush
}