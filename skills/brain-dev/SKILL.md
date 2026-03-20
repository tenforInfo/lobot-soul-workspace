---
name: brain-dev
description: Execute a development task via Codex. Confirm the task with the user, invoke Codex, report progress every 15 minutes, push a PR on completion, then return to Brain mode automatically.
---

## Trigger

- Message starts with `#dev`
- User says "help me build", "continue dev", or similar

> **[Phase 3]** Full implementation pending Codex integration. Interface is fully specified; activate when Codex is connected.

## Trigger examples

```
#dev continue building the xxx feature
#dev implement Issue #12
#dev fix [problem description]
```

## Steps

**1. Confirm task**

On receiving `#dev`:
- Switch to Dev mode (persists for the session)
- If an Issue number is referenced, read that Issue's description
- Restate the task and wait for user confirmation:

```
Dev mode — Task confirmation

Goal: [restate task]
Related Issue: [if any]
Estimated scope: [files / modules]

Confirm? (y/n)
```

**2. Invoke Codex**

After confirmation, call Codex to execute the task. Record start time.

**3. Report progress every 15 minutes**

```
🔨 Dev update [HH:MM]
Now: [what is being worked on]
Done: [completed parts]
Remaining: [what is left]
```

If no change since last update: `🔨 Dev in progress... [HH:MM]`

**4. Pause for user decision when**

Stop and ask before continuing if:
- The Issue description is ambiguous or contradictory
- A database schema change is required
- An API interface change is needed
- Code contradicts the Issue description
- Scope exceeds what the Issue describes

Pause format:
```
⏸ Dev paused — decision needed

Issue: [describe the situation]
Options:
1. [option 1]
2. [option 2]
Choose to continue.
```

**5. Push PR on completion**

1. Create a PR — always PR, never merge directly
2. PR title: `feat: [task description] (Issue #N)`
3. Notify user to review:

```
✅ Dev complete

PR: [PR URL]
Changes: [N files — summary of main changes]
Tests: [test results if available]

Please review and merge.
```

**6. Return to Brain mode**

After PR is created, automatically switch back:
```
Returned to Brain mode.
```

## Mode switching rules

| Trigger | Behavior |
|---------|----------|
| `#dev xxx` | Enter Dev mode |
| Task complete | Auto-return to Brain mode |
| `#brain` | Manual return to Brain mode |
| "pause" / "stop" | Pause Dev, stay in Dev mode |
| New session | Always reset to Brain mode |

## Phase 3 dependencies

- [ ] Codex connected to OpenClaw
- [ ] Codex → OpenClaw progress callback protocol finalized
- [ ] PR creation permissions configured
- [ ] 15-minute heartbeat mechanism implemented
