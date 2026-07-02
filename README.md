# douyin-minigame-audit

`douyin-minigame-audit` is a Codex skill for reviewing Douyin mini-game submission materials before platform approval.

It focuses on Chinese YAML/Markdown submission inputs, asset package folders, and optional Unity/Godot/HTML project folders. It checks the submission against the official Douyin Open Platform mini-game norms index included in `references/official-norms.md`.

## What It Reviews

- Basic game information: name, soft copyright name, filing name, category, art style, age rating.
- Submission copy: short description, detailed description, update notes, keywords.
- Assets: icon, screenshots, video covers, promo videos, posters, loading images.
- Gameplay and capabilities: login, sharing, ranking, chat, UGC, location, privacy, minors, multiplayer.
- Required platform abilities: sidebar revisit ability and related API/project scan signals such as `tt.navigateToScene`.
- Monetization: ads, IAP, CPA/CPT/CPM/CPS anchors, traffic promotion, game station, Jianying template.
- Compliance materials: software copyright, filing materials, privacy policy, user agreement, authorization files.
- Optional project scan: Unity, Godot, or HTML/Web project directory.

## Install

Copy the `douyin-minigame-audit` folder into your Codex skills directory:

```text
C:\Users\<YourUser>\.codex\skills\douyin-minigame-audit
```

Restart Codex or your current AI client after installation.

## Trigger Phrases

You can invoke the skill explicitly:

```text
Use $douyin-minigame-audit to review my submission.
```

Common Chinese trigger phrases:

```text
启动抖音提审
抖音小游戏提审
检查抖音过审风险
帮我审核抖音小游戏
```

第一次触发时不会立即审计（will not immediately produce an audit）。技能会先询问使用哪种资料准备方式：

1. Create/select concentrated audit package（推荐）：使用新建或已有资料包目录，补齐固定目录和 `audit-input.zh.yaml`，素材和资质统一放在资料包里。
2. Manual full YAML：直接填写完整路径版 `assets/audit-input.zh.yaml`。

旧项目也可以直接提供游戏全称、项目简称、AppID 或内部代号，技能会优先加载已保存的项目档案。

## Typical Input

Recommended for new submissions: create or select a concentrated audit package:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\create-audit-package.ps1 -OutputDir "E:\审核材料"
```

That creates:

```text
审核材料/
  audit-input.zh.yaml
  图标/
  截图/
  视频封面/
  宣传视频/
  加载图/
  海报/
  构建产物/
  资质材料/
```

If the directory already has `audit-input.zh.yaml`, the script preserves it and only completes the fixed folder structure. If it has no YAML, the script creates one from the concentrated package template.

The concentrated package YAML comes from:

```text
assets/audit-package-input.zh.yaml
```

Use the path-based Chinese YAML template only when the user insists on manually filling every path:

```text
assets/audit-input.zh.yaml
```

The YAML template includes:

- Explicit local path fields such as `图标路径`, `截图路径列表`, `视频封面路径列表`, `宣传视频路径列表`, `资料包目录路径`, and `工程项目目录路径`.
- Copywriting guidance, including short description length hints and a 120-300 character detailed description hint.
- Required ability fields, including `是否接入侧边栏复访能力`.
- Official option references for game category, theme, art style, and age rating.
- Inline hints such as `参考下方：官方选项参考 > 题材可选` for fields that should be selected from official options.

Recommended saved location for a real project:

```text
<资料包目录>/.douyin-minigame-audit/projects/<项目名称>/audit-input.yaml
```

On later audits, you can say `继续` or provide a project nickname. The skill will look for saved audit input/state under `.douyin-minigame-audit/projects/` first, then legacy `.douyin-minigame-audit/`.

If some compliance materials belong to legal, operations, business, finance, or publishing teams, leave them blank and list them under `待补资料`. The report will separate missing materials from the judgment on already provided content.

To save an input manually:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\save-audit-input.ps1 -InputFile audit-input.yaml -ProjectName "游戏名称" -ProjectAliases "简称,AppID"
```

## Every Trigger Update Check

The skill includes:

```powershell
scripts/check-update.ps1
```

On every trigger, the skill checks GitHub for a newer `VERSION`. If an update is installed, restart Codex or the current AI client. After restarting, return to the conversation and say `继续` to resume the unfinished audit flow from the saved input/state.

## Package a Release

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\package-release.ps1
```

The zip is generated under:

```text
release/douyin-minigame-audit-v<VERSION>.zip
```

Upload that zip to GitHub Releases.

## License

MIT License. See `LICENSE`.
