---
name: brain-meeting
description: Process a meeting transcript. Extract decisions and action items, route action items to their respective projects, write a structured meeting note, update project READMEs, and push.
---

## Trigger

- Discord Bot C delivers a transcript tagged `meeting-transcript`
- User pastes meeting notes prefixed with "会议记录："
- Content is recognized as a meeting transcript

> **[Phase 3]** Full implementation pending Bot C integration. Workflow is fully specified; activate when Bot C is connected.

## Steps

**1. Receive transcript**

Accept raw transcript text (with or without timestamps) from Bot C or direct user paste.

**2. Structure the content**

Extract:
- Meeting date (infer from content, or use today)
- Participants (if identifiable)
- Main topics: 1–3
- Key decisions: one per line, prefixed `→`
- Cross-project action items: each tagged with its target project
- Unresolved questions: items needing follow-up

**3. Route action items**

Read `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml`. Match each action item to a project. Items that cannot be matched are marked "unassigned".

**4. Preview and confirm**

```
Meeting summary [date]:

Topics: [list]

Action items by project:
[Project name]:
  - [ ] [action item]
Unassigned:
  - [ ] [action item]

---
Write to meetings/[date].md and update project READMEs? (y/n)
```

**5. Write and push**

After confirmation:
1. Create `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/meetings/YYYY-MM-DD.md` (structured note)
2. Append action items to each target project's README.md
3. Create GitHub Issues for action items
4. Do **not** store the raw transcript — summaries only
5. `cd ${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack} && git add . && git commit -m "brain: meeting [YYYY-MM-DD]" && git push`

## Meeting file format

```markdown
---
date: YYYY-MM-DD
type: meeting
participants: [if known]
---
# Meeting Notes YYYY-MM-DD

## Topics
1. [topic 1]

## Key Decisions
→ [decision 1]
→ [decision 2]

## Action Items
- [ ] [action] → [owner / project]

## Open Questions
- [ ] [question]
```

## Phase 3 dependencies

- [ ] Discord Bot C connected and delivering to OpenClaw
- [ ] Bot C → OpenClaw message format protocol finalized
- [ ] Cross-project action item routing tested
