---
name: consolidate
description: Consolidate an exploratory MVP codebase into a clean, maintainable state. Use after a project reaches MVP to remove dead code, simplify over-engineering, prune stale docs and tasks, and fix terminology drift — incrementally, on a branch, one reviewable and always-working step at a time.
disable-model-invocation: true
---

# Consolidate exploratory code into a clean MVP

This project was built in **exploration mode**: many tasks and branches,
experimental code and documents, and uneven review (velocity was prioritized
over robustness). Expect some code to be over-engineered with unnecessary
abstractions, and other code to lack the extensibility it now needs.

The project has reached an MVP we want to keep. Your job is to raise its
quality **without changing what it does**.

## Operating rules (apply to every step)

- Work on a **new branch**, never directly on the main line.
- Make changes in **small, ordered steps**. Each step is one commit (or PR)
  that can be reviewed on its own.
- **Every step must leave the project working** — it builds, runs, and passes
  the existing tests.
- Preserve MVP behavior. If a change would alter functionality, **stop and
  flag it** instead of deciding unilaterally.

## Step 1 — Map the current state (no code changes yet)

Write a short, concrete picture of:
- What the code actually does, module by module.
- Which functionality is MVP vs. experimental or unused.
- Candidates for removal, simplification, or extension — with reasons.

Share this map and get confirmation before touching code.

## Step 2 — Remove dead code

Delete unreferenced code, unused files, abandoned experiments, and anything
outside the MVP. One reviewable step per coherent chunk.

## Step 3 — Simplify over-engineering

Collapse unnecessary abstractions and indirection down to what the MVP
actually needs. Keep each change behavior-preserving.

## Step 4 — Add extensibility where it's now needed

For code that was built rigidly but now needs to flex, introduce the
**minimum** abstraction required. No speculative generality.

## Step 5 — Clean up tasks, docs, and notes

Remove or archive stale tasks, experimental documents, and outdated notes.
Keep only what reflects the current MVP.

## Step 6 — Fix terminology drift

Check that names — in code, docs, and UI — still match what things actually
are. Where reality has moved on, rename consistently across the whole
codebase in a single self-contained step.

## When done

Summarize the branch: the steps taken, what was removed or changed, and
anything you flagged but deliberately left untouched.