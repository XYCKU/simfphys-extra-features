[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
    [string]$ServerDirectory,

    [ValidateRange(30, 300)]
    [int]$TimeoutSeconds = 120
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepositoryRoot = Split-Path -Parent $PSScriptRoot
$ServerRoot = (Resolve-Path -LiteralPath $ServerDirectory).Path
$SrcdsPath = Join-Path $ServerRoot "srcds.exe"
$AddonsDirectory = Join-Path $ServerRoot "garrysmod\addons"
$StageDirectory = Join-Path $AddonsDirectory "sef-ci"
$StageMarkerPath = Join-Path $StageDirectory ".sef-ci-generated"
$LuaStageDirectory = Join-Path $StageDirectory "lua"
$LogDirectory = Join-Path $RepositoryRoot "artifacts"
$StandardOutputPath = Join-Path $LogDirectory "gmod-tests.stdout.log"
$StandardErrorPath = Join-Path $LogDirectory "gmod-tests.stderr.log"

if (-not (Test-Path -LiteralPath $SrcdsPath -PathType Leaf)) {
    throw "Could not find srcds.exe at '$SrcdsPath'. Install the Garry's Mod dedicated server (Steam app 4020)."
}

if (-not (Test-Path -LiteralPath $AddonsDirectory -PathType Container)) {
    throw "Could not find the dedicated server addons directory at '$AddonsDirectory'."
}

foreach ($Path in @(
    (Join-Path $RepositoryRoot "lua\sef"),
    (Join-Path $RepositoryRoot "lua\autorun\sef_init.lua"),
    (Join-Path $RepositoryRoot "tests\gmod\sef_ci.lua")
)) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Required GMod test source is missing: '$Path'."
    }
}

New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null

if (Test-Path -LiteralPath $StageDirectory) {
    if (-not (Test-Path -LiteralPath $StageMarkerPath -PathType Leaf)) {
        throw "Refusing to remove '$StageDirectory' because it is not a previous SEF CI stage."
    }

    Remove-Item -LiteralPath $StageDirectory -Recurse -Force
}

try {
    New-Item -ItemType Directory -Path (Join-Path $LuaStageDirectory "autorun\server") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $LuaStageDirectory "tests") -Force | Out-Null
    New-Item -ItemType File -Path $StageMarkerPath -Force | Out-Null

    Copy-Item -LiteralPath (Join-Path $RepositoryRoot "lua\sef") -Destination $LuaStageDirectory -Recurse -Force
    Copy-Item -LiteralPath (Join-Path $RepositoryRoot "lua\autorun\sef_init.lua") -Destination (Join-Path $LuaStageDirectory "tests\sef_init.lua") -Force
    Copy-Item -LiteralPath (Join-Path $RepositoryRoot "tests\gmod\sef_ci.lua") -Destination (Join-Path $LuaStageDirectory "autorun\server\zz_sef_ci.lua") -Force

    Remove-Item -LiteralPath $StandardOutputPath, $StandardErrorPath -Force -ErrorAction SilentlyContinue

    $Process = Start-Process `
        -FilePath $SrcdsPath `
        -ArgumentList @("-game", "garrysmod", "-console", "-noconclr", "-allowquit", "-noworkshop", "+gamemode", "sandbox", "+map", "gm_construct") `
        -WorkingDirectory $ServerRoot `
        -PassThru `
        -RedirectStandardOutput $StandardOutputPath `
        -RedirectStandardError $StandardErrorPath

    if (-not $Process.WaitForExit($TimeoutSeconds * 1000)) {
        Stop-Process -Id $Process.Id -Force
        throw "Dedicated server did not finish within $TimeoutSeconds seconds."
    }

    $Output = @()
    foreach ($Path in @($StandardOutputPath, $StandardErrorPath)) {
        if (Test-Path -LiteralPath $Path) {
            $Output += Get-Content -LiteralPath $Path
        }
    }

    if ($Output -match "\[SEF CI\] FAIL") {
        throw "GMod server tests reported a failure. See artifacts/gmod-tests.*.log."
    }

    if ($Output -notmatch "\[SEF CI\] PASS [0-9]+ assertions") {
        throw "GMod server tests did not report completion. See artifacts/gmod-tests.*.log."
    }

    if ($Process.ExitCode -ne 0) {
        throw "Dedicated server exited with code $($Process.ExitCode)."
    }

    Write-Host "GMod server tests passed."
}
finally {
    if (Test-Path -LiteralPath $StageMarkerPath -PathType Leaf) {
        Remove-Item -LiteralPath $StageDirectory -Recurse -Force
    }
}
