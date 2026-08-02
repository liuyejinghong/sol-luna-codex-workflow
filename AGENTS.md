# Installation contract

This repository is designed to be handed directly to a Codex Agent for installation.

## Objective

Install the checked-in `luna_worker` custom agent and `sol-luna-workflow` skill for the current user while preserving every unrelated Codex setting.

This package is self-contained. It does not depend on `gpt-5-6-best-practice` or another model-tier routing skill.

## Authorized writes

The installation may create only these targets under the active Codex home:

```text
agents/luna-worker.toml
skills/sol-luna-workflow/SKILL.md
```

Use `$CODEX_HOME` when it is set; otherwise use `$HOME/.codex`. Run `bash scripts/install.sh` from this repository. Do not reproduce the copy logic with broader commands.

## Prohibited changes

Do not edit or delete `config.toml`, other agents, other skills, global or project `AGENTS.md` files, Codex App personalization, or any unrelated content.

Do not install or invoke `gpt-5-6-best-practice` as part of this workflow. If a legacy copy exists, report it without modifying it; removal requires separate user authorization.

If either target already exists with different content, stop without writing either target. Show the exact conflicting path and ask the user how to proceed. Never overwrite a conflict automatically.

## Verification and handoff

After installation, confirm that both installed files exactly match the repository sources. Parse the TOML when a standard TOML parser is available. Do not create a larger validation toolchain for this two-file copy.

Tell the user that `personalization.md` does not activate itself. They must manually copy one complete language block into Codex App Settings → Personalization → Custom Instructions when they want App-level personalization. Suggest starting a new task. A full restart is normally unnecessary; reopen Codex only if the newly added custom agent is not discovered.

Report installed paths, unchanged paths, verification results, conflicts if any, and the remaining manual personalization step.
