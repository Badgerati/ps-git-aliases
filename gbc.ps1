<#
.SYNOPSIS
Returns the current branch
#>
$branch = git branch | Where-Object { $_.StartsWith('*') }

if ([string]::IsNullOrWhiteSpace($branch))
{
    throw 'No current branch'
}

return $branch.Trim('*', ' ')