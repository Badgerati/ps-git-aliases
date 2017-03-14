<#
.SYNOPSIS
Creates a tag of a branch
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

# ensure we have no changes
gs -ThrowExists

# fetch new changes
gfetch

# ensure tag doesn't already exist
$tagExists = (git tag | Where-Object { $_ -ilike "$Tag" } | Measure-Object).Count
if ($tagExists -ne 0)
{
    throw "$Tag already exists as a tag"
}

# checkout to branch
gco $Branch -Pull

# create tag
Write-Host 'Creating tag of branch' -ForegroundColor Cyan
git tag -a $Tag $Branch -m "Tagging $Branch branch"
if (!$?)
{
    throw "Failed to create $Tag tag"
}

# ensure tag now exists
$tagExists = (git tag | Where-Object { $_ -ilike "$Tag" } | Measure-Object).Count
if ($tagExists -eq 0)
{
    throw "$Tag doesn't exist after attempted creation"
}

# push the tag to remote
if ($Push)
{
    Write-Host 'Pushing tag to the remote' -ForegroundColor Cyan
    git push origin $Tag
    if (!$?)
    {
        throw 'Failed to push tag to remote'
    }
}