# Write-up

Mary runs the front desk on software from 2005 with no API. She records one video of her morning routine. Ninety seconds later, her AI does it for her — and shows its work.

## Problem
Front-desk and back-office staff spend hours each week repeating the same clicks in browser-based tools that have no API the user can actually use (it's switched off, locked behind IT, or doesn't exist). AI assistants could do this work, but only if someone builds an integration, and for older or niche software nobody will.

## Who it helps
People like Mary: receptionists, schedulers, and office staff who know their workflow by heart but do not write code. It also helps the small practices and offices that employ them and cannot pay for custom integrations.

## Solution
Mary gives the app two things: the URL of the tool she uses and one screen recording of her doing the task. The app summarizes the workflow in a few bullets and asks her to confirm them. She logs in herself. The app generates browser-automation CLI commands for each step, tests them against the real site, and produces a report that links every step to its real input and output, marked Confirmed or Hypothesis. Last, it gives her a setup prompt to paste into her own AI, which installs the commands, saves the workflow as a skill, runs a dry run, and asks before any write action. Our demo uses the OpenEMR public demo: register a new patient, then book a follow-up.

## Impact
A task Mary does every day becomes something her AI can do, without API access or an engineering project. Because each step is tested and shown with evidence, she can check the work instead of trusting it blindly. The same approach applies to any tool that runs in a browser.

Word count: 296 (body text, excluding headings and this line)
