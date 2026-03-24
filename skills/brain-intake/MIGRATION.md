# MIGRATION / REMOVAL Guide — brain-intake

当决定移除或重构 brain-intake 时的步骤：

1. 备份现有 brain_file
  - 在 ${BRAIN_SOURCE}/backup/ 保存所有受影响的 brain_file 副本

2. 导出未完成的行动项
  - 扫描各项目 README 中的 "行动项" 部分，收集未勾选的条目。
  - 将其汇总到 /tmp/brain_intake_actions_<timestamp>.md

3. 将行动项迁移为 Issues（可选）
  - 使用 new-issue 批量创建 issues，或由用户手动创建。

4. 删除或重命名旧 skill 目录
  - 将 skills/brain-intake/ 重命名为 skills/brain-intake.bak（保留历史）

5. 回退
  - 若需回退：恢复备份文件并将 skills/brain-intake.bak 恢复为原名，revert 对应 PR。

注意：任何自动迁移步骤必须先征得用户确认。
