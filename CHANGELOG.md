# Changelog

## 0.4.0 - 2026-07-02

- Add a recommended concentrated audit package intake flow before first audit results.
- Add `assets/audit-package-input.zh.yaml` for package-based submissions with fixed material directories and full official option references.
- Add `scripts/create-audit-package.ps1` to create the package directory, fixed material folders, qualification folders, build output folder, and root `audit-input.zh.yaml`.
- Allow the package flow to create or select an existing package directory while preserving an existing `audit-input.zh.yaml`.
- Keep manual full YAML as the second intake option for users who insist on path-by-path entry.
- Update the first-trigger gate so empty trigger phrases ask for package/manual preparation first, then wait for completed input before auditing.

## 0.3.2 - 2026-07-02

- Change update checks from once per local day to every skill trigger.
- Remove the `skipped_today` short-circuit from `scripts/check-update.ps1`.
- Keep update-check state recording for troubleshooting without using it to skip checks.

## 0.3.1 - 2026-07-02

- Add sidebar revisit as a required Douyin mini-game ability check.
- Add YAML/Markdown input fields for `是否接入侧边栏复访能力` and related notes.
- Add project scan signals for `tt.navigateToScene`, scene handling, sidebar, and revisit keywords.
- Add official `必接能力` and `侧边栏复访能力` documentation entries to the norms index.
- Mark missing sidebar revisit as a high-risk issue for ordinary first submissions and version updates.

## 0.3.0 - 2026-07-01

- Add a first-trigger intake gate so bare trigger phrases ask whether this is a new or existing project instead of producing an empty audit result.
- Save audit inputs under project-scoped state directories using project names and aliases.
- Add project nickname fields to the Chinese YAML/Markdown templates.
- Separate missing legal/company-owned materials from the compliance judgment for already provided content.
- Add a contract test for the skill workflow and persistence rules.

## 0.2.2 - 2026-07-01

- Improve the Chinese YAML audit template with explicit local path fields for icons, screenshots, covers, videos, and compliance files.
- Add word-count guidance and examples for submission copy fields.
- Add official option references for category, theme, art style, and age rating.
- Add inline reference hints that point users to the relevant option sections inside the YAML template.

## 0.2.1 - 2026-07-01

- Add Chinese trigger phrases to `SKILL.md` discovery metadata.
- Document common trigger phrases in `README.md`.

## 0.2.0 - 2026-07-01

- Add daily update check support through `scripts/check-update.ps1`.
- Add restart/resume guidance after skill update installation.
- Add release packaging script through `scripts/package-release.ps1`.
- Add README, LICENSE, VERSION, and release package support for GitHub publishing.

## 0.1.0 - 2026-07-01

- Initial `douyin-minigame-audit` skill.
- Add Chinese YAML/Markdown audit input templates.
- Add official Douyin mini-game norms index covering 20 official documents.
- Add audit input save helper.
