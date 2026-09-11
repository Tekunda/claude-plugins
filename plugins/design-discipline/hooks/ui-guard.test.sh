#!/usr/bin/env bash
# Tests for ui-guard.sh. Pipes representative PreToolUse payloads through the
# guard and asserts the UI/non-UI/malformed behaviour.

set -u
DIR="$(cd "$(dirname "$0")" && pwd)"
GUARD="$DIR/ui-guard.sh"
fails=0

# Validate JSON with whatever is available; fall back to a structural check so
# the test has no hard dependency of its own.
is_valid_json() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$1" | jq -e . >/dev/null 2>&1
  elif command -v node >/dev/null 2>&1; then
    printf '%s' "$1" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{JSON.parse(s);process.exit(0)}catch(e){process.exit(1)}})'
  else
    printf '%s' "$1" | grep -qE '^\{.*"hookSpecificOutput".*\}$'
  fi
}

check() {
  local name="$1"; local ok="$2"
  if [ "$ok" -eq 0 ]; then
    echo "ok   - $name"
  else
    echo "FAIL - $name"
    fails=$((fails + 1))
  fi
}

# 1. .scss file -> guidance + valid JSON.
out="$(printf '%s' '{"tool_name":"Edit","tool_input":{"file_path":"apps/serpent-web/lib/help-center/header.module.scss","content":"x"}}' | bash "$GUARD")"
if printf '%s' "$out" | grep -q "TWO clusters" && is_valid_json "$out"; then check "scss emits valid guidance JSON" 0; else check "scss emits valid guidance JSON" 1; fi

# 2. components/Foo.tsx -> guidance.
out="$(printf '%s' '{"tool_name":"Write","tool_input":{"file_path":"packages/components/Foo.tsx","content":"x"}}' | bash "$GUARD")"
if printf '%s' "$out" | grep -q "TWO clusters" && is_valid_json "$out"; then check "component tsx emits guidance" 0; else check "component tsx emits guidance" 1; fi

# 3. .py file -> silent.
out="$(printf '%s' '{"tool_name":"Write","tool_input":{"file_path":"scripts/smoke-check.py","content":"x"}}' | bash "$GUARD")"
if [ -z "$out" ]; then check "py file is silent" 0; else check "py file is silent" 1; fi

# 4. .md file -> silent.
out="$(printf '%s' '{"tool_name":"Edit","tool_input":{"file_path":"docs/seo/notes.md","content":"x"}}' | bash "$GUARD")"
if [ -z "$out" ]; then check "md file is silent" 0; else check "md file is silent" 1; fi

# 5. malformed stdin -> exit 0, empty stdout.
out="$(printf '%s' 'not json at all <<<' | bash "$GUARD")"; rc=$?
if [ "$rc" -eq 0 ] && [ -z "$out" ]; then check "malformed stdin: exit 0, empty" 0; else check "malformed stdin: exit 0, empty" 1; fi

# 6. Real file_path (.scss) precedes a LATER escaped "file_path" inside content
#    (a .py). First-match must win -> guidance still emitted. This fails on a
#    greedy last-match extractor.
out="$(printf '%s' '{"tool_name":"Edit","tool_input":{"file_path":"apps/serpent-web/components/help-center/HelpCenter.module.scss","old_string":"a","new_string":"const p = {\"file_path\":\"scripts/x.py\"}"}}' | bash "$GUARD")"
if printf '%s' "$out" | grep -q "TWO clusters" && is_valid_json "$out"; then check "first-match: scss wins over later escaped py file_path" 0; else check "first-match: scss wins over later escaped py file_path" 1; fi

echo
if [ "$fails" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "$fails test(s) failed."
  exit 1
fi
