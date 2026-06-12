# Launcher post (single long post, NOT a thread — link-free main post)

> Post this, attach `loop-diagram.png`, and quote/attach the X Article.
> Repo link goes in the FIRST REPLY (X penalizes external links 50–90% in
> the main post). Chart goes in the second reply.

---

Stop letting one model grade its own homework.

I run two now: Claude Fable as the architect, GPT-5.5 Codex as the builder.
Different labs. Neither trusts the other. The repo is the only memory.

Packaged it as two open-source Claude Code skills. The loop is:

1. Fable specs a one-PR slice and freezes the acceptance gates in the repo — committed BEFORE any code exists
2. A fresh Codex process builds for hours on xhigh. It must argue with the spec before writing code. Silent compliance = failure
3. Fable runs the gates itself and judges raw numbers. Builder claims are hearsay
4. Not in docs/HANDOFF.md = didn't happen
5. Repeat. Minutes of judgment per block, hours of unattended building

If the builder so much as edits a gate file, git diff catches it and the slice auto-fails. Goalpost-moving is structurally impossible, not discouraged.

Both halves run on the subscriptions you already have. No API keys, no token bills.

Full writeup in the article below. Repo in the first reply.

---

# First reply

The repo (MIT, install in 30 seconds):

github.com/DanMcInerney/architect-loop

git clone https://github.com/DanMcInerney/architect-loop
cd architect-loop && ./install.sh
npm i -g @openai/codex@latest

Then /architect-research to explore an idea, /architect to build it.

---

# Second reply (attach effort-chart.png)

Why the builder runs on xhigh: the gap vs high isn't test-pass — it's
surviving review. Review-pass 38% → 69%, match-the-human-PR 69% → 88%, at
~2.2× cost. For unattended multi-hour runs, review-survival is the thing
worth paying for.

---

# 24–48h follow-up (quote-tweet the launcher)

Update: ran the loop on [project] overnight — [N] slices, [N] gates passed,
zero gate-file tampering flagged, one builder disagreement that was right
(it caught [thing] in the spec).

The disagreement protocol is the underrated half of this.
