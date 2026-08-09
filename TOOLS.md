# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

---

## [OpenClaw] Key Paths

| Name | Path (小龙虾) | Notes |
|------|--------------|-------|
| registry.yml | `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml` | project registry |
| external-brain root | `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/` | git repo root |
| workspace config | `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/workspace/` | this file's directory |
| shopping list | `~/.openclaw/shopping-list.md` | standalone, not in external-brain |

**Path resolution — two env vars, different purposes:**

| Variable | Purpose | Example |
|----------|---------|---------|
| `$BRAIN_SOURCE` | Location of this external-brain repo on the deployment machine. Used to find `registry.yml` and all project brain docs. Falls back to `/Users/tensorinfo/source/bunny_stack` if unset. | `/Users/tensorinfo/source/bunny_stack` |
| `$SOURCE_ROOT` | Root directory of all managed project repos. Used by `registry.yml` `local_path` fields. | `~/source` |

Example: `local_path: $SOURCE_ROOT/cool-tool/bunny_stack` → `~/source/cool-tool/bunny_stack` (this repo itself)

---

## [OpenClaw] GitHub CLI

`gh` is available for:
- Create issue: `gh issue create --repo <owner/repo> --title "..." --body "..."`
- List issues: `gh issue list --repo <owner/repo>`
- Repo comes from the `git` field in registry.yml

---

## [OpenClaw] Telegram

| Bot | Purpose | When |
|-----|---------|------|
| Bot A | Personal inbox / notifications | write confirmations, HEARTBEAT alerts |
| Bot B | Family group | family reminders, shopping list updates |

Format: concise, max 3 lines. Important actions include a confirm button.

---

## [OpenClaw] Discord

| Bot | Purpose |
|-----|---------|
| Bot C | Image delivery, meeting transcripts |

---

## [OpenClaw] Sending Images

**Rule: never send a local file path. Always upload to R2 first, then send the public URL.**

```bash
URL=$(upload-r2-image "$IMAGE_PATH" sekitoba 2>&1 | grep '^https://')
```

Then use `$URL` in the normal Telegram / Discord message flow. The platform embeds the image automatically.

Global command: `upload-r2-image` (pre-installed on this machine)

---

## [OpenClaw] File Tools

- Read files: Read
- Write files: Edit (append) / Write (new file)
- Search content: Grep
- Search paths: Glob
- Run commands: Bash (git / gh / essential system commands only)

## [OpenClaw] Capability Truth Source

Use this file as the local truth for machine-specific capabilities.

- OpenClaw on this machine is allowed to act as an agent, not just a text assistant.
- If a user asks for browser work, local file access, or uploads, check this file and the current tool list before refusing.
- Before concluding a task can't be done for lack of permission, try the tool call and inspect the actual error. Only report "no permission" when the error explicitly says so (a permission or sandbox denial) — other failures (timeout, missing parameter, bad target) are not permission issues and should be reported as what they are.

## [OpenClaw] Browser Diagnostics

- Browser failures on this machine are often runtime issues, not authorization issues.
- Common failure classes:
  - gateway timed out
  - browser action missing required parameters
  - target page requires auth or heavy JavaScript
- If browser automation fails, report the concrete failure and next fix.
- If logs mention gateway timeout, the likely fix is restarting the OpenClaw gateway rather than changing prompt wording.

## [OpenClaw] Local File Access

- Reading local paths such as `/tmp/...` is allowed through the normal workspace file or shell tools when available.
- Try the appropriate tool first rather than assuming `/tmp` is blocked. If it fails, check whether the error is an explicit permission/sandbox denial before concluding access is restricted.

**Constraints:**
- Do NOT use web search unless user explicitly requests
- Do NOT call external APIs (except GitHub API via gh CLI)
- Do NOT store content from `human-notes/` or `*/notes.md`
