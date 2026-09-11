#!/usr/bin/env bash
# PreToolUse guard for the design-discipline plugin.
# Reads a hook payload on STDIN, and when the write targets a UI surface it
# injects the anti-cram counter-steer as additionalContext. Advisory only:
# it NEVER denies a write and fails open on any parse trouble (always exit 0).

set +e

# Read all of STDIN. A missing/closed stdin just yields empty input.
input="$(cat 2>/dev/null)"
[ -z "$input" ] && exit 0

# Portable extraction of tool_input.file_path (no jq dependency).
# Matches the first "file_path": "..." and captures up to the next quote.
file_path="$(printf '%s' "$input" \
  | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | head -n 1)"

# No parseable file_path -> nothing to advise on. Silent, fail-open.
[ -z "$file_path" ] && exit 0

# UI surface? CSS/SCSS/style file, a component file, or a path under
# components/, app/, or styles/.
is_ui=0
if printf '%s' "$file_path" | grep -qE '\.(css|scss|sass|less|tsx|jsx)$'; then
  is_ui=1
elif printf '%s' "$file_path" | grep -qE '(^|/)(components|app|styles)/'; then
  is_ui=1
fi

[ "$is_ui" -eq 0 ] && exit 0

# The counter-steer. Single quotes only inside the text, so it embeds in JSON
# with no escaping needed.
guidance="UI edit detected. A change that satisfies the literal spec ('one line', 'compact', 'fits', 'no overflow') but looks cramped is NOT done. Achieve 'fit' by DELETING or RELOCATING elements, never by cramming one row or shrinking below comfortable / tap-target sizes (logos, 44x44 targets). A mobile header is TWO clusters: identity left, one primary action right, with air between - not one crammed row. Order of response when space is tight: delete > relocate > collapse > (last) shrink, never below minimums. See the design-discipline skill for the full rubric."

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"%s"}}\n' "$guidance"
exit 0
