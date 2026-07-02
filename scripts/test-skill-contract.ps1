param()

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillDir = Split-Path -Parent $scriptDir

function Read-Text {
    param([string]$Path)
    return Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $skillDir $Path)
}

function Assert-Contains {
    param(
        [string]$Name,
        [string]$Haystack,
        [string]$Needle
    )
    if ($Haystack -notlike "*$Needle*") {
        throw "Missing contract marker: $Name -> $Needle"
    }
}

function Assert-NotContains {
    param(
        [string]$Name,
        [string]$Haystack,
        [string]$Needle
    )
    if ($Haystack -like "*$Needle*") {
        throw "Forbidden contract marker present: $Name -> $Needle"
    }
}

$skill = Read-Text "SKILL.md"
$readme = Read-Text "README.md"
$yaml = Read-Text "assets/audit-input.zh.yaml"
$packageYaml = Read-Text "assets/audit-package-input.zh.yaml"
$saveScript = Read-Text "scripts/save-audit-input.ps1"
$checkUpdateScript = Read-Text "scripts/check-update.ps1"
$createPackageScript = Read-Text "scripts/create-audit-package.ps1"
$version = (Read-Text "VERSION").Trim()

Assert-Contains "version" $version "0.4.0"
Assert-Contains "first touch gate" $skill "First Touch Gate"
Assert-Contains "package intake choice" $skill "Package Intake Choice"
Assert-Contains "recommended package option" $skill "Create/select concentrated audit package"
Assert-Contains "manual YAML option" $skill "Manual full YAML"
Assert-Contains "ask package directory" $skill "new or existing package directory"
Assert-Contains "two-method first question" $skill "two intake methods"
Assert-Contains "old project saved state lookup" $skill "For old projects"
Assert-Contains "no empty report" $skill "bare trigger phrase"
Assert-Contains "project scoped save" $skill ".douyin-minigame-audit/projects/<project-slug>"
Assert-Contains "fuzzy old project" $skill "project nickname"
Assert-Contains "provided content scope" $skill "provided content appears compliant"
Assert-Contains "unknown legal materials" $skill "outside the user's role"
Assert-Contains "missing materials section" $skill "Missing Materials And Owners"
Assert-Contains "README first run" $readme "will not immediately produce an audit"
Assert-Contains "YAML project alias" $yaml "AppID"
Assert-Contains "save project name parameter" $saveScript "ProjectName"
Assert-Contains "sidebar revisit skill rule" $skill "Sidebar Revisit Required Ability"
Assert-Contains "sidebar revisit api signal" $skill "tt.navigateToScene"
Assert-Contains "sidebar revisit high risk" $skill "sidebar revisit is missing"
Assert-Contains "YAML sidebar field" $yaml "sidebar_revisit_required"
Assert-Contains "official essential skills doc" (Read-Text "references/official-norms.md") "essential-skills"
Assert-Contains "official sidebar doc" (Read-Text "references/official-norms.md") "sidebar"
Assert-Contains "every trigger update check skill doc" $skill "Every Trigger Update Check"
Assert-Contains "every trigger update check README" $readme "Every trigger update check"
Assert-Contains "README package option" $readme "concentrated audit package"
Assert-Contains "README create or select package" $readme "create or select a concentrated audit package"
Assert-Contains "package template marker" $packageYaml "package_template_fixed_dirs"
Assert-Contains "package template full options" $packageYaml "official_options_full"
Assert-Contains "create package script marker" $createPackageScript "create-audit-package"
Assert-Contains "create package script preserves existing YAML marker" $createPackageScript "preserve_existing_package_yaml"
Assert-Contains "package template no material path fields" $packageYaml "no_material_path_fields"
Assert-Contains "package template no credential path fields" $packageYaml "no_credential_path_fields"
Assert-Contains "package template no package dir field" $packageYaml "no_package_dir_field"
Assert-Contains "package template no build dir field" $packageYaml "no_build_dir_field"
Assert-NotContains "no skipped_today status in update script" $checkUpdateScript "skipped_today"
Assert-NotContains "no daily update check heading" $skill "Daily Update Check"
Assert-NotContains "no daily update check README heading" $readme "Daily Update Check"

$tmpRoot = Join-Path $env:TEMP ("douyin-package-contract-" + [guid]::NewGuid().ToString("N"))
try {
    $createdPath = powershell -ExecutionPolicy Bypass -File (Join-Path $skillDir "scripts/create-audit-package.ps1") -OutputDir $tmpRoot
    Assert-Contains "created package path" $createdPath $tmpRoot

    if (-not (Test-Path -LiteralPath (Join-Path $tmpRoot "audit-input.zh.yaml") -PathType Leaf)) {
        throw "Missing created package YAML"
    }
    $topLevelDirCount = (Get-ChildItem -LiteralPath $tmpRoot -Directory | Measure-Object).Count
    if ($topLevelDirCount -lt 8) {
        throw "Expected at least 8 top-level package directories, got $topLevelDirCount"
    }
    $nestedDirCount = (Get-ChildItem -LiteralPath $tmpRoot -Recurse -Directory | Measure-Object).Count
    if ($nestedDirCount -lt 14) {
        throw "Expected at least 14 total package directories, got $nestedDirCount"
    }

    $existingRoot = Join-Path $env:TEMP ("douyin-existing-package-contract-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $existingRoot | Out-Null
    $existingYaml = Join-Path $existingRoot "audit-input.zh.yaml"
    "existing-sentinel" | Set-Content -Encoding UTF8 -LiteralPath $existingYaml
    $selectedPath = powershell -ExecutionPolicy Bypass -File (Join-Path $skillDir "scripts/create-audit-package.ps1") -OutputDir $existingRoot
    Assert-Contains "selected existing package path" $selectedPath $existingRoot

    $existingYamlText = Get-Content -Raw -Encoding UTF8 -LiteralPath $existingYaml
    Assert-Contains "existing package YAML preserved" $existingYamlText "existing-sentinel"
    $existingDirCount = (Get-ChildItem -LiteralPath $existingRoot -Directory | Measure-Object).Count
    if ($existingDirCount -lt 8) {
        throw "Expected existing package directories to be completed, got $existingDirCount"
    }
}
finally {
    if (Test-Path -LiteralPath $tmpRoot) {
        Remove-Item -LiteralPath $tmpRoot -Recurse -Force
    }
    if ($existingRoot -and (Test-Path -LiteralPath $existingRoot)) {
        Remove-Item -LiteralPath $existingRoot -Recurse -Force
    }
}

Write-Output "skill contract ok"
