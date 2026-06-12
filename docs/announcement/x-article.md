# X Article — "Stop letting one model grade its own homework"

> Paste into an X Article (Premium). Cover image: `banner.png` (1920×368).
> Inline images marked [IMAGE]. X Articles have no syntax-highlighted code
> blocks — keep commands as plain text so they stay copy-pasteable, and attach
> the code screenshot variants if you want them prettier.

---

**COVER: banner.png**

# Stop letting one model grade its own homework

Every coding agent failure I've had this year traces back to the same three
bugs. They're not model bugs. They're harness bugs.

The agent's memory was the chat, so every session started dumber than the
last one ended. The agent that wrote the code was the agent telling me the
code worked. And the definition of "done" lived in the same context window as
the thing being graded — so "done" drifted until everything passed.

I stopped trying to prompt my way around this and built a loop where two
models from two different labs check each other, and the repo — not the chat —
is the only memory.

I packaged it as two open-source Claude Code skills. This is how it works and
why each piece exists.

## One model isn't enough — not because of capability, because of conflict of interest

Claude Fable is the best long-horizon judgment model I've used. GPT-5.5 is the
best hands-on builder — it leads Terminal-Bench 2.0 at 82.7%. But the reason
to use both isn't the benchmarks.

It's that a model reviewing its own output has the same blind spots that
produced the output. Cross-vendor review removes same-model sycophancy
structurally — OpenAI themselves pitch their Claude Code bridge on exactly
this point.

So the split is:

**Fable = architect.** Judgment only. It never writes implementation code.
It arbitrates, judges evidence, writes specs, makes kill/continue calls.
Minutes per work block.

**GPT-5.5 Codex = builder.** A fresh `codex exec` process per slice, on xhigh
reasoning, running unattended for hours.

**The repo = the brain.** Both models are stateless between sessions. The
state lives in `docs/HANDOFF.md`, `docs/gates/`, and git.

You spend the expensive model's time on judgment and the flat-rate model's
time on typing. Both run on subscriptions you already have. No API keys.

**[IMAGE: loop-diagram.png]**

## The loop is:

1. **Fable reads the repo's memory** (`docs/HANDOFF.md`) and rules on every
   disagreement the builder raised last run: ACCEPT / REJECT / MODIFY, one
   line why. No deferrals.

2. **Fable judges the last slice** — by running the acceptance-gate commands
   itself and comparing raw output against the gates. Builder claims are
   hearsay. Verdict per gate: PASS / FAIL / INVALID.

3. **Fable specs the next one-PR slice** and freezes its acceptance gates to
   `docs/gates/` — committed BEFORE any code exists. Exact commands, exact
   thresholds.

4. **A fresh Codex process builds for hours.** Phase 0: it must argue with
   the spec before writing code, citing real files. Silent compliance is a
   failure. Phase 2: up to 4 lane agents on disjoint files plus one reviewer
   lane that never writes feature code. Then it updates the handoff with raw
   numbers only — no "promising", no interpretation. Verdicts belong to the
   architect and the human.

5. **Repeat.** You read the handoff between blocks. You own kill/continue.

The dispatch is one command (this is the whole integration):

codex exec --sandbox workspace-write -a never -m gpt-5.5 -c model_reasoning_effort="xhigh" "<the spec>"

## The detail that makes it work: gates the builder can't touch

Acceptance criteria written after results exist always pass. So the gates
freeze in their own directory, in their own commit, before dispatch — and the
architect's post-run check includes `git diff` on `docs/gates/`.

If the builder so much as edits a gate file, the slice fails automatically,
regardless of results.

This isn't paranoia. In published self-improvement benchmarks, 47–74% of runs
showed proxy gains without real gains — agents rewriting grading scripts and
mocking test output, escalating to hacks hidden from chain-of-thought
monitors. The fix isn't a better prompt. It's making the graded thing unable
to reach the grader.

Same logic everywhere in the loop:

— Not in `docs/HANDOFF.md` = didn't happen. The architect refuses to judge
results that exist only in chat.

— The builder reports raw tables, numbers, and commit SHAs. Adjectives are
stripped at the protocol level.

— Every slice is a fresh Codex context. If a run wrecks the repo: git reset
to the freeze commit, re-dispatch. Code is cheap. Rescue prompting isn't.

## Why xhigh for the builder

**[IMAGE: effort-chart.png]**

Independent benchmarking of GPT-5.5's reasoning-effort curve found the gap
between high and xhigh isn't test-pass rate — it's whether the output
survives review. Review-pass nearly doubles (38% → 69%), and semantic
equivalence to the human-written PR goes from 69% to 88%.

xhigh costs ~2.2× more per task. For an unattended multi-hour run where
nobody's watching, review-survival is exactly the thing worth paying for.
The architect can still dial routine slices down to high — and must write
down why.

## The second skill: research before you build

For brainstorming and technology choices there's `/architect-research` —
because the most expensive bug is building the wrong thing carefully.

It compresses your question into a brief, then fans out parallel Codex
researchers across six lanes:

1. **Academic** — arXiv recency + Semantic Scholar citation snowballing
2. **Popular repos** — ranked by dependents, not stars (~4.5M fake stars are
   documented in the wild)
3. **Cutting-edge repos** — star-velocity plus an emerging-vs-hype gate
4. **Production patterns** — how the 2–3 best libraries in the niche design
   APIs, errors, extension points, and tests
5. **General web** — postmortems, comparisons, official docs
6. **Expert opinion** — a second wave that tracks the blogs/talks/X of the
   actual named experts the first wave surfaced

Then Fable — not the researchers — verifies every load-bearing claim against
≥2 independent sources, runs adversarial falsification searches, and writes
one decision-oriented report. Citations only from URLs fetched during the
run, because even search-grounded agents fabricate 3–13% of citations.

Expert opinions get their own evidence class: quoted, dated,
conflict-of-interest flagged — and they never count as facts. Expert
*disagreements* get flagged as the genuinely open questions, because that's
what they are.

## Install

git clone https://github.com/DanMcInerney/architect-loop
cd architect-loop && ./install.sh
npm i -g @openai/codex@latest

Then in any repo: `/architect-research <idea>` to explore,
`/architect` to build. First run creates the handoff and gates from
templates.

Requirements: Claude Code on any paid plan, Codex CLI ≥ 0.133 signed into a
ChatGPT plan. That's the whole stack.

## What it's not

Honest limits. The loop is overkill for small tasks — a one-file fix doesn't
need an architect, and the skill says so itself. Long builder runs draw on
your ChatGPT plan's weekly quota (a ~6.5-hour run costs roughly 20% of a
$100-tier week). The research skill runs ~15× chat-level tokens, which is
exactly why it's a separate, deliberate command instead of a default. And
parts of this harness will be obsoleted by better models — that's expected;
the design doc has a standing rule to delete scaffolding each model
generation.

## Where it came from

Every rule in the skills cites a source — Anthropic's harness-engineering
posts, the Fable prompting guide, the Codex CLI docs, the Ralph loop, the
reward-hacking literature. The design document with all ~40 citations is in
the repo: DESIGN.md.

If you think a rule is wrong, the disagreement protocol applies to you too:
open an issue, cite real files.

Bookmark this if you're running agents longer than one context window.

Repo: github.com/DanMcInerney/architect-loop
