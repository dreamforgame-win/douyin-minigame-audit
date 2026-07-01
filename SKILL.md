---
name: douyin-minigame-audit
description: Use when reviewing Douyin/TikTok China mini-game submission materials, Chinese YAML/Markdown audit inputs, Unity/Godot/HTML project folders, asset packages, icons, screenshots, ads, IAP, anchors, qualifications, age rating, content, behavior, or official Douyin mini-game approval/compliance risks before submission.
---

# Douyin Mini-Game Audit

## Core Principle

Audit the actual submission package first, then use project scanning only as supporting evidence. Do not treat a full Unity, Godot, or HTML project as a substitute for the final backend submission text and assets.

## Required Source Loading

- Read `references/official-norms.md` before every audit.
- If the user asks for the latest official rule, or if a finding depends on exact current wording, verify against the official Douyin Open Platform URLs in `references/official-norms.md`.
- For icons, screenshots, posters, and video covers, visually inspect the local files when paths are available.
- If the user provides only a project folder, ask for or create an audit input file because backend fields cannot be inferred reliably from source code.

## Input Priority

1. If the user provides a YAML or Markdown audit input, use it as the primary input.
2. If the input names `资料包目录` or `工程项目目录`, look for saved files in:
   - `<资料包目录>/.douyin-minigame-audit/audit-input.yaml`
   - `<资料包目录>/.douyin-minigame-audit/audit-input.md`
   - `<工程项目目录>/.douyin-minigame-audit/audit-input.yaml`
   - `<工程项目目录>/.douyin-minigame-audit/audit-input.md`
3. If no new input is provided, search the current workspace and likely project/package folders for `.douyin-minigame-audit/audit-input.yaml` or `.douyin-minigame-audit/audit-input.md`.
4. If both saved input and new input exist, merge conceptually with this turn's user-provided values taking precedence. Preserve unknown previous fields unless the user explicitly removes them.

## Saving Behavior

- When the user provides a complete or partial Chinese YAML/Markdown audit input, save a copy unless they say not to.
- Prefer saving under `资料包目录/.douyin-minigame-audit/`.
- If no package directory exists but `工程项目目录` exists, save under `工程项目目录/.douyin-minigame-audit/`.
- If neither directory exists, save under the current workspace `.douyin-minigame-audit/`.
- Use `scripts/save-audit-input.ps1` for deterministic saving when practical.
- Tell the user where the saved file is, so future audits can reuse it.

## Expected Chinese YAML Shape

Use `assets/audit-input.zh.yaml` as the canonical template. Accept Markdown with equivalent headings, but normalize mentally to these sections:

- `游戏信息`: name, soft copyright name, version, engine, platform, category, art style, age rating.
- `提审文案`: short description, detailed description, update notes, keywords.
- `目录`: package directory, project directory, build output directory.
- `素材`: icon, screenshots, video covers, promotional videos, loading image, posters.
- `能力与玩法`: ads, IAP, login, ranking, share, chat, UGC, location, payment, privacy collection, minors, multiplayer.
- `资质与合规`: copyright, ISBN/approval number if any, filing, business licenses, privacy policy, user agreement.
- `运营与变现`: CPA/CPT/CPM/CPS anchors, advertising game, in-game purchase game, traffic promotion, game station, Jianying template.
- `自查说明`: known risks, intended changes, reviewer notes.

## Audit Workflow

1. Identify the submission type: first launch, version update, basic info change, filing, anchor video, advertising game, in-app purchase game, traffic promotion, game station, or Jianying template.
2. Load the official norms index and map the submission type to relevant norms.
3. Validate required fields and assets from the YAML/Markdown.
4. Inspect the asset package directory if present.
5. Scan the project directory only for supporting signals:
   - Unity: `ProjectSettings/ProjectVersion.txt`, `Packages/manifest.json`, `Assets/`, WebGL/minigame SDK folders, privacy/ad/payment/login SDK indicators.
   - Godot: `project.godot`, `export_presets.cfg`, `addons/`, exported web/minigame folders.
   - HTML/Web: `package.json`, `src/`, `public/`, build output, ad/payment/login SDK imports.
6. Visually inspect icon/screenshots/video covers when available.
7. Produce a risk-ranked report.

## Report Format

Return reports in Chinese:

```text
审核结论：通过 / 有风险 / 高风险 / 信息不足

高优先级问题：
- [高风险] 问题描述
  依据：官方规范名称
  建议：可直接修改的做法或文案

中低优先级问题：
- ...

缺失材料：
- ...

可直接替换文案：
- 简介：...
- 详细介绍：...

已保存输入：
- 路径：...
```

## Risk Rules

- Mark as `高风险` when the issue likely blocks review: missing required qualification, name mismatch with soft copyright/filing, forbidden icon content, external diversion, misleading gameplay, illegal content, gambling/pornographic/bloody content, unapproved payment, serious minors/privacy issue, or ad/IAP rule conflict.
- Mark as `有风险` when the issue may trigger rejection or manual correction: vague description, category mismatch, screenshots not showing real gameplay, wording exaggeration, age rating mismatch, incomplete update notes, unclear anchor video relationship, or missing optional evidence.
- Mark as `信息不足` when the project may be compliant but the submitted backend fields/assets are absent.

## Common Mistakes

- Do not audit only the basic information document; the scope includes all official norms listed in `references/official-norms.md`.
- Do not assume `工程项目目录` contains the final icon, screenshots, or backend text.
- Do not approve images without visual inspection when paths are available.
- Do not silently ignore saved input; reuse it on later runs and ask only for missing deltas.
- Do not invent official rules. If unsure, cite the norm title and ask to verify the exact current wording from the official URL.
