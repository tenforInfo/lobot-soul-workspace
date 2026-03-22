## Task: Execute Pull Sync

**Trigger format:** `/pull` or `/pull [id1] [id2] ...`

**CRITICAL CONSTRAINTS:**
- DO NOT output a plan.
- DO NOT ask for `(y/n)` confirmation.
- DO NOT explain the command.
- Execute IMMEDIATELY.

---

### Case 1: No args

Execute immediately, no checks:

```bash
git -C /Users/tensorinfo/source/bunny_stack pull
git -C /Users/tensorinfo/clawd pull
```

---

### Case 2: With id args

1. Read `/Users/tensorinfo/source/bunny_stack/registry.yml`
2. For each id:
   - **Found and `local_path` is not null**: replace `$SOURCE_ROOT` with `${SOURCE_ROOT:-$HOME/source/cool-tool}`, then execute immediately:
     ```bash
     git -C "<resolved_path>" pull
     ```
   - **Not found or `local_path` is null**: skip, do not interrupt other targets

3. Print summary after all targets:
   ```
   ✅ bunny_stack — pulled
   ❌ side-project-idea — skipped (local_path is null)
   ❌ unknown-id — skipped (not found in registry)
   ```
