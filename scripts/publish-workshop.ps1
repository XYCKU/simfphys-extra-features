[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
    [string]$GmodDirectory,

    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$GmaPath,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[1-9][0-9]*$')]
    [string]$WorkshopItemId,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[\x20-\x7E]+$')]
    [string]$ChangeNote
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$GmpublishPath = Join-Path $GmodDirectory "bin\gmpublish.exe"

if (-not (Test-Path -LiteralPath $GmpublishPath -PathType Leaf)) {
    throw "Could not find gmpublish.exe at '$GmpublishPath'."
}

& $GmpublishPath update -addon $GmaPath -id $WorkshopItemId -changes $ChangeNote
if ($LASTEXITCODE -ne 0) {
    throw "gmpublish.exe failed with exit code $LASTEXITCODE."
}

Write-Host "Published Workshop item $WorkshopItemId."
