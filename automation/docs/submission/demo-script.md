# Demo script: 90-second live pitch

Status: draft for Aurora to edit. This is the 90-second LIVE pitch. The 2:30–3:00 Loom video script is in loom-script.md. Anything in [TEAM FILLS] depends on the team's build or on a real test run. Do not say a number on stage until it has been measured.

Target workflow (Aurora still to confirm): Mary registers a new patient in OpenEMR, then books that patient's follow-up appointment.
Demo site: OpenEMR public demo, https://demo.openemr.io/openemr, logged in as receptionist. Every patient created uses the HACKDEMO- name prefix.

## 0:00–0:08 | Hook
On screen: title slide, then the OpenEMR login page.
Say:
Mary runs the front desk on software from 2005 with no API. She records one video of her morning routine. Ninety seconds later, her AI does it for her — and shows its work.

## 0:08–0:16 | Inputs
On screen: the app's start screen. Paste the OpenEMR URL. Drop in Mary's screen recording.
Say:
Mary gives us two things: the address of the tool she uses, and one recording of her doing the job by hand.

## 0:16–0:26 | Workflow summary, Mary confirms
On screen: the app shows a 3 to 5 bullet summary of the recording. Mary clicks Confirm.
Example bullets (replace with what the app actually produces [TEAM FILLS]):
- Log in to OpenEMR as the front desk user
- Register a new patient with name, sex, and date of birth
- Open the Calendar and book that patient's follow-up appointment
Say:
The app writes back what it thinks Mary does. She confirms it, or fixes a step before anything runs.

## 0:26–0:32 | Login
On screen: a login window opens on OpenEMR. Mary types her own username and password.
Say:
Mary logs in herself. The app never asks for her password in chat.

## 0:32–0:42 | Evidence: it reads the docs first
On screen: three cited facts, each with its source link:
- "In the default OpenEMR instance, those are: Name, Sex, DOB." (required fields for a new patient; OpenEMR 7 wiki, Search - Add Patient)
- Booking steps from the Calendar: click the provider, "Click on the time in the date column to open the appointment scheduler dialog", pick the category, pick the patient, Save. (OpenEMR wiki, 6.1-era workflow page, older than the 8.4.0 demo)
- The REST and FHIR APIs exist but an administrator has to "Enable OpenEMR Standard REST API" under Administration > Config > Connectors. (openemr GitHub, API_README.md)
Then one line: "Your setup differs from the default: [TEAM FILLS: the specific difference the app detected]"
Say:
Before writing anything, it read OpenEMR's docs. Here are three facts it used, each with its source. And it noticed where Mary's setup differs from the default.

## 0:42–0:52 | Build the commands, then test them
On screen: the app generates browser-automation CLI commands, one per step, then runs them against OpenEMR. A stopwatch is visible: manual time from Mary's video next to the AI's time.
Say:
It turns each step into a command and tests every one on the real site. Mary took [TEAM FILLS: manual time, measured from the video]. The AI took [TEAM FILLS: measured AI time].

## 0:52–1:04 | Test report
On screen: the test report. Each step links to its real input and output (screenshot or page capture) and is marked:
- Confirmed ✓ — the command ran and we can show the result
- Hypothesis ? — our best guess, not proven yet
Say:
Every step links to what went in and what came out. Confirmed means we watched it work. Hypothesis means we have not proven it yet, and we say so.

## 1:04–1:10 | Under the hood
On screen: the pipeline diagram:
video → step extraction → docs evidence → finding elements on the page → CLI generation → parallel tests → report
Say:
Under the hood: video to steps, steps checked against the docs, elements found on the live page, a CLI generated, and every command tested in parallel.

## 1:10–1:18 | "Drop this into your AI"
On screen: the setup prompt, with a Copy button. Mary copies it and pastes it into her AI assistant.
Say:
Mary gets one prompt. Her AI installs the commands, saves the workflow as a skill, does a dry run, and asks her before it changes anything.

## 1:18–1:26 | Her AI runs it
On screen: Mary's AI registers a HACKDEMO- patient in OpenEMR and books the follow-up. Cut to the new appointment on the OpenEMR calendar.
Say:
And now her AI does the morning routine on OpenEMR — and shows its work.

## 1:26–1:30 | Next steps
On screen: closing slide.
Say:
Next: learn workflows from YouTube tutorials, and add more apps. If it runs in a browser, this works on it.
