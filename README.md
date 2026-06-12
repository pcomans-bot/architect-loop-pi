# architect-loop

**Claude Fable 5 as architect. GPT-5.5 Codex as builder. The repo as the only
memory.** A Claude Code skill that runs the cross-vendor architect/builder loop
on flat-rate subscriptions — judgment minutes on the expensive model, typing
hours on the fast one.

```
 Claude Fable (architect, effort: high)        GPT-5.5 via codex exec (builder, xhigh)
 ─────────────────────────────────────         ─────────────────────────────────────
 0 ground in the repo's own docs        ──►    PHASE 0  plan + MANDATORY disagreements
 1 rule on every disagreement                  PHASE 1  freeze contracts in docs/
 2 run the gates ITSELF, judge raw             PHASE 2  ≤3-4 disjoint lanes + 1
   evidence vs verbatim frozen gates                    reviewer lane, commit, push,
 3 spec next slice; freeze gates to            update docs/HANDOFF.md with RAW
   docs/gates/ BEFORE dispatch                 results only
 4 dispatch fresh codex exec, async     ◄──
 5 post-flight: handoff updated? gates
   untouched (git diff)? disagreements
   raised?
                  └────── docs/HANDOFF.md + docs/gates/ + git ──────┘
                              the repo remembers everything
```

## Why this shape

Every serious source on agent harnesses converged on the same four moves:
separate planning context from execution context; persist state in the repo,
not the conversation; dispatch fresh-context workers per task; verify with an
agent that didn't write the code. This skill adds cross-vendor judgment on top —
the builder and the judge are different models from different labs, which kills
same-model sycophancy in review and puts each model where it measurably wins.

**[DESIGN.md](DESIGN.md) is the full design document** — twelve rules, each with
its mechanical enforcement and its citation (Anthropic engineering posts, the
Fable 5 prompting guide, verified Codex CLI docs, superpowers, the Ralph loop,
the reward-hacking literature).

## Requirements

- [Claude Code](https://claude.com/claude-code) on any paid plan (the architect)
- [Codex CLI](https://developers.openai.com/codex/cli) ≥ 0.133 signed into a
  ChatGPT plan (the builder): `npm i -g @openai/codex@latest`

No API keys required. Both halves run on flat-rate subscriptions.

## Install

```powershell
# Windows
.\install.ps1            # global (~/.claude/skills) — works in every repo
.\install.ps1 -Project   # this repo only (.claude/skills)
```

```bash
# macOS / Linux
./install.sh             # global
./install.sh --project   # this repo only
```

Or just copy `skills/architect/` into `~/.claude/skills/architect/`.

## Use

One architect session per work block:

```
/architect
```

First run in a repo creates `docs/HANDOFF.md` and `docs/gates/` from the
template. Every run after that: rules on the builder's open disagreements,
judges the last slice's raw results against the frozen gates (running the gate
commands itself — builder claims are hearsay), optionally fans out parallel
`codex exec --search` web-research subagents and distills their cited findings
into a PRD (only when the slice touches APIs/tech new to the repo, or you ask:
`/architect research: <question>`), specs the next one-PR slice,
freezes its gates with a commit, and dispatches a fresh
`codex exec --sandbox workspace-write -a never -m gpt-5.5 -c
model_reasoning_effort="xhigh"` run in the background. Prefer to babysit the
run yourself? It prints the builder block for an interactive `codex` session
with `/goal`.

Judgment on a slice always happens in a *later* architect session than the one
that dispatched it. You sit between work blocks — that's where kill/continue
authority lives.

## Discovery research: `/architect-research`

Brainstorming what to build, picking a technology, or surveying the state of
the art is a separate, deliberately-invoked skill (research-grade fan-out costs
~15× chat tokens — it should never be a side-effect):

```
/architect-research <topic or question>
```

It compresses your question into a research brief, fans out parallel
`codex exec --search` researchers across six lanes — **latest academic papers**
(arXiv recency + citation snowballing), **most popular repos** (dependents
evidence, fake-star checks), **cutting-edge repos** (velocity + the
emerging-vs-hype gate), **design patterns from production-grade libraries**
(the four-category pattern-mining procedure), **general web**, and a
second-wave **expert-opinion lane** (the blogs/talks/X of the field's named
experts, roster-seeded from the first wave; opinions reported as dated,
conflict-flagged positions, never as facts) — then
verifies load-bearing claims against ≥2 independent sources (VERIFIED /
UNVERIFIED / DISPUTED / SUSPICIOUS), runs adversarial falsification searches,
and writes a decision-oriented report to `docs/research/<topic>.md`: answer
first, confidence per claim, "what would change this conclusion", open
questions. That report feeds `/architect`'s PRD when you're ready to build.

## The rules that make it work

1. Not in `docs/HANDOFF.md` = didn't happen.
2. Gates freeze in `docs/gates/` **before** results exist; a builder edit to a
   gate file (caught by `git diff`) fails the slice automatically.
3. Nobody grades their own work — raw results from the builder, gates run by
   the architect, cross-model review for high-stakes slices.
4. Disagreement is mandatory; silent compliance is a defect.
5. Fresh builder context per slice; when a run breaks the repo, reset and
   re-dispatch — code is cheap, rescue prompting isn't.

## What's in the box

| File | Purpose |
|------|---------|
| [DESIGN.md](DESIGN.md) | The research-backed design: 12 rules, failure-mode table, sources |
| [skills/architect/SKILL.md](skills/architect/SKILL.md) | The architect role: hard rules + the 6-step procedure |
| [skills/architect/dispatch.md](skills/architect/dispatch.md) | Verified `codex exec` commands + the PHASE 0/1/2 builder block |
| [skills/architect/research.md](skills/architect/research.md) | Slice-scale inline research fan-out |
| [skills/architect/HANDOFF.template.md](skills/architect/HANDOFF.template.md) | The repo-memory file |
| [skills/architect-research/SKILL.md](skills/architect-research/SKILL.md) | Discovery research: scope → plan → five-lane fan-out → verify → synthesize |
| [skills/architect-research/lanes.md](skills/architect-research/lanes.md) | Per-lane researcher blocks with verified endpoints (arXiv, Semantic Scholar, deps.dev, HN Algolia…) |
| install.ps1 / install.sh | One-command install |

## License

MIT
