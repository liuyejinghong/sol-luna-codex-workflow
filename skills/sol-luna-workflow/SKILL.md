---
name: sol-luna-workflow
description: Use when a Sol main thread can delegate a clearly bounded, independently completable task to the named Luna Max worker. Defines the handoff, ownership, verification, and stop boundaries without re-running general model-tier selection.
---

# Sol lead, Luna Max workers

Use this skill as a small orchestration overlay. Explicit user instructions, permissions, project `AGENTS.md` files, and current verified facts remain authoritative.

This workflow is a user-chosen routing policy, not a per-task model benchmark. Do not invoke another tier-routing skill, compare Luna Medium or Terra, or request fresh approval for the default topology each time an eligible task appears.

## Default topology

- Keep Sol in the main thread.
- Sol understands the goal, defines boundaries, splits work, reviews results, resolves conflicts, and owns the final answer.
- Prefer the named `luna_worker` for clearly scoped code review, module analysis, independent implementation, focused test diagnosis, and other objectively checkable work.
- Luna Max is the preferred worker lane for this workflow. Do not silently replace it with Luna Medium or another model.
- Treat the observed cost/performance of Luna Max as a routing policy for bounded execution, not as a universal model-quality guarantee. Keep ambiguous judgment with Sol.
- When the packet meets the delegation contract, dispatch `luna_worker` directly. Do not pause for a new model comparison or cost justification.
- A worker handoff is evidence for Sol to inspect, not the final project decision.

## Sol task decomposition

Sol owns decomposition. Split work at independently verifiable outcome boundaries, not by arbitrary file counts, module names, or a desire to create workers.

1. Lock the parent contract: final objective, invariant facts, minimum acceptance criteria, and authorization boundary.
2. Separate global decisions from execution. Keep ambiguity, architecture, priorities, tradeoffs, and cross-task integration with Sol.
3. Form a candidate worker unit around one observable outcome. It must be completable from compact context, have explicit and non-overlapping ownership, and be reviewable without redefining the parent goal.
4. Apply the independence test: can `luna_worker` finish, verify, or return a precise blocker without discovering its own scope or changing another task's state? If not, keep the work with Sol, refine the boundary, or run it sequentially.
5. Write one worker packet for each accepted unit and dispatch the named worker. Do not ask Luna to perform the decomposition that Sol has not completed.
6. On return, compare the evidence with the parent acceptance criteria, resolve conflicts across units, and integrate the result. Luna's report never replaces Sol's final judgment.

The decomposition rule is therefore:

```text
ambiguous, coupled, shared-state, or decision-heavy -> Sol
bounded, independent, objectively checkable execution -> luna_worker (Luna Max)
```

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
- release, production, account, permission, or other external mutations unless the user explicitly delegates and authorizes that exact action;
- integration and final reporting.

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

For read-only work, say so explicitly. For implementation, identify writable paths. If the task cannot be completed inside the packet, the worker returns the exact blocker instead of widening scope.

## First-principles verification

Code, tests, and toolchains must all serve the delegated outcome. Before adding a test, gate, dry run, reviewer, or tool, answer:

1. What concrete irreversible risk does it protect?
2. What decision changes if it fails?
3. Why is the existing cheaper evidence insufficient?

Default to one focused contract check plus one real-path result check. Do not repeat the same validation when the candidate and relevant facts have not changed.

If verification costs more than implementation, or two consecutive steps only repair validation or tooling without adding facts about the original objective, stop expanding the toolchain and return to the root problem. Report any remaining risk instead of manufacturing a new validation system.

## Parallelism

- Parallelism is optional, not a target.
- Use it only for independent scopes with disjoint write ownership.
- Start with at most two workers unless the user explicitly requests a larger fan-out.
- Never let workers delegate further.
- If two tasks need the same mutable files or state, run them sequentially.

## Route integrity

Dispatch the named `luna_worker`, not a generic worker. Its custom-agent file pins `gpt-5.6-luna` with `max` effort. Verify that route once after installation and again only after a major Codex client change or observed routing mismatch. Prompt steering or a textual self-report is not proof of the effective route.
