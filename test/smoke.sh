#!/bin/bash
# smoke test: the cage blocks writes outside allowed dirs and passes exit codes through
set -u
here="$(cd "$(dirname "$0")/.." && pwd -P)"
cage="$here/agent-cage"
fail=0
check() { if [ "$1" = "$2" ]; then echo "ok    $3"; else echo "FAIL  $3 (want $2, got $1)"; fail=1; fi; }

"$cage" --selftest >/dev/null; check $? 0 "selftest"

w="$(mktemp -d "$HOME/.agent-cage-smoke.XXXXXX")"
mkdir -p "$w/out"
(cd "$w" && "$cage" /bin/sh -c 'echo x > blocked.txt' 2>/dev/null); check $? 1 "read-only: write in cwd fails"
[ -e "$w/blocked.txt" ]; check $? 1 "read-only: no file left behind"
(cd "$w" && "$cage" -w out /bin/sh -c 'echo x > out/ok.txt'); check $? 0 "-w out: write in out works"
(cd "$w" && "$cage" -w out /bin/sh -c 'echo x > nope.txt' 2>/dev/null); check $? 1 "-w out: write beside out fails"
(cd "$w" && AGENT_CAGE_WRITE="$w" "$cage" /bin/sh -c 'echo x > env.txt'); check $? 0 "AGENT_CAGE_WRITE allows a dir"
"$cage" /bin/sh -c 'exit 7'; check $? 7 "exit code passes through"
"$cage" touch "$HOME/.claude/settings.json" 2>/dev/null; check $? 1 "agent settings are protected"
"$cage" --print -n | grep -q '(deny network\*)'; check $? 0 "--no-net adds a network deny"
rm -rf "$w"
[ "$fail" = 0 ] && echo "smoke: pass" || echo "smoke: FAIL"
exit "$fail"
