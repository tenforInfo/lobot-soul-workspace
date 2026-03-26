---
name: brain-dev
description: Execute a development task via Codex. Routes to a project via registry.yml, creates an isolated git worktree, and runs codex inside a detached tmux session to submit a PR.
user-invocable: true
metadata:
  {
    "openclaw":
      {
        "requires": { "bins": ["tmux", "codex", "git", "gh", "bash"] },
      },
  }
---

# Dev Mode: Tmux + Codex Worker

Use this skill when the user asks to start development, fix a bug, or implement a feature using the `#dev` trigger.

## Trigger

Message starts with `#dev`

**Examples:**
- `#dev implement Issue #12`
- `#dev add a new filter to the dashboard`
- `#dev fix [problem description]`

## Step 1: Analyze & Route (Project Selection)

1. **Parse Request:** Extract the task description or Issue number from everything after `#dev`. Store as `<task_desc>`.
2. **Determine Target Project:** Read `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml`. Filter all projects where `local_path != null`.
3. **Auto-match:** Guess the target project based on the context of `<task_desc>`.
4. **Preview & Quick-Select:** Present the plan to the user.

Reply in this exact format:

```
🛠️ Dev Task: <task_desc>
🎯 Target Repo: [auto-matched project name]
确认开始？ 回复 y 直接创建 | 或通过列表重定向：[/sekitoba, /bunny_stack, /jiayou_run, ...]
```

*(Wait for user response before proceeding to Step 2)*

**Response routing:**
- `/id` (e.g. `/sekitoba`) → look up that id in registry.yml, use its `local_path` and `git` fields
- `y` → use the auto-matched project's `local_path` and `git` fields
- Anything else → update the task description, re-display preview, wait again

## Step 2: Prepare Isolation Workspace (Worktree)

Once the project is confirmed, execute the following steps via bash.

**Resolve paths:**
- `<base_path>`: project's `local_path` with `$SOURCE_ROOT` replaced by `${SOURCE_ROOT:-$HOME/source}`
- `<task_id>`: `issue-<N>` if an Issue was referenced, otherwise current Unix timestamp (e.g. `task-1710500000`)
- `<worktree_dir>`: `<base_path>/../agent-worktree-<task_id>`
- `<branch_name>`: `agent/dev-<task_id>`
- `<tmux_session>`: `dev-<task_id>`

**Create git worktree:**

```bash
cd <base_path>
git fetch origin main
git worktree add <worktree_dir> -b <branch_name> origin/main
```

If the branch already exists, report the error and stop.

## Step 3: Prompt Construction & Tmux Launch

**Download images from issue** (if any):

```bash
mkdir -p <worktree_dir>/issue-assets
gh issue view <issue_number> --repo <git_url> --json body,comments \
  --jq '[.body] + (.comments | map(.body)) | join("\n")' \
  | grep -oE 'https://github.com/user-attachments/assets/[^ )]+' \
  | while read url; do
      fname=$(basename "$url" | cut -d'?' -f1)
      [[ "$fname" != *.* ]] && fname="${fname}.png"
      curl -sL "$url" -o "<worktree_dir>/issue-assets/$fname"
    done
```

If no images are found, the directory remains empty — no error.

**Write instruction file** — use unquoted `EOF` so `$()` expands inline:

```bash
cat << EOF > <worktree_dir>/.agent_instruction.txt
# TASK: <task_desc>

# ISSUE DETAILS
$(gh issue view <issue_number> --repo <git_url> --json body,comments \
  --jq '"## OP (Original Poster)\n" + .body + "\n\n## DISCUSSION\n" + (.comments | map("### @" + .author.login + ": " + .body) | join("\n\n"))' 2>/dev/null)

# ASSETS
$(ls <worktree_dir>/issue-assets/ 2>/dev/null | grep -qE '\.' \
  && echo "The following reference images are downloaded in ./issue-assets/ for your reference:\n$(ls <worktree_dir>/issue-assets/)" \
  || echo "No visual assets provided.")

# EXECUTION RULES
1. Multi-turn context: Consider all feedback in the discussion thread above.
2. Implementation: Modify code in <worktree_dir>.
3. Verification: Run local tests if available.
4. Submission: git add . && git commit -m 'feat: <task_desc>' && git push origin <branch_name> && gh pr create --fill
EOF
```

**Copy bundled launcher into worktree:**

```bash
cp scripts/run-codex.sh <worktree_dir>/run-codex.sh
chmod +x <worktree_dir>/run-codex.sh
```

**Kill any existing session with the same name:**

```bash
tmux has-session -t <tmux_session> 2>/dev/null && tmux kill-session -t <tmux_session>
```

**Launch Codex in a detached tmux session:**

```bash
tmux new-session -d -s <tmux_session> -c <worktree_dir> 'bash run.sh; exec bash'
```

## Step 4: Handoff & Report

1. Wait 3 seconds.
2. Capture initial output: `tmux capture-pane -p -t <tmux_session>`
3. Reply with the final status below, then return to Brain mode:

```
✅ Dev 任务已在后台启动！
📂 工作区 (Worktree): <worktree_dir>
🖥️  Tmux Session: <tmux_session>

Codex 正在独立环境中编写代码并准备提交 PR。
👉 监工方式: 在终端输入 tmux attach -t <tmux_session>
```

## Constraints

- Always confirm the target project before creating the worktree
- Never merge directly — Codex must submit a PR via `gh pr create --fill`
- If worktree creation fails (branch exists, dirty state, etc.), report clearly and stop
- One tmux session per task — kill any conflicting session before launching
