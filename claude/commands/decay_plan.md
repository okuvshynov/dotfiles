# Keep the Plan Decayed

**Core principle: the amount of detail in a section should be inversely proportional to its uncertainty.** Work near the present is described precisely; work far in the future gets a single line.

## Plan structure

A project plan has four kinds of content:

1. **High-level goal** — an executive summary. A few sentences on what we're building and why.
2. **Rules / invariants** — constraints that must hold throughout. For example: all tests must pass, test coverage above 99%, relative error below 1e-5, don't use libraries X, Y, Z. If this list grows long, move it to a separate document and link to it.
3. **Steps**, in order, each tagged `Done`, `In progress`, or `Planned`.
4. **Links out** — commits, PRs, design docs, and notes that hold detail the plan itself shouldn't carry.

## How much detail each step gets

| Status | Detail level |
|---|---|
| **Done** | One or two lines. Link to commit IDs or external docs for anything more. The information needs to exist somewhere — just not cluttering the active plan. |
| **In progress** | The most detailed section in the plan. Current findings, sub-steps, open questions, blockers. |
| **Planned (next up)** | Fairly detailed, and expected to change. Revise it as the in-progress step reveals new information. |
| **Planned (distant)** | A single line. |

Example: if we're working on step 4, then step 5 should be reasonably fleshed out and updated regularly, while step 10 is one line.

## Why

Giving every step the same level of detail is both **misleading** and **wasteful**. It projects false confidence about step 10, which carries far more uncertainty than step 5 and will likely change before we reach it — so the detail written today gets thrown away tomorrow.

## Maintenance

Each time a step completes:

- Collapse it into a short `Done` summary with links.
- Expand the next step into full `In progress` detail.
- Sketch out the step after that.

The plan should decay behind you as it sharpens ahead of you.
