
param (
    [Alias('s')]
    [string[]]
    $Search = @(),

    [Alias('l')]
    [int]
    $Limit = 10
)

if (($Search | Measure-Object).Count -eq 0)
{
    git log -$Limit
    return
}

$logs = ((git log -$Limit) -join "`n") -split 'commit '
$results = @{}

$Search | ForEach-Object {
    $results[$_] = @()

    foreach ($log in $logs)
    {    
        if ($log -imatch $_)
        {
            $results[$_] += (($log -split "`n")[0]).Substring(1, 7)
        }
    }
}

$Search | ForEach-Object {
    $count = ($results[$_] | Measure-Object).Count
    
    $commit = [string]::Empty
    if ($count -gt 0)
    {
        $commit = ($results[$_] -join ', ') -ireplace ':', ''
    }
    
    Write-Host "$($_)`t-`t$($count)`t-`t$($commit)" -ForegroundColor Cyan
}