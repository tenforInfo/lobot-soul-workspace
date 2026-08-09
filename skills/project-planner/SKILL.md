---
name: project-planner
description: Route brainstorms, ideas, and follow-up notes into the correct project by reading the project registry, comparing against existing project docs, and appending structured entries to each project's PLAN.md.
user-invocable: true
metadata:
  version: "0.1.0"
  author: "OpenClaw"
---

# Project Planner Skill

Use this skill when the user wants to:
- record an idea, feature, reminder, or follow-up note
- attach it to the correct project based on the registry
- compare it against existing project docs before writing
- append structured notes into a project's `PLAN.md`

## Core intent

Turn casual chat into a concise project planning record.

Do **not** write detailed product specs or implementation code.
Focus on:
- what to do
- what it is for
- current status
- follow-up thoughts
- open questions

## Inputs

Primary source of truth:
- `${BRAIN_SOURCE:-/Users/tensorinfo/source/bunny_stack}/registry.yml`

Use the registry to:
- find the target project
- resolve the project's `brain_file`
- determine whether the project has issues enabled

If the user references a project indirectly, compare keywords against:
- project `id`
- project `name`
- project `description`

If multiple projects match, ask the user to choose.
If no project matches, ask whether this is a new project.

## Output file policy

The target planning file should usually be:
- `PLAN.md` in the project root, or
- `docs/PLAN.md` if that project already uses docs-based planning

If a project already has a planning file, append to it.
If not, create one from the template below.

## Planning format

Use this structure for each new item:

```md
## [功能/想法名称]
> **添加日期**: YYYY-MM-DD | **状态**: 💡 灵感阶段

- **🎯 核心目标**: 用一句话总结这个功能解决什么问题。
- **🧠 想法与细节**:
  - 要点 1
  - 要点 2
- **📝 待办/探索**:
  - [ ] 下一步需要确认或动手做的第一件事
```

If the item is a follow-up to an existing section, append a dated note under the matching heading instead of creating a duplicate.

## Workflow

### 1) Match project
- Read the registry.
- Match user content to one project.
- If ambiguous, ask the user to choose.

### 2) Load existing project notes
- Read the project's `brain_file` from the registry.
- Check:
  - 核心结论
  - 行动项
  - 未决问题
- Compare incoming content with existing notes.
- If a contradiction exists, surface it before writing.

### 3) Extract and structure
From user content, extract:
- the name of the idea / feature
- its purpose
- current status
- follow-up actions
- open questions

Keep it short and structured.

### 4) Preview before writing
Show the user a preview of the exact block that will be appended.
Ask for confirmation before writing.

### 5) Write
After confirmation:
- append the new structured block to the project's `PLAN.md`
- preserve existing content
- do not rewrite unrelated sections

## Writing rules

- Append only unless the user explicitly requests a rewrite.
- Keep the tone concise.
- Prefer bullets over long paragraphs.
- If the user says “记一下”, “加到 plan 里”, or similar, treat it as a planning record.
- If the content is incomplete, record it under “灵感与想法” or “待办/探索”.
- If the content is confirmed, record it under “待办/探索” or the active section.

## Minimum template for new PLAN.md

```md
# [项目名] Plan

> 状态：进行中 / 待确认 / 已完成 / 暂停

## 当前重点
- 

## 灵感与想法
- 

## 待办
- [ ] 

## 已确认
- [x] 

## 备注
- 
```

## Confirmation message

After updating the file, report:

`已将关于 [主题] 的想法更新到 [文件路径]。`

If there are multiple items, include a short count of what was added.
