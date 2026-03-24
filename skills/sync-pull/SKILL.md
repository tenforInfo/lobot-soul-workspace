---
name: sync-pull
description: Pull latest changes from git remotes. Default targets are bunny_stack and the current workspace. Accepts optional project ids to pull specific projects from registry.yml. No confirmation required — executes immediately.
---

## Trigger

`/pull` or `/pull [id1] [id2] ...`

Skip all other analysis. Execute immediately.

## Steps

### Case 1: No args

```bash
git -C /Users/tensorinfo/source/bunny_stack pull
git -C /Users/tensorinfo/clawd pull
```

Print summary after execution:

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: https://github.com/tenforInfo/bunny_stack
   changes: 3 files changed
✅ workspace
   local : /Users/tensorinfo/clawd
   remote: <git -C /Users/tensorinfo/clawd remote get-url origin>
   changes: already up to date
```

Get change count from git pull stdout (e.g. "3 files changed"). If already up to date, show `already up to date`.

---

### Case 2: With id args

1. Read `/Users/tensorinfo/source/bunny_stack/registry.yml`
2. For each id:
   - **Found, `local_path` not null** → resolve path (replace `$SOURCE_ROOT` with `${SOURCE_ROOT:-$HOME/source/cool-tool}`), execute:
     ```bash
     git -C "<resolved_path>" pull
     ```
   - **Not found or `local_path` is null** → skip, do not interrupt other targets
3. Print summary after all targets:

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: https://github.com/tenforInfo/bunny_stack
   changes: 2 files changed
❌ side-project-idea — skipped (local_path is null)
❌ unknown-id — skipped (not found in registry)
```

## Constraints

- Do NOT ask for confirmation
- Do NOT explain the command
- Do NOT output a plan
- On failure, continue to next target — report in summary
