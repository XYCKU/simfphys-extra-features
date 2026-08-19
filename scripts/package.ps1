[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
    [string]$GmodDirectory,

    [ValidatePattern('^[a-z0-9][a-z0-9._-]*$')]
    [string]$PackageName = "simfphys-extra-features"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepositoryRoot = Split-Path -Parent $PSScriptRoot
$ArtifactsDirectory = Join-Path $RepositoryRoot "artifacts"
$StageDirectory = Join-Path $ArtifactsDirectory "package-stage"
$GmaPath = Join-Path $ArtifactsDirectory "$PackageName.gma"
$ChecksumPath = "$GmaPath.sha256"
$GmadPath = Join-Path $GmodDirectory "bin\gmad.exe"
$MetadataPath = Join-Path $RepositoryRoot "addon.json"

if (-not (Test-Path -LiteralPath $GmadPath -PathType Leaf)) {
    throw "Could not find gmad.exe at '$GmadPath'."
}

if (-not (Test-Path -LiteralPath $MetadataPath -PathType Leaf)) {
    throw "Could not find addon.json at '$MetadataPath'."
}

try {
    Get-Content -LiteralPath $MetadataPath -Raw | ConvertFrom-Json | Out-Null
}
catch {
    throw "addon.json must contain valid JSON. $($_.Exception.Message)"
}

if (Test-Path -LiteralPath $StageDirectory) {
    Remove-Item -LiteralPath $StageDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path $StageDirectory -Force | Out-Null

foreach ($Directory in @("lua", "materials", "resource")) {
    $SourcePath = Join-Path $RepositoryRoot $Directory

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
        throw "Required addon directory is missing: '$Directory'."
    }

    Copy-Item -LiteralPath $SourcePath -Destination $StageDirectory -Recurse -Force
}

Copy-Item -LiteralPath $MetadataPath -Destination $StageDirectory -Force

& $GmadPath create -folder $StageDirectory -out $GmaPath
if ($LASTEXITCODE -ne 0) {
    throw "gmad.exe failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath $GmaPath -PathType Leaf)) {
    throw "gmad.exe did not create '$GmaPath'."
}

$Hash = Get-FileHash -LiteralPath $GmaPath -Algorithm SHA256
"$($Hash.Hash.ToLowerInvariant()) *$PackageName.gma" | Set-Content -LiteralPath $ChecksumPath -NoNewline

Write-Host "Created $GmaPath"
Write-Host "Created $ChecksumPath"
