# brain-intake Skill — Refactor Draft

目的：明确 brain-intake 的职责为“项目归档与 intake 流程”，并移除 issue-creation 职责（由 new-issue 负责）。

职责边界
- brain-intake: 负责接收项目相关内容，将结论、行动项、未决问题整理并追加到项目的 brain_file（项目 README 指定位置）。负责匹配项目、对比历史、提取结论与行动项、生成写入预览并在用户确认后写入并 push。
- new-issue: 负责作为 PM 风格的 GitHub issue 创建器；当需要将行动项转换为 issue，必须由 new-issue 在用户确认后创建。

输入与接口
- 支持输入格式：plain text / markdown / URL / transcript
- 必需字段（建议）：
  - project_hint (可选): 项目 id/name 的提示
  - content: 要归档的文本
  - source (可选): 来源（如 slack, email, meeting）
  - author (可选)

主要流程
1. 匹配项目（registry.yml）
2. 加载项目历史（brain_file）
3. 检测冲突/矛盾并提示用户
4. 提取：结论 (1-3)，行动项，未决问题
5. 预览并征求用户确认
6. 在确认后写入 brain_file（并可选触发 new-issue 创建 issues）并 push

示例片段
职责边界示例：
> brain-intake 负责把项目相关结论与行动归档到 external brain 的 README（brain_file），并在需要时生成可供 new-issue 创建 issue 的待办列表；绝不直接创建 GitHub issue 或替代 new-issue 的 PM 职责。

验收标准引用
详见 issue #32
