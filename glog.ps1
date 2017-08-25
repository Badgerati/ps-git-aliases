
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
    $results[$_] = 0

    foreach ($log in $logs)
    {    
        if ($log -imatch $_)
        {
            $results[$_]++
        }
    }
}

$Search | ForEach-Object {
    Write-Host "$($_)`t-`t$($results[$_])" -ForegroundColor Cyan
}