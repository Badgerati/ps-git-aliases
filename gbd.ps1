<#
.SYNOPSIS
Deletes local branches that conform to some regular expression
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Regex,

    [string]
    $DefaultBranch = 'master',

    [switch]
    $Force
)

# check there are no changes to add/commit
gs -ThrowExists

# if the regex matches develop or master, return
if ('master' -imatch $Regex -or 'develop' -imatch $Regex)
{
    Write-Host 'Cannot delete develop or master branch for safety. Use manual deletion' -ForegroundColor Red
    return
}

# if regex matches the default branch, return
if ($DefaultBranch -imatch $Regex)
{
    Write-Host 'The default branch cannot be a branch that will be deleted by the regex' -ForegroundColor Red
    return
}

# get list of branches for regex
$branches = git branch | ForEach-Object { $_.Trim() } | Where-Object { $_ -imatch $Regex }
$count = ($branches | Measure-Object).Count

# if no branch, return
if ($count -eq 0)
{
    Write-Host "No branches found that match: $Regex" -ForegroundColor Cyan
    return
}

# unless forcing, ask if they really want this
if (!$Force)
{
    Write-Host 'The following branches are about to be deleted locally:' -ForegroundColor Cyan
    Write-Host "> $($branches -join "`n> ")" -ForegroundColor Cyan
    $answer = Read-Host -Prompt "Are you sure you really want to delete all $count brances? (Y/N)"
    if ($answer -ine 'y')
    {
        Write-Host 'Exitting deletion' -ForegroundColor Cyan
        return
    }
}

# checkout to default branch, which is normally master
gco $DefaultBranch -Pull

# for each branch, force delete them
foreach ($branch in $branches)
{
    Write-Host "Deleting: $branch" -ForegroundColor Yellow
    git branch -D $branch
    if (!$?)
    {
        throw "Failed to delete the '$branch' branch"
    }
}

Write-Host "All $count branched deleted" -ForegroundColor Cyan