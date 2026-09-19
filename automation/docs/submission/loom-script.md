# Loom video script: about 2:50 (event requires 2–5 minutes)

Status: draft for Aurora to edit. This is the recorded Loom version. The 90-second live pitch is demo-script.md; this follows the same flow with two added beats: the docs-evidence step and an "under the hood" look at the pipeline and the generated code. Anything in [TEAM FILLS] depends on the team's build or on a real test run. Do not say a number until it has been measured.

Target workflow (Aurora still to confirm): Mary registers a new patient in OpenEMR, then books that patient's follow-up appointment.
Demo site: OpenEMR public demo, https://demo.openemr.io/openemr, logged in as receptionist. Every patient created uses the HACKDEMO- name prefix.

Recording tip: show the core loop live, in one take where possible. Keep the stopwatch and the report on screen long enough to read.

## 0:00–0:15 | Hook
On screen: title slide, then the OpenEMR login page.
Say:
Mary runs the front desk on software from 2005 with no API. She records one video of her morning routine. Ninety seconds later, her AI does it for her — and shows its work.
This is OpenEMR, open-source medical records software used by clinics. We'll use its public demo, with fake patients only.

## 0:15–0:30 | Inputs
On screen: the app's start screen. Paste the OpenEMR URL. Drop in Mary's screen recording and play two or three seconds of it.
Say:
Mary gives us two things: the address of the tool she uses every day, and one recording of her doing the job by hand. Here she registers a new patient and books their follow-up. No integration project, no engineer.

## 0:30–0:50 | Workflow summary, Mary confirms
On screen: the app shows a 3 to 5 bullet summary of the recording. Hover over each bullet. Mary clicks Confirm.
Example bullets (replace with what the app actually produces [TEAM FILLS]):
- Log in to OpenEMR as the front desk user
- Register a new patient with name, sex, and date of birth
- Open the Calendar and book that patient's follow-up appointment
Say:
The app watches the video and writes back, in plain language, what it thinks Mary does. She reads it. If a step is wrong, she fixes it here, before anything runs. Nothing moves forward until she confirms.

## 0:50–1:00 | Login
On screen: a login window opens on OpenEMR. Mary types her own username and password.
Say:
Mary logs in herself, in a window she can see. The app never asks her to hand over a password in chat.

## 1:00–1:15 | Evidence: it reads the docs first
On screen: three cited facts, each with its source link visible:
- "In the default OpenEMR instance, those are: Name, Sex, DOB." Source: OpenEMR 7 wiki, Search - Add Patient, https://www.open-emr.org/wiki/index.php/OpenEMR_7_Search_-_Add_Patient
- Booking from the Calendar: click the provider's name, "Click on the time in the date column to open the appointment scheduler dialog", choose the category, find and select the patient, Save. Source: OpenEMR wiki, https://www.open-emr.org/wiki/index.php/A_Generic_Medical_Encounter_Workflow_in_OpenEMR_6.1 (a 6.1-era page, older than the 8.4.0 demo; the v7 calendar notes link to it for these steps)
- OpenEMR has REST and FHIR APIs, but an administrator has to "Enable OpenEMR Standard REST API" under Administration > Config > Connectors, and apps have to register for OAuth2 access. Source: https://github.com/openemr/openemr/blob/master/API_README.md
Then one line: "Your setup differs from the default: [TEAM FILLS: the specific difference the app detected]"
Say:
Before writing anything, it read OpenEMR's own docs. Here are three facts it used, each with a link. The default install needs only three fields for a new patient. The docs give the exact calendar click path. And the API exists, but it's off until an admin turns it on, which Mary can't do. Her browser already works. It also flags where Mary's setup differs from the default, so it doesn't assume the docs match her screen.

## 1:15–1:35 | Build the commands, then test them
On screen: the app generates browser-automation CLI commands, one per step, then runs them against OpenEMR. A stopwatch is visible: manual time from Mary's video next to the AI's time.
Say:
Now it turns each confirmed step into a command her AI can run, and tests every command on the real site. Mary took [TEAM FILLS: manual time, measured from the video] by hand. The AI took [TEAM FILLS: measured AI time].

## 1:35–1:55 | Test report
On screen: the test report. Click one step's input link and one output link to show they are real. Each step is marked:
- Confirmed ✓ — the command ran and we can show the result
- Hypothesis ? — our best guess, not proven yet
Say:
This is the part we care most about. Every step links to what actually went in and what came out. Confirmed means we watched it work. Hypothesis means we have not proven it, and we say so. Mary can check any line herself.

## 1:55–2:15 | Under the hood
On screen: the pipeline diagram:
video → step extraction → docs evidence → finding elements on the page → CLI generation → parallel tests → report
Then switch to Cursor with the generated CLI open. Scroll to one command, for example the one that books the appointment. [TEAM FILLS: which file and command to show]
Say:
Under the hood: we extract the steps from the video, check each one against the docs, find the matching elements on the live page, and generate a CLI. Then every command is tested in parallel, and the results become the report. Here is the generated code in Cursor: this is the command that [TEAM FILLS: what the shown command does]. It is a normal CLI you can read and change.

## 2:15–2:30 | "Drop this into your AI"
On screen: the setup prompt, with a Copy button. Mary copies it and pastes it into her AI assistant.
Say:
At the end Mary gets one prompt. She pastes it into her AI. It installs the commands, saves her workflow as a skill, does a dry run, and asks her before it changes anything.

## 2:30–2:42 | Her AI runs it
On screen: Mary's AI registers a HACKDEMO- patient in OpenEMR and books the follow-up. It asks Mary to approve each write. Cut to the new appointment on the OpenEMR calendar.
Say:
And now her AI does the morning routine on OpenEMR. It asks before each change, and shows its work.

## 2:42–2:50 | Next steps
On screen: closing slide.
Say:
Next, we'll learn workflows from existing YouTube tutorials, not only Mary's recordings, and add more apps. If it runs in a browser, this works on it.
