---
name: shopping-list
description: Manage a personal shopping list stored at ~/.openclaw/shopping-list.md. Add, view, and complete items. Fully isolated from the external-brain repo — no git operations.
---

## Trigger

Intent signals: "buy X", "add X", "remind me", "what do I need to buy", quick to-do items that should not be archived in a project.

## Storage

File: `~/.openclaw/shopping-list.md`

```markdown
# Shopping List

## To Buy
- [ ] soy sauce (added 2026-03-17)
- [ ] milk

## Done
- [x] laundry detergent (completed 2026-03-16)
```

## Operations

### Add

Triggers: "buy X" / "add X" / "remind me to get X"

1. Parse the item name (strip "buy" / "add" / "remind me" prefixes)
2. Append to the `## To Buy` section: `- [ ] [item] (added [date])`
3. Confirm immediately — no further prompt needed
4. Reply: `Added to shopping list: [item] 🛒`

Multiple items in one message: add each on its own line.
Reply: `Added to shopping list: soy sauce, milk, eggs 🛒`

### View

Triggers: "shopping list" / "what do I need to buy" / "show list"

1. Read the `## To Buy` section
2. List all unchecked items
3. Reply:
   ```
   Shopping list ([N] items):
   • soy sauce
   • milk
   ```
4. If empty: `Shopping list is empty ✓`

### Complete

Triggers: "bought X" / "got X" / "done with X"

1. Find the matching item (fuzzy match)
2. Move it to `## Done`, mark `[x]`, append `(completed [date])`
3. Reply: `✓ Done: [item]`

### Clear completed

Triggers: "clear done" / "clean up list"

1. Empty the `## Done` section
2. Reply: `Cleared [N] completed items`

## After handling

If there was an in-progress topic in the conversation, append:
```
(Continuing the previous discussion...)
```

If the conversation was new, skip this.

## Constraints

- Do **not** create GitHub Issues
- Do **not** write to the external-brain directory
- Do **not** run git commands
- If the file operation fails, notify the user but do not interrupt the reply
