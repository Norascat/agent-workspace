# Skills 清单 (GeminiCat)

> session-review 自动维护。触发场景/命令 → 技能名。

## 核心命令 (使用 activate_skill 显式加载)

| 命令/意图 | 技能名 | 作用 |
|------|------|------|
| 派发后台任务 | generalist / codebase_investigator | 使用 Gemini 的子代理能力 |
| `/task-status` | (内置于 .gemini/tasks) | 查看后台任务进度 |
| `/session-review` | session-review | 复盘当前对话，归档到 03_conversation/ |
| `创建新技能` | skill-creator | 创建/优化/评测 skill |

## 自动触发 (按场景匹配后激活)

| 场景关键词 | 技能名 |
|------------|------|
| 启动对话 / 开始新任务 | using-superpowers |
| 创意工作前 (建功能、设计) | brainstorming |
| 多步任务规划 | writing-plans |
| 执行已写好的 plan | executing-plans |
| 写新 skill / 改 skill | writing-skills |
| 实现功能 / 修 bug 前 | test-driven-development |
| Bug / 测试失败 / 异常行为 | systematic-debugging |
| 声明 "完成" 前 | verification-before-completion |
| 请求 code review | requesting-code-review |
| 收到 code review | receiving-code-review |
| 完成开发分支收尾 | finishing-a-development-branch |
| 需要隔离的 feature 工作 | using-git-worktrees |

## Hooks

无。
