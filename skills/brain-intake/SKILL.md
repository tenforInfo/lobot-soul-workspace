---
name: brain-intake
description: Archive a single piece of project-related content. Route to the matching project, compare against history, extract conclusions and action items, confirm with the user, then write and push.
---

## Trigger

Intent signals: project name, tech decision, architecture conclusion, product direction, or any content meant to be stored in the external brain.

## Steps

**1. Match project**

Read `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml`. Compare content keywords against each project's `name`, `description`, and `id`.

- Single match → continue
- Multiple candidates → list them and ask the user to choose by number, or enter "new project"
- No match → ask whether to create a new registry entry (do not auto-create)

**2. Load project history**

Resolve `brain_file` from registry.yml as an absolute path:
`${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/[brain_file]`

Read the "核心结论" and "行动项" sections from that README.md.

**3. Detect contradictions**

Compare the incoming content against existing conclusions. If a contradiction is found, surface it before proceeding:

```
⚠️ Contradiction detected:
Existing: [old conclusion]
Incoming: [new position]
How to resolve? (1) New overwrites old  (2) Keep both, note disagreement  (3) Ignore
```

**4. Extract**

From the incoming content, extract:
- Conclusions: 1–3 items, one line each, prefixed with `→`
- Action items: each as `- [ ] ...`
- Open questions: if any

**5. Preview and confirm**

Show the user what will be written before writing anything.

If `has_issues: true`:
```
Ready to write to `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/[brain_file]`:

**Conclusions**
→ [conclusion 1]

**Action items** (GitHub Issues will be created automatically)
- [ ] [action 1]

**Open questions** (if any)
- [ ] [question 1]

repo: [git field]
Confirm? (y/n)
```

If `has_issues: false` or field absent:
```
Ready to write to `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/[brain_file]`:

**Conclusions**
→ [conclusion 1]

**Action items**
- [ ] [action 1]

**Open questions** (if any)
- [ ] [question 1]

Confirm? (y/n)
```

Only one confirmation prompt — no separate "Create GitHub Issues?" question.

**6. Write and push**

After user confirms:

1. If `has_issues: true`: run `gh issue create --repo [git] --title "[action text]"` for **each** action item in order; capture the returned issue number.
2. Append to README.md:
   - Conclusions → "核心结论" section
   - Action items → "行动项" section
     - With issues: `- [ ] #<issue_number>` (one per item, in creation order)
     - Without issues: `- [ ] [action text]`
   - Open questions → "未决问题" section
3. Update "当前状态" if a clear status change is implied.
4. `cd ${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack} && git add . && git commit -m "brain: update [project name]" && git push`

Reply with:
```
✅ Written and pushed: [project name]
- [N] conclusions, [M] action items
- Issues: [#1, #2, ...] or "not created"
```

## Edge cases

| Situation | Handling |
|-----------|----------|
| Content under 10 characters | Ask: "Add more context before processing?" |
| Content contains credentials or secrets | Warn the user, do not write |
| brain_file does not exist | Ask whether to create it from template |
| git push fails | Notify user — file is written but not pushed |
