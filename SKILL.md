---
name: douyin-minigame-audit
description: Use when reviewing Douyin/TikTok China mini-game submission materials, Chinese YAML/Markdown audit inputs, Unity/Godot/HTML project folders, asset packages, icons, screenshots, ads, IAP, anchors, qualifications, age rating, content, behavior, official Douyin mini-game approval/compliance risks, or Chinese triggers like 启动抖音提审, 抖音小游戏提审, 检查抖音过审风险, 帮我审核抖音小游戏.
---

# Douyin Mini-Game Audit

## Core Principle

先建档，再审计。Audit the actual submission package first, then use project scanning only as supporting evidence. Do not treat a full Unity, Godot, or HTML project as a substitute for the final backend submission text and assets.

## Every Trigger Update Check

At the start of every `douyin-minigame-audit` trigger, run:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>/scripts/check-update.ps1" -Install
```

- If the script reports `up_to_date`, continue normally.
- If it reports `installed`, stop and tell the user that a newer skill was installed, Codex/current AI client must be restarted, and after restarting they can return and say `继续`.
- If it reports `remote_version_missing` or `failed`, continue with the local version and mention the issue briefly.

Before installing an update, preserve active audit state with `scripts/save-audit-input.ps1` when practical.

## Required Source Loading

- Read `references/official-norms.md` before every audit.
- If the user asks for the latest official rule, or a finding depends on exact current wording, verify against the official Douyin Open Platform URLs in `references/official-norms.md`.
- For icons, screenshots, posters, and video covers, visually inspect local files when paths are available.
- If the user provides only a project folder, ask for or create an audit input file because backend fields cannot be inferred reliably from source code.

## 首次触发闸门 (First Touch Gate)

When the user only says a trigger phrase such as `启动抖音提审`, `抖音小游戏提审`, `检查抖音过审风险`, or otherwise provides no YAML/Markdown/path/materials:

1. Enter `Package Intake Choice` first; 禁止在空输入时直接输出审核结论。
2. Offer the two intake methods, with `Create/select concentrated audit package` listed first and recommended.
3. If the user insists on `Manual full YAML`, paste the complete path-based YAML from `assets/audit-input.zh.yaml` and wait for them to fill it.
4. If the user chooses `Create/select concentrated audit package`, ask for the new or existing package directory before running the helper.
5. After creating or selecting a package, explain the filling notes and wait until the user says the package is complete.
6. Then continue with the previous audit workflow.

Recommended first response:

```text
我先帮你建提审档案，不会现在就下审核结论。你想用哪种方式准备资料？

1. 创建/选择集中提审资料包（推荐）：你给我一个新建或已有的资料包目录，我补齐固定目录和 audit-input.zh.yaml，你把图标、截图、视频、资质材料放进去，再填写 YAML。
2. 手动填写完整 YAML：我直接把完整 YAML 模板贴出来，你手动填写所有路径和字段。

建议选 1，后续正式提审、预审、复审都只围绕同一个资料包，不容易散。
如果选 1，请告诉我新建/已有资料包目录；如果坚持选 2，我会直接贴完整 YAML。
```

## Package Intake Choice

Use these two intake methods before auditing a new or empty submission:

1. `Create/select concentrated audit package` (recommended): ask for the new or existing package directory, then run:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>/scripts/create-audit-package.ps1" -OutputDir "<用户给出的目录>"
```

If the directory already contains `audit-input.zh.yaml`, keep that YAML and only complete the fixed directories. If it has no YAML, create one from `assets/audit-package-input.zh.yaml`.

After creation, tell the user:

- Put materials into the fixed directories: `图标`, `截图`, `视频封面`, `宣传视频`, `加载图`, `海报`, `构建产物`, and `资质材料`.
- Fill `audit-input.zh.yaml` in the package root.
- Leave legal/operations/business-owned unknowns in `待补资料`.
- `工程项目目录路径` is optional and only used for enhanced project scanning.
- Reply when the package is complete; only then continue to audit.

2. `Manual full YAML`: paste the complete `assets/audit-input.zh.yaml` content, including all material and qualification path fields, then wait for the user to fill it. Do not shorten the official option reference.

For old projects, if the user gives a project name or project nickname / 项目简称 before choosing a method, search saved state first. If no saved input matches, return to the two-method intake choice.

## Project State And Matching

- 按项目名称保存 audit input under `.douyin-minigame-audit/projects/<project-slug>/audit-input.yaml` or `.md`.
- Keep compatibility with legacy `.douyin-minigame-audit/audit-input.yaml` and `.md`.
- Store `project_name` and `project_aliases` in `last-save.json`; aliases may include 项目简称, app id, internal codename, or common Chinese abbreviation.
- When resuming an old project, search by exact name first, then case-insensitive/space-insensitive substring match across folder names, `project_name`, and `project_aliases`.
- If multiple saved projects match a 项目简称, ask the user to choose instead of guessing.
- If no saved project matches, say that no local audit file was found for that name and continue as a new project setup.

Use the helper when practical:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>/scripts/save-audit-input.ps1" -InputFile audit-input.yaml -ProjectName "游戏名称" -ProjectAliases "简称,内部代号"
```

## Input Priority

1. If the user provides a YAML or Markdown audit input, use it as the primary input.
2. If the input names `资料包目录路径` or `工程项目目录路径`, look for project-scoped and legacy saved files under those directories.
3. If the user gives a project name or 项目简称, search project-scoped saved inputs before scanning generic directories.
4. If no usable input exists, enter the 首次触发闸门; do not output an audit report.
5. If both saved input and new input exist, merge conceptually with this turn's user-provided values taking precedence. Preserve unknown previous fields unless the user explicitly removes them.

## Saving Behavior

- When the user provides complete or partial Chinese YAML/Markdown audit input, save a copy unless they say not to.
- Prefer saving under the project-scoped state directory in the package dir, then project dir, then current workspace.
- Always include project name when known. If the game name is missing, ask for it before saving as a reusable project file.
- Tell the user the saved path so future audits can reuse it.

## Expected Chinese YAML Shape

Use `assets/audit-input.zh.yaml` as the canonical template. Accept Markdown with equivalent headings, but normalize mentally to these sections:

- `游戏信息`: `游戏名称`, `项目简称`, `软著名称`, `备案名称`, `版号名称`, `版本号`, engine/platform, official category levels, theme, art style, age rating.
- `目录`: `资料包目录路径`, `工程项目目录路径`, `构建产物目录路径`.
- `提审文案`: `一句话简介`, `详细介绍`, update notes, keywords.
- `素材`: icon, screenshots, video covers, promo videos, loading images, posters.
- `能力与玩法`: ads, IAP, login, ranking, share, sidebar revisit, chat, UGC, location, payment/privacy collection, minors, multiplayer.
- `资质与合规`: software copyright, ISBN/approval document, filing materials, privacy policy, user agreement, authorization files, business license/entity files.
- `运营与变现`: CPA/CPT/CPM/CPS anchors, advertising game, in-game purchase game, traffic promotion, game station, Jianying template.
- `自查说明`: known risks, intended changes, reviewer notes, unknown owner-dependent materials.

Concentrated package YAML from `assets/audit-package-input.zh.yaml` intentionally omits material, qualification, package path, and build output path fields. In that flow, scan fixed directories relative to the YAML root.

## Audit Workflow

1. Identify the submission type: first launch, version update, basic info change, filing, anchor video, advertising game, in-app purchase game, traffic promotion, game station, or Jianying template.
2. Load the official norms index and map the submission type to relevant norms.
3. Validate required fields and assets from YAML/Markdown.
4. Inspect the asset package directory if present. For concentrated packages, treat the YAML parent directory as the package root and scan fixed material, qualification, and build output directories even when no material paths exist in YAML.
5. Scan the project directory only for supporting signals:
   - Unity: `ProjectSettings/ProjectVersion.txt`, `Packages/manifest.json`, `Assets/`, WebGL/minigame SDK folders, privacy/ad/payment/login SDK indicators.
   - Godot: `project.godot`, `export_presets.cfg`, `addons/`, exported web/minigame folders.
   - HTML/Web: `package.json`, `src/`, `public/`, build output, ad/payment/login SDK imports.
6. Visually inspect icon/screenshots/video covers when available.
7. Produce a risk-ranked report only after there is usable project input.

## Sidebar Revisit Required Ability

For ordinary first submissions and version updates, always check the Douyin required sidebar revisit ability.

- YAML/input check: look for `是否接入侧边栏复访能力` and `侧边栏复访说明`.
- Official scope: include `必接能力` and `侧边栏复访能力` from `references/official-norms.md`.
- Project scan signals: when a project directory is available, search for `tt.navigateToScene`, `navigateToScene`, `checkScene`, `getLaunchOptionsSync`, `onShow`, `scene`, `sidebar`, `侧边栏`, and `复访`.
- Evidence rule: if the YAML says it is connected but project scan has no sidebar/API signal, report `待工程确认` and ask for the SDK integration file or runtime evidence.
- Risk rule: if sidebar revisit is missing, false, or clearly not connected for a first submission/version update, mark it `高风险` because the required ability may block upload or review.

## Unknown Or Legal-Owned Materials

Some materials may be outside the user's role. For example, a developer may not know soft copyright files, filing materials, business license, authorization agreements, ISBN/approval documents, privacy policy legal wording, or payment qualifications.

- Do not mark provided gameplay/code/assets as failing because legal/company materials are missing.
- Put unavailable company/legal materials under `缺失资料与责任方`.
- If a material is needed to decide a specific rule, mark that rule as `无法判断` or `待法务/运营补充`, not as a rejection of known content.
- If all provided content appears compliant within the available evidence, explicitly say `已提供内容合格；未提供资料仍需补齐后才能形成最终提审结论`.
- If the user says a material cannot be provided, report the scope honestly: `基于已提供内容合格，但缺少 xxx，无法覆盖 xxx 规范`.
- Use this report section name for these items: `缺失资料与责任方 (Missing Materials And Owners)`.

## Report Format

Return reports in Chinese:

```text
审核结论：
- 结论：通过 / 有风险 / 高风险 / 信息不足
- 风险等级：低 / 中 / 高
- 建议动作：可提交 / 修改后提交 / 补齐材料后复审 / 暂不建议提交
- 一句话摘要：...

命中规范范围：
- 已检查：...
- 未覆盖：列出因材料缺失而无法判断的规范范围。

资料完整度：
- 基础信息：完整 / 缺失 xxx
- 提审文案：完整 / 缺失 xxx
- 素材文件：完整 / 缺失 xxx
- 资质材料：完整 / 缺失 xxx
- 工程/构建目录：已检查 / 未提供 / 不适用

必接能力检查：
- 侧边栏复访能力：已接入 / 未接入 / 待工程确认 / 未提供信息
- 证据：YAML 字段、代码扫描命中、或缺失说明
- 影响：未接入可能导致版本上传/提审被拦截

缺失资料与责任方：
- 资料名称：为什么需要；建议责任方：研发 / 运营 / 法务 / 商务 / 财务 / 发行；不提供时影响什么判断。

已提供内容判断：
- 已提供内容合格 / 已提供内容存在风险 / 已提供内容信息不足
- 说明：只评价实际已看到的 YAML、文件、素材、项目扫描结果。

高风险问题：
- [高风险] 问题标题
  位置：字段、路径或素材名
  依据：官方规范名称
  影响：为什么可能阻塞提审
  建议：可执行修改方案

中风险问题：
- [有风险] 问题标题
  位置：字段、路径或素材名
  依据：官方规范名称
  影响：可能造成驳回、人工修正或二次修改成本
  建议：可执行修改方案

低风险建议：
- [建议] 优化点
  依据：官方规范名称或经验判断
  建议：优化方案

素材检查结果：
- 图标：通过 / 有风险 / 未提供
- 截图：通过 / 有风险 / 未提供
- 视频封面：通过 / 有风险 / 未提供
- 宣传视频：通过 / 有风险 / 未提供
- 说明：只列关键发现，不重复完整素材清单。

文案修改建议：
- 一句话简介：
  - 原文：...
  - 建议：...
- 详细介绍：
  - 原文风险：...
  - 建议文案：...
- 更新说明：
  - 建议：...

下一步处理建议：
1. 先处理会阻塞提审的高风险问题。
2. 让对应责任方补齐缺失资料。
3. 再次运行 `启动抖音提审` 做复审。

已保存输入：
- 输入路径：...
- 报告路径：如已保存则填写；未保存则写“未保存”。
```

## Risk Rules

- Mark as `高风险` when the issue likely blocks review: missing required qualification that is required for the declared submission type, name mismatch with soft copyright/filing, forbidden icon content, external diversion, misleading gameplay, illegal content, gambling/pornographic/bloody content, unapproved payment, serious minors/privacy issue, ad/IAP rule conflict, or sidebar revisit is missing.
- Mark as `有风险` when the issue may trigger rejection or manual correction: vague description, category mismatch, screenshots not showing real gameplay, wording exaggeration, age rating mismatch, incomplete update notes, unclear anchor video relationship, or missing optional evidence.
- Mark as `信息不足` when the project may be compliant but the submitted backend fields/assets are absent.
- Separate `已提供内容合格` from final approval when mandatory company/legal materials are missing.

## Common Mistakes

- Do not audit only the basic information document; the scope includes all official norms listed in `references/official-norms.md`.
- Do not assume the project directory contains the final icon, screenshots, or backend text.
- Do not approve images without visual inspection when paths are available.
- Do not silently ignore saved input; reuse project-scoped saved input and ask only for missing deltas.
- Do not invent official rules. If unsure, cite the norm title and ask to verify the exact current wording from the official URL.
- Do not produce a report immediately after a bare trigger phrase; guide the user into new/old project setup first.
