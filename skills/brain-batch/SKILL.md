---
name: brain-batch
description: Archive multiple independent content blocks in one session. Split input, classify each block to a project, show a unified preview, confirm, write all, and push once.
---

## Trigger

- Message starts with `#batch`
- User sends multiple independent content blocks at once

## Input format

```
#batch
[content 1]
---
[content 2]
---
[content 3]
```

Or:

```
#batch summarize this week's discussions
[paste multiple blocks]
```

## Steps

**1. Split**

Split on `---` separators. If no explicit separators, split on blank lines between paragraphs.

**2. Classify each block**

Read `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml`. For each block:
- Infer the target project or topic
- Determine intent type: project content / quick task / other
- Extract key conclusions and action items (1–2 sentences)

**3. Show batch preview**

```
[N] blocks detected:

① → [project name]
   Conclusions: [1–2 lines]
   Action items: [1–2 items]

② → [project name]
   Conclusions: [1–2 lines]

③ → Quick task (not archived)
   Action: [shopping list / reminder]

---
To reassign a block, enter its number. To confirm all, enter y.
```

**4. Handle modifications**

- `y` → confirm all, proceed to step 5
- Number (e.g. `2`) → reassign that block:
  ```
  Reassign block ②:
  Current: [project name]
  Enter new project number or "new project":
  ```
  After change, redisplay the full preview.

**5. Write all**

For each confirmed block:
1. Check `registry.yml` for this project's `has_issues` field:
   - `has_issues: true`: **First** run `gh issue create --repo [git] --title "[action text]"` for each action item; capture the issue number; write `- [ ] #<issue_number>` into the "行动项" section of README.md.
   - `has_issues: false` (or field absent): Write `- [ ] [action text]` directly into the "行动项" section (no Issue created).
2. Append conclusions to "核心结论" and open questions to "未决问题".
3. Handle quick tasks (shopping list, etc.).


**6. Push once**

```bash
cd ${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}
git add -A
git commit -m "brain: batch import [N items] — [YYYY-MM-DD]"
git push
```

Reply with:
```
✅ Batch import complete
- Written to [N] projects
- [M] GitHub Issues created
- Pushed to GitHub
```

## Edge cases

| Situation | Handling |
|-----------|----------|
| A block cannot be classified | Mark as "unassigned", skip write, list at the end |
| Write fails for one project | Continue with others, report failures at the end |
| git push fails | All files written — notify user to push manually |
