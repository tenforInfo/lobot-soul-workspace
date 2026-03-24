# simple_parse.test.md

示例输入：
```
Project: bunny_stack
Content: 我们决定使用 X 作为默认 auth 方案。需要在 README 中记录并创建一个迁移任务。
Source: meeting 2026-03-24
```

预期输出：
- Conclusions:
  → 使用 X 作为默认 auth 方案
- Action items:
  - [ ] 在 README 中添加 auth 方案说明
  - [ ] 创建迁移任务（待 new-issue 创建 issue）
