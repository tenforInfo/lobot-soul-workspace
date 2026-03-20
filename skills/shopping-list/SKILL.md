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

### Add

**Triggers (触发词):** "buy X", "add X", "remind me to get X", "买XX", "帮我记XX", "加一下XX"

**Steps:**
1. Parse the item name (strip prefixes like "buy", "买", "买个", "帮我记").
2. Append to the `## 待买` section: `- [ ] [item] （[date] 添加）`
3. Confirm immediately — no further prompt needed.
4. Reply exactly: `已加入购物清单：[item] 🛒`

**[🛑 STRICT CONSTRAINTS / 严厉禁止事项]:**
- Do NOT act as a purchasing agent or smart shopping assistant.
- Do NOT ask ANY clarifying questions (e.g., about accounts, regions, versions, platforms, colors, sizes).
- NEVER offer advice or analysis on the item.
- ONLY record the raw text exactly as requested and reply with the confirmation.

**Examples (执行示例):**
- User: "买个swith 游戏 skyforce 电子版"
  - AI Reply: "已加入购物清单：swith 游戏 skyforce 电子版 🛒"
- User: "帮我记一下明天要买三瓶生抽"
  - AI Reply: "已加入购物清单：明天要买三瓶生抽 🛒"

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
