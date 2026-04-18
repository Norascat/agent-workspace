# Skills 清单

> session-review 自动维护。命令/触发词 → 技能名。

## 显式命令（用户直接输入）

| 命令 | 技能 | 作用 |
|------|------|------|
| `/dispatch "任务"` | dispatch | 派发后台 agent 执行任务 |
| `/task-status [id]` | task-status | 查看后台任务进度 |
| `/session-review` | session-review | 复盘当前对话，归档到 03_conversation/ |
| `/skill-creator` | skill-creator | 创建/优化/评测 skill |

## 自动触发（按场景命中）

| 场景关键词 | 技能 |
|------------|------|
| 启动对话 / 开始任务 | using-superpowers |
| 创意工作前（建功能、设计） | brainstorming |
| 多步任务规划 | writing-plans |
| 执行已写好的 plan | executing-plans |
| 2+ 独立任务并行 | dispatching-parallel-agents |
| 用 subagent 跑独立任务 | subagent-driven-development |
| 写新 skill / 改 skill | writing-skills |
| 实现功能 / 修 bug 前 | test-driven-development |
| Bug / 测试失败 / 异常行为 | systematic-debugging |
| 声明"完成"前 | verification-before-completion |
| 请求 code review | requesting-code-review |
| 收到 code review | receiving-code-review |
| 完成开发分支收尾 | finishing-a-development-branch |
| 需要隔离的 feature 工作 | using-git-worktrees |

## Hooks

无。
