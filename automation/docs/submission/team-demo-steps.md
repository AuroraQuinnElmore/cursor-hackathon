TEAM DEMO: STEP BY STEP (~6 min). All agents are held off the server until you're done.
Uses the TESTING copy of OpenEMR (the /a/ copy stays clean for the real stage run), and referral-02 with "-TEAM" added to the name so it doesn't clash with earlier tests.
Open TWO terminal windows side by side. Paste one line at a time.

STEP 0: SHOW THE LIVE LOG (terminal 1; leave it running; this is the "console logs" the judges want to see)
tail -f ~/hackathon-2026-09-19/automation-server/server.log

STEP 1: THE PILE. Show the input faxes (terminal 2). Open one so the team sees a real referral:
open ~/hackathon-2026-09-19/referrals/referral-02.pdf
Say: "Mary gets a stack of these every day and retypes each one into OpenEMR."

STEP 2: TRIAGE, before anything is typed (the result from the clean demo copy). This opens a short plain-English summary:
open -a TextEdit ~/hackathon-2026-09-19/triage/needs-mary-demo-copy.md
Say: "Before touching anything, it checked 13 faxes: 4 urgent ones go first, and 3 are held for Mary: one is already a patient, one is missing its member ID, one has a member ID in the wrong format. It asks instead of guessing."

STEP 3: MARY LOGS IN HERSELF (a window pops up; type admin / pass)
curl -s -X POST localhost:4710/login -H 'content-type: application/json' -d '{"site":"main"}'
Say: "We never see her password. If the session expires mid-run, this window pops up again and the work continues."

STEP 4: WATCH IT WORK. A visible browser, slowed down so everyone can follow (~2–3 min):
curl -s -X POST localhost:4710/intake -H 'content-type: application/json' -d '{"site":"main","pdfs":["referral-02.pdf"],"suffix":"TEAM","headed":true,"slowmo":900}'
Say, while it runs: "It read the fax, created the patient, typed the insurance, attached the fax and booked the visit. After EVERY save it re-opens the record to prove it stuck." Point at terminal 1: each step prints as it happens.

STEP 5: THE PROOF. Mary's review page:
open http://localhost:4710/review/latest
Show: the fax link and the fields read from it; expected vs. saved, all ✓; click "Patient chart" to open the real record; the "Looks right" button.

STEP 6: THE SPEED STORY. Full batch report from earlier (10 referrals, 41/41 steps confirmed):
open http://localhost:4710/report/latest

If step 4 prints "login needed", redo step 3. If it prints "busy", wait 30 seconds and retry.
When you're done, reply "demo done" and I'll release the agents.
