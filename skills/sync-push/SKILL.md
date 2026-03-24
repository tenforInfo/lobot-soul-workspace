## Task: Execute Push Sync

**Trigger format:** `/push` or `/push [id1] [id2] ...`

**CRITICAL CONSTRAINTS:**
- DO NOT output a plan.
- DO NOT ask for `(y/n)` confirmation.
- DO NOT explain the command.
- Execute IMMEDIATELY.

---

### Case 1: No args

Execute immediately, no checks:

```bash
cd /Users/tensorinfo/source/bunny_stack && git add . && git commit -m "chore: manual quick sync" && git push
cd /Users/tensorinfo/clawd && git add . && git commit -m "chore: manual quick sync" && git push
```

After execution, print summary with local path, remote URL, and a brief list of committed files (from `git diff HEAD~1 --name-only`):

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: <git -C /Users/tensorinfo/source/bunny_stack remote get-url origin>
   committed: SOUL.md, AGENTS.md
✅ workspace
   local : /Users/tensorinfo/clawd
   remote: <git -C /Users/tensorinfo/clawd remote get-url origin>
   committed: memory/2026-03-23.md
```

If nothing to commit (working tree clean), show `committed: nothing` instead.

---

### Case 2: With id args

1. Read `/Users/tensorinfo/source/bunny_stack/registry.yml`
2. For each id:
   - **Found and `local_path` is not null**: replace `$SOURCE_ROOT` with `${SOURCE_ROOT:-$HOME/source/cool-tool}`, then execute immediately:
     ```bash
     cd "<resolved_path>" && git add . && git commit -m "chore: manual quick sync" && git push
     ```
   - **Not found or `local_path` is null**: skip, do not interrupt other targets

3. Print summary after all targets — include local path, remote from registry `git` field, and committed files:

```
✅ bunny_stack
   local : /Users/tensorinfo/source/bunny_stack
   remote: https://github.com/tenforInfo/bunny_stack
   committed: SOUL.md
❌ side-project-idea — skipped (local_path is null)
❌ unknown-id — skipped (not found in registry)
```
