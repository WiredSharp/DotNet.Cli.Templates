[CmdletBinding(SupportsShouldProcess)]
Param(
    # build semantic version major field
    [Parameter()][string]$Version
    # build semantic version minor field
    # build configuration
    , [Parameter()][string]$Configuration = "Release"
)

Set-StrictMode -Version Latest

$targetFolder = "bin\${Configuration}"
$packageName = "WiredSharp.Templates"

function toVersion([string[]]$versionFields) {
    [PSCustomObject]@{
        PSTypeName = "Version"
        Major = [int]$versionFields[0]
        Minor = [int]$versionFields[1]
        Patch = [int]$versionFields[2]
    }
}

function latest([PSTypeName('Version')]$version1, [PSTypeName('Version')]$version2) {
    if ($version1.Major -gt $version2.Major) {
        $version1
    } elseif ($version1.Major -lt $version2.Major) {
        $version2
    } elseif ($version1.Minor -gt $version2.Minor) {
        $version1
    } elseif ($version1.Minor -lt $version2.Minor) {
        $version2
    } elseif ($version1.Patch -gt $version2.Patch) {
        $version1
    } elseif ($version1.Patch -lt $version2.Patch) {
        $version2
    } else {
        $version1
    }
}

function toString([PSTypeName('Version')]$version) {
    "$($version.Major).$($version.Minor).$($version.Patch)"
}

function extractVersion ([string] $fileName) {
    $currentVersion = $fileName -replace "${packageName}\.", "" -replace "\.nupkg", ""
    toVersion ($currentVersion -split "\.")
}

function resolveVersion() {
    $packageVersions = Get-ChildItem -Path $targetFolder -Filter "${packageName}*.nupkg" 
    | ForEach-Object { extractVersion $_.Name }   
    foreach ($packageVersion in $packageVersions) {
        Write-Debug "found package version $(toString $packageVersion)"
        $version = if ($version) { latest $version $packageVersion } else { $packageVersion }
    }
    $version
}

if (-not $Version) {
    [PSTypeName('Version')]$version = resolveVersion
    if (-not $version) {
        Write-Error "no version available, version must be provided"
    } else {
        Write-Debug "resolved version: $(toString $version)"
        $version.Patch = $version.Patch + 1
        $Version = toString $version
    }
}

if ($Version) {
    dotnet pack -c $Configuration --version-suffix $Version
    # dotnet new -i "${targetFolder}\${packageName}.${Version}.nupkg"
    Write-Information "package ${packageName} v${Version} installed"
}

