---
name: sol-luna-workflow
description: Use when choosing GPT-5.6 Sol or Luna, reasoning effort, Fast mode, or subagents. Keeps Sol in the main thread and routes bounded independent work to Luna Max.
---

# Sol lead, Luna Max workers

Use this skill as a small orchestration overlay. Explicit user instructions, permissions,
project `AGENTS.md` files, and current verified facts remain authoritative.

## Default topology

- Keep Sol in the main thread.
- Sol understands the goal, defines boundaries, splits work, reviews results, resolves
  conflicts, and owns the final answer.
- Prefer the named `luna_worker` for clearly scoped code review, module analysis,
  independent implementation, focused test diagnosis, and other objectively checkable
  work.
- Luna Max is the preferred worker lane for this workflow. Do not silently replace it
  with Luna Medium or another model.
- A worker handoff is evidence for Sol to inspect, not the final project decision.

## Delegate only when the work package has

- one bounded objective;
- compact, task-specific context;
- explicit scope and owned paths;
- clear non-goals and authorization boundaries;
- observable acceptance criteria;
- proportionate verification and a stop condition;
- a concise return contract.

Do not delegate a tiny task when the handoff costs more than doing it directly.

## Keep with Sol

- changing the overall objective, architecture, or priorities;
- ambiguous tradeoffs and final semantic judgment;
- sequential work or work that depends on shared mutable state;
- release, production, account, permission, or other external mutations unless the
  user explicitly delegates and authorizes that exact action;
- integration and final reporting.

## Parallelism

- Parallelism is optional, not a target.
- Use it only for independent scopes with disjoint write ownership.
- Start with at most two workers unless the user explicitly requests a larger fan-out.
- Never let workers delegate further.
- If two tasks need the same mutable files or state, run them sequentially.

## Worker packet

Send only the necessary facts in this shape:

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

For read-only work, say so explicitly. For implementation, identify writable paths.
If the task cannot be completed inside the packet, the worker returns the exact blocker
instead of widening scope.

## Fast mode and route verification

`service_tier = "fast"` is an optional latency tradeoff, not a guaranteed cost-saving
setting. Do not claim savings without comparable evidence from the active product.

After installing the custom agent, and after major Codex client changes, verify the
effective worker model and effort from runtime metadata when the client exposes it.
Prompt steering or a textual self-report is not proof that `gpt-5.6-luna` with `max`
was actually used. If the route cannot be verified, describe it as intended rather
than confirmed.
