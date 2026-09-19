#!/bin/bash
# build-skill.sh — build referral-intake-skill.zip from the live files at request time.
# Last stdout line = absolute zip path (exit 0). Scan failure => no zip, exit 1. Missing source => exit 3.
set -u
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SKILL_DIR/../.." && pwd)"
README="$ROOT/openemr-cli/README.md"
SETUP="$ROOT/submission/setup-prompt.md"
for f in "$README" "$SETUP"; do [ -f "$f" ] || { echo "missing source: $f" >&2; exit 3; }; done
TS="$(date +%Y%m%d_%H%M%S)_$$"
STAGE="$SKILL_DIR/build/$TS/openemr-referral-intake"
mkdir -p "$STAGE"
ZIP="$SKILL_DIR/build/$TS/referral-intake-skill.zip"

# fenced block following a given "## Heading" in README
block() { awk -v h="$1" '$0==h{f=1;next} f&&/^```/{if(c){exit}c=1;next} f&&c{print}' "$README"; }
section() { awk -v h="$1" '$0==h{f=1;next} f&&/^## /{exit} f{print}' "$README"; }

INSTALL_CMDS="$(block '## Install (this laptop)')"
CMDS="$(block '## Commands')"
[ -n "$INSTALL_CMDS" ] && [ -n "$CMDS" ] || { echo "could not parse README sections" >&2; exit 3; }
EXITS="$(section '## Output and exit codes' | awk '/^\| code/{f=1} f&&/^\|/{print} f&&!/^\|/{if(p)exit} {p=f}')"

# newest report: automation-server/intake/*/intake.json or test-runner/runs/*/report.json
REPORT="$(ls -t "$ROOT"/automation-server/intake/*/intake.json "$ROOT"/test-runner/runs/*/report.json 2>/dev/null | head -1)"
VERIFIED="$(python3 - "$REPORT" <<'PY'
import json, sys, os
p = sys.argv[1] if len(sys.argv) > 1 else ""
if not p or not os.path.exists(p):
    print("- No report found at build time (UNVERIFIED)."); sys.exit()
d = json.load(open(p))
rel = p.split("hackathon-2026-09-19/")[-1]
out = [f"Source: `{rel}` (newest report at build time; site `{d.get('site','?')}`, summary: {d.get('summary','?')})", ""]
refs = d.get("referrals")
if refs is None:
    refs = [{"file": "run", "cli": d}]
for r in refs:
    cli = r.get("cli") or {}
    last = (r.get("extracted") or {}).get("last_name", "")
    name = last if last.startswith("HACKDEMO-") else "(name withheld)"
    out.append(f"- {r.get('file','?')} ({name}), exit {cli.get('exit_code','?')}:")
    for s in cli.get("steps", []):
        out.append(f"  - {s.get('step','?')}: {s.get('status','?')}")
print("\n".join(out))
PY
)"

cat > "$STAGE/SKILL.md" <<MD
---
name: openemr-referral-intake
description: Use when a referral fax or referral PDF needs entering into OpenEMR - create the patient (demographics), add their insurance, attach the referral PDF to the patient's Documents, and book a New Patient appointment - via the openemr CLI, with every write read back and verified.
---

# OpenEMR referral intake

Turns each referral PDF into an OpenEMR patient with demographics, primary insurance, the PDF under Documents (Medical Record), and a New Patient appointment on the next weekday. Default site is \`a\` (https://demo.openemr.io/a/openemr). Last names must start with \`HACKDEMO-\` on the public demo.

## The rule

**Ask Mary before any write; use --dry-run first.** Run \`openemr intake <pdf> --dry-run\`, show Mary the extracted plan, and only run the real intake after she says yes. Never take or type a password: Mary logs in herself.

## Login, check, intake

\`\`\`
openemr login                        # Mary logs in in a visible browser window; session is saved
openemr check                        # LOGGED_IN (exit 0) or LOGGED_OUT (exit 2)
openemr intake <referral.pdf> --dry-run   # plan only, writes nothing
openemr intake <referral.pdf> --json      # after Mary approves
\`\`\`

All commands (from openemr-cli/README.md):

\`\`\`
$CMDS
\`\`\`

## Exit codes

$EXITS

On exit 2, run \`openemr login\` and ask Mary to log in. On exit 1, report the \`mismatch\` field to Mary verbatim; do not retry blindly. On exit 3, report the \`error\` verbatim.

## Verified steps

$VERIFIED
MD

{ echo "# Install the openemr CLI"; echo; echo "Copied verbatim from openemr-cli/README.md (Install section):"; echo; echo '```'; echo "$INSTALL_CMDS"; echo '```'; } > "$STAGE/INSTALL.md"
cp "$SETUP" "$STAGE/setup-prompt.md"

if ! "$SKILL_DIR/scan-staging.sh" "$STAGE"; then
  echo "SECRETS SCAN FAILED on $STAGE — no zip written" >&2
  exit 1
fi
(cd "$(dirname "$STAGE")" && zip -qr "$ZIP" "$(basename "$STAGE")") || { echo "zip failed" >&2; exit 3; }
cp "$ZIP" "$SKILL_DIR/referral-intake-skill.zip"
echo "$SKILL_DIR/referral-intake-skill.zip"
