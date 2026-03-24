---
name: sync-push
description: Push local changes to git remotes. Default targets are bunny_stack and the current workspace. Accepts optional project ids to push specific projects from registry.yml. No confirmation required — executes immediately.
---

## Trigger

`/push` or `/push [id1] [id2] ...`

Skip all other analysis. Execute immediately.

## Steps

### Case 1: No args

```bash
cd /Users/tensorinfo/source/bunny_stack && git add . && git commit -m "chore: manual quick sync" && git push
cd /Users/tensorinfo/clawd && git add . && git commit -m "chore: manual quick sync" && git push
```

Print summary after execution:

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: <git -C /Users/tensorinfo/source/bunny_stack remote get-url origin>
   committed: SOUL.md, AGENTS.md
✅ workspace
   local : /Users/tensorinfo/clawd
   remote: <git -C /Users/tensorinfo/clawd remote get-url origin>
   committed: nothing
```

Get committed files from `git diff HEAD~1 --name-only`. If working tree was clean, show `committed: nothing`.

---

### Case 2: With id args

1. Read `/Users/tensorinfo/source/bunny_stack/registry.yml`
2. For each id:
   - **Found, `local_path` not null** → resolve path (replace `$SOURCE_ROOT` with `${SOURCE_ROOT:-$HOME/source/cool-tool}`), execute:
     ```bash
     cd "<resolved_path>" && git add . && git commit -m "chore: manual quick sync" && git push
     ```
   - **Not found or `local_path` is null** → skip, do not interrupt other targets
3. Print summary after all targets:

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: https://github.com/tenforInfo/bunny_stack
   committed: SOUL.md
❌ side-project-idea — skipped (local_path is null)
❌ unknown-id — skipped (not found in registry)
```

## Constraints

- Do NOT ask for confirmation
- Do NOT explain the command
- Do NOT output a plan
- On failure, continue to next target — report in summary
