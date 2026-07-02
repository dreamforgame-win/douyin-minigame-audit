param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDir,

    [switch]$Force
)

# create-audit-package
# preserve_existing_package_yaml
$ErrorActionPreference = "Stop"

function Decode-Utf8Base64 {
    param([string]$Value)
    return [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir
$templatePath = Join-Path $skillDir "assets\audit-package-input.zh.yaml"

if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "Package input template not found: $templatePath"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$resolvedOutputDir = (Resolve-Path -LiteralPath $OutputDir).Path

$assetDirs = @(
    "5Zu+5qCH",
    "5oiq5Zu+",
    "6KeG6aKR5bCB6Z2i",
    "5a6j5Lyg6KeG6aKR",
    "5Yqg6L295Zu+",
    "5rW35oql",
    "5p6E5bu65Lqn54mp"
)

$credentialRoot = Decode-Utf8Base64 "6LWE6LSo5p2Q5paZ"
$credentialDirs = @(
    "6L2v6JGX",
    "54mI5Y+35oiW5om55paH",
    "5aSH5qGI5p2Q5paZ",
    "6ZqQ56eB5pS/562W",
    "55So5oi35Y2P6K6u",
    "5o6I5p2D5paH5Lu2",
    "5Li75L2T5p2Q5paZ"
)

foreach ($encoded in $assetDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $resolvedOutputDir (Decode-Utf8Base64 $encoded)) | Out-Null
}

$credentialRootPath = Join-Path $resolvedOutputDir $credentialRoot
New-Item -ItemType Directory -Force -Path $credentialRootPath | Out-Null
foreach ($encoded in $credentialDirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $credentialRootPath (Decode-Utf8Base64 $encoded)) | Out-Null
}

$targetYaml = Join-Path $resolvedOutputDir "audit-input.zh.yaml"
if ((Test-Path -LiteralPath $targetYaml) -and -not $Force) {
    Write-Output $resolvedOutputDir
    return
}

Copy-Item -LiteralPath $templatePath -Destination $targetYaml -Force:$Force

Write-Output $resolvedOutputDir
