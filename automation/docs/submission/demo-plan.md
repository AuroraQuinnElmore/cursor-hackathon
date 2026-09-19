DEMO PLAN: WOW MOMENTS MAPPED TO THE RUBRIC (12:52)

THE "NOT ALREADY SOLVED" ANSWER (say it early, once, plainly)
Judges will think of two existing categories. Name them yourself before they do:
- Robotic process automation (RPA) recorders: an engineer builds each bot, and it breaks when a screen changes.
- AI browser agents: an AI "clicks around" live every time. Slow, costly per run, and it guesses.
Our difference, all of it true of what's running today:
1. Learn once, then run a TESTED TOOL. Mary shows it once; it becomes a command-line tool that runs the same way every time. No AI guessing per click, and no AI key needed to run it.
2. Every write is PROVEN. After each save it re-opens the record and checks it: 41 of 41 steps confirmed on 10 referrals. Browser agents report "done"; we show the proof.
3. It REFUSES TO GUESS. A missing member ID or a malformed one is held for Mary; an existing patient is caught as a duplicate.
4. Mary KEEPS it. One setup prompt hands the tool to her own AI (Cursor), the way Composio connects apps, but for software with no API she can use.
One line to use:
"Browser agents guess every click. We learn it once, turn it into a tested tool, and prove every write."

5 WOW MOMENTS, in demo order (rubric points in brackets)
W1. THE PILE (Insight, Usability). Drop in 13 referral faxes. Before anything is typed, the triage summary: "4 urgent, moved to the front · 1 is already a patient · 2 need you: a missing member ID and a malformed one." That's non-obvious, useful output in 5 seconds.
W2. WATCH IT WORK (Completeness, Performance). A visible browser flies through OpenEMR entering a referral: patient, insurance, fax attached, appointment. The stopwatch runs: "Mary by hand: ~3.5 min each · AI: ~1 min each · 10 referrals: ~35 min → ~10 min, while she does something else." Use the REAL numbers from the run; your recorded time replaces the estimate.
W3. BREAK IT ON PURPOSE (Technical Depth). Mid-run, force a logout. The login window pops up, Mary logs in herself, and the run picks up where it stopped. That shows real engineering, not a wrapper. Rehearse it before showing it.
W4. THE PROOF (Insight, Usability, and trust). Open Mary's review page: each referral's fax next to what OpenEMR saved, side by side, each ✓ with a link that opens the real chart. Click one. Then show the 2 held referrals: "it asked instead of guessing."
W5. MARY'S AI TAKES OVER (Creativity, the Cursor rule). Paste the setup prompt into Cursor's chat: "process referral-07". Cursor runs the tool and reports each verified step. Close on: "Mary didn't write code. She showed it once."

LIVE DEMO (top 3 only; aim ~3 min)
0:00 Hook + the not-already-solved line (20s)
0:20 W1: the pile → triage (20s)
0:40 W2: ONE referral live in the visible browser (~80s, narrated over it). Run the other 9 BEFORE going on stage; don't wait on stage.
2:00 W4: the review page for the full batch; click one chart link; show the held pair (30s)
2:30 W5: Cursor processes one more (only if it's reliable in rehearsal; otherwise show a recorded clip) (30s)
Skip W3 live unless it has worked 3 times in rehearsal. Put it in the Loom instead.

LOOM (required; follow their recommended flow, camera ON, 3:30–4:30, under 5:00)
0:00–0:30 Team intro: each person, role, what they built (name the tools honestly: Cursor for the app, Claude Code helpers for the automation pieces)
0:30–1:00 Pitch: Mary, the fax pile, "software with no API she can use", and the not-already-solved line
1:00–3:00 Live demo, minimal cuts, server console log visible: W1 → W2 (cut the waiting between referrals, which they allow) → W3 → W4
3:00–3:45 How it's built: pipeline diagram (PDF reading → triage → OpenEMR tool → re-read check → report); challenges solved (OpenEMR's nested frames, the insurance form's widgets, date-picker traps, session expiry); Supabase/Apify only if live by then
3:45–4:15 W5 (Cursor), then the "so what": front desks retype thousands of faxes; next steps: AI reading for any fax layout, learning from YouTube tutorials, any browser app

GUARDRAILS (so nothing on stage is overclaimed)
- Say "reads these referral faxes", not "any fax". The reader is rule-based for 3 layouts.
- Timing: use measured numbers only. Mary's time comes from your real recording, or say "about".
- "Learns from a video / recording": the recorder and recording→steps work (scripted test 12/12), but no human recording has been scored yet. Do the full referral recording, or describe it as "records Mary's clicks" without a score.
- Say Mary types her own password. That's now true on the demo server.
