# agent-cage
Runs Claude Code, Codex or any command on macOS so it cannot write anywhere except the folders you allow, enforced by the kernel sandbox, not by the agent's own allowlist.

```
curl -fsSL https://raw.githubusercontent.com/kilazi/agent-cage/main/install.sh | sh
```

## Use
```
agent-cage claude -p "review this repo"            # read-only
agent-cage -w ./out claude -p "write the report"   # writes only in ./out
agent-cage -w . codex exec "fix the failing test"  # writes only in this repo
```
`-n` blocks network, `--print` shows the profile, `--selftest` proves it works on your Mac.
The agent's own state (`~/.claude`, `~/.codex`, caches) and temp dirs stay writable; its settings and hooks do not.
Apache-2.0. Reusing it? Keep the NOTICE: credit kilazi/agent-cage.

More: https://kilazi.com/wiki/agent-cage/ · by kilazi
