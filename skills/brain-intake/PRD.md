# PRD: brain-intake Skill Refactor

背景
当前 brain-intake 与 new-issue 在职责上存在重叠（如 action item -> issue 的直创建），导致维护成本和不确定性。目标是将两者严格分离，降低耦合并提供明确的迁移路径。

目标
- 明确职责边界，移除直接创建 Issue 的行为
- 提供可测试的输入/输出接口
- 完整的文档和迁移计划

功能需求
Must:
- 输入解析、项目匹配、历史对比、结论/行动提取、写入 brain_file、预览与确认
- 对冲突进行交互式处理
- 生成可被 new-issue 使用的 action list（但不自动创建 issue）

Nice-to-have:
- 可选交互：确认后调用 new-issue（通过明确的用户授权）
- 单元测试与 CI 校验

迁移与回退
- 在 PR 中保留原始 skill 文件副本
- 提供 MIGRATION.md 指南，导出未完成 action 并转为 issues（由用户或 new-issue 执行）

里程碑
1. 设计文档 & README（本次提交）
2. 实现：解析器与提取逻辑的重构
3. 测试：单元测试、集成示例
4. PR 提交与 review

验收准则
- 提交设计文档并在仓库中新增/更新 skill 文件
- 提交包含代码与文档改动的 PR（或多个分阶段 PR）并列出回滚步骤
- 新增的内容包含基本测试或验证步骤
