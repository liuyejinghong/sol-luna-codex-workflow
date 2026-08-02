# Sol + Luna workflow for Codex

Keep **GPT-5.6 Sol** in the main thread as the lead. Use a named **Luna Max**
worker for bounded, independently completable tasks. Sol remains responsible for
decomposition, review, integration, and the final answer.

[简体中文](README.zh-CN.md)

```text
Sol lead: understand -> split -> delegate -> review -> integrate
                                  |
                                  v
Luna Max worker: review / analyze / implement / diagnose tests
```

This is a community workflow, not an official OpenAI preset. Custom-agent routing
and model availability can vary by Codex client, version, and account. Verify the
effective worker model after installation instead of relying on prompt text alone.

Compatibility snapshot: the checked-in TOML structure was validated against the
official Codex custom-agent documentation and configuration schema on 2026-08-02.
Model access and effective runtime permissions remain client- and account-dependent.

## Why this shape

- Sol keeps the full objective, tradeoffs, and final decision in one place.
- Luna receives a compact execution package and returns a concise handoff.
- Independent worker context keeps exploration and test output out of the main thread.
- Parallel workers are optional and only safe with independent scopes and disjoint writes.

## Install

Clone this repository, then copy the agent and skill into your global Codex config:

```bash
mkdir -p ~/.codex/agents ~/.codex/skills/sol-luna-workflow
cp agents/luna-worker.toml ~/.codex/agents/luna-worker.toml
cp skills/sol-luna-workflow/SKILL.md ~/.codex/skills/sol-luna-workflow/SKILL.md
```

Copy the English or Chinese block from [`personalization.md`](personalization.md)
into Codex **Settings -> Personalization -> Custom instructions**.

Start a new task for the cleanest test. A full app restart is normally unnecessary
for personalization changes. If a newly added custom agent is not discovered, reopen
Codex and test again.

## What to delegate

Good worker tasks:

- scoped code review;
- module or dependency analysis;
- an implementation with explicit owned paths;
- focused test failure diagnosis;
- inventories, extraction, transformation, or documentation with an objective check.

Keep these with Sol:

- changing the overall objective or architecture;
- prioritization and final tradeoffs;
- sequential or shared-state work;
- overlapping writes;
- release, production, account, or other external mutations unless explicitly authorized.

## Delegation packet

Give the worker only what it needs:

```text
Objective:
Scope and owned paths:
Relevant facts:
Non-goals:
Acceptance criteria:
Verification:
Stop condition:
Return format:
```

Sol should inspect the result and integrate it. Do not treat a worker handoff as the
final project decision.

## Optional Fast mode

The checked-in profile does not enable Fast mode. To prefer lower latency, add:

```toml
service_tier = "fast"
```

Fast mode may consume credits or cost at a premium and may not be available on every
surface. It is a latency choice, not a guaranteed cost-saving choice.

## Verify once

Use a small, read-only task with an obvious expected result. Ask Sol to delegate it to
`luna_worker`, then inspect the subagent card or runtime metadata, when available, for:

- model: `gpt-5.6-luna`;
- reasoning effort: `max`;
- the expected bounded result;
- no unrelated file writes.

Do not accept a model's textual self-report as proof of the effective route. Repeat
this check after a major Codex client update or when routing behavior changes. Parent
turn permission overrides may still constrain a custom agent's configured sandbox.

## Official references

- [Codex subagents](https://developers.openai.com/codex/agent-configuration/subagents)
- [GPT-5.6 model guidance](https://developers.openai.com/api/docs/guides/latest-model)
- [Fast mode](https://developers.openai.com/api/docs/guides/fast-mode)
- [Codex configuration schema](https://developers.openai.com/codex/config-schema.json)
