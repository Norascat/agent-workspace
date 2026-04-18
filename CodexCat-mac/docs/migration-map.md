# Workspace Migration Map

## 结构调整

| 旧机制 | 新机制 | 说明 |
|---|---|---|
| 旧运行态根目录 | `.codex/` | 统一为 Codex 运行态 |
| 旧技能目录 | `.codex/skills/` | 技能整体迁移并改写 |
| 旧任务目录 | `.codex/tasks/` | 任务注册表与任务卡片统一收口 |
| 旧 AI 元数据目录 | `02_codex/` | 身份、技能索引、学习资料统一收口 |
| 旧根规则文档 | `AGENTS.md` | 根规则入口统一改名 |

## 能力替换

| 旧能力 | 新形式 |
|---|---|
| 启动工作区 | `bin/start-codex` |
| 登记任务 | `bin/dispatch-task` |
| 查看任务 | `bin/task-status` |
| 生成复盘 | `bin/session-review` |
| 技能索引 | `02_codex/02_skills/skills.md` |
| 配置模板 | `.codex/config.json.template` |

## 明确不伪装的产品能力

以下行为改为文档说明，不伪装成不存在的命令：

- 清空当前会话
- 恢复上一会话
- 切换模型

## 保留的核心机制

- skill 目录与引用式工作流
- 任务注册表与任务卡片
- 复盘归档目录
- 编号目录规范
- `01_user/` 只读约定
- 一键安装与可迁移工作区设计
