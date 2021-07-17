$inputSln = "SlnFilter.sln"
$outputSlnFilter = "SlnFilter.Generated.slnf"

$projectFiles = Get-ChildItem -Recurse -Filter "*.csproj" -Name
# $excludeFilters = @()
$excludeFilters = @('.ConcreteBravo')


$targetProjects = New-Object Collections.Generic.List[String]

foreach ($project in $projectFiles)
{
    $shouldInclude = $true

    foreach ($filter in $excludeFilters)
    {
        $shouldInclude = $project -notmatch $filter
        if (!$shouldInclude)
        {
            break
        }
    }

    if ($shouldInclude)
    {
        $targetProjects.Add($project)
    }
}

$sln = New-Object -TypeName psobject
$sln | Add-Member -MemberType NoteProperty -Name "path" -Value $inputSln
$sln | Add-Member -MemberType NoteProperty -Name "projects" -value $targetProjects

$root = New-Object -TypeName psobject
$root | Add-Member -MemberType NoteProperty -Name "solution" -value $sln

$root | ConvertTo-Json | Out-File $outputSlnFilter