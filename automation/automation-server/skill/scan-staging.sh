#!/bin/bash
# scan-staging.sh <dir> — same patterns as repo/scripts/secrets-scan.sh, applied to a plain directory (grep -r, not git grep).
# Exit 0 = PASS, 1 = FAIL (hard finding), 2 = bad usage.
D="$1"
[ -n "$D" ] && [ -d "$D" ] || { echo "usage: scan-staging.sh <dir>" >&2; exit 2; }
N=$(find "$D" -type f | wc -l | tr -d ' ')
[ "$N" -gt 0 ] || { echo "FAIL: no files in $D (refusing to report PASS on an empty dir)"; exit 1; }
HARD=0
echo "== scanning $N files in $D"
echo "== 2. session / cookie / state / .env / key FILES (want: none; .env.example allowed)"
F=$(cd "$D" && find . -type f | sed 's|^\./||' | grep -iE '(^|/)[^/]*sessions[^/]*/|storagestate|cookies?\.json|\.oe-state|\.session\.json|(^|/)\.env(\.[^/]*)?$|\.pem$|\.key$' | grep -v '\.env\.example$')
if [ -n "$F" ]; then echo "$F"; HARD=1; else echo "  none"; fi
echo "== 2b. image / video files (want: none)"
F=$(cd "$D" && find . -type f | grep -iE '\.(png|jpe?g|gif|webp|webm|mp4|mov)$')
if [ -n "$F" ]; then echo "$F"; HARD=1; else echo "  none"; fi
echo "== 3. Playwright storageState content (want: none)"
F=$(grep -rlE '"cookies"[[:space:]]*:[[:space:]]*\[|"localStorage"[[:space:]]*:[[:space:]]*\[' "$D")
if [ -n "$F" ]; then echo "$F"; HARD=1; else echo "  none"; fi
echo "== 4. cookie / token / key VALUES (want: none)"
F=$(grep -rnE 'PHPSESSID=[A-Za-z0-9]{8,}|OpenEMR=[A-Za-z0-9]{8,}|Set-Cookie:|Cookie:[[:space:]]*[A-Za-z0-9_]+=|Bearer [A-Za-z0-9._-]{16,}|sk-ant-[A-Za-z0-9]|ANTHROPIC_API_KEY=[^[:space:]$]+|apify_api_[A-Za-z0-9]{6,}|SERVICE_ROLE_KEY[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9._-]{8,}|APIFY_TOKEN[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9._-]{8,}|eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}|csrf_token[^a-z]{0,6}[A-Za-z0-9]{16,}' "$D" | grep -vE 'Bearer YOUR_[A-Z_]+')
if [ -n "$F" ]; then echo "$F" | cut -c1-200; HARD=1; else echo "  none"; fi
echo "== 4b. ANY '<redacted> (want: none)"
F=$(grep -rn '<redacted> "$D")
if [ -n "$F" ]; then echo "$F" | cut -c1-200; HARD=1; else echo "  none"; fi
echo "== 6. credential literals (public demo login listed, not failed)"
grep -rnE -- '--pass [^ "]+|TEST_LOGIN_PASS=[^ ]+|admin ?/ ?pass|receptionist ?/ ?receptionist' "$D" | cut -c1-160
O=$(grep -rhoE -- '--pass [A-Za-z0-9_$]+' "$D" | sort -u | grep -vE -- '^--pass (pass|receptionist)$')
echo "  any OTHER --pass value (want: none):"
if [ -n "$O" ]; then echo "$O"; HARD=1; else echo "  none"; fi
echo "== RESULT: $([ $HARD = 0 ] && echo PASS || echo FAIL)"
exit $HARD
