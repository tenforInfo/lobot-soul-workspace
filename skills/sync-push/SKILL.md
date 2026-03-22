## Task: Execute Push Sync

**触发格式：** `/push` 或 `/push [id1] [id2] ...`

**CRITICAL CONSTRAINTS:**
- DO NOT output a plan.
- DO NOT ask for `(y/n)` confirmation.
- DO NOT explain the command.
- Execute IMMEDIATELY.

---

### 情况一：无参数

直接执行，不做任何判断：

```bash
cd /Users/tensorinfo/source/bunny_stack && git add . && git commit -m "chore: manual quick sync" && git push
cd /Users/tensorinfo/clawd && git add . && git commit -m "chore: manual quick sync" && git push
```

---

### 情况二：有 id 参数

1. 读取 `/Users/tensorinfo/source/bunny_stack/registry.yml`
2. 对每个 id：
   - **找到且 `local_path` 不为 null**：将 `$SOURCE_ROOT` 替换为 `${SOURCE_ROOT:-$HOME/source/cool-tool}`，立即执行：
     ```bash
     cd "<resolved_path>" && git add . && git commit -m "chore: manual quick sync" && git push
     ```
   - **未找到或 `local_path` 为 null**：跳过，不中断其他目标

3. 所有目标执行完后输出摘要：
   ```
   ✅ bunny_stack — pushed
   ❌ side-project-idea — skipped (local_path is null)
   ❌ unknown-id — skipped (not found in registry)
   ```
