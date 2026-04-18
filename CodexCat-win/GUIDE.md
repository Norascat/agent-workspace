# CodexCat for Windows

---

## 启动方式

普通 Windows 用户建议直接双击：

- `setup.cmd`：初始化工作区并自动补装常见依赖
- `start-codex.cmd`：在当前工作区根目录启动 Codex

如果你更习惯 PowerShell，也可以在工作区根目录执行：

```powershell
.\install.ps1
.\bin\start-codex.ps1
```

## 自动安装行为

`install.ps1` 会尽量自动补齐工作区需要的工具：

- 缺 `git`、`python3`、`node` 时，如果机器有 `winget`，会自动执行 `winget install ...`
- 缺 `codex` 时，如果机器已有 `npm`，会自动执行 `npm install -g @openai/codex`
- 不会自动执行 `codex login`

如果缺少 `winget`，脚本会给出明确提示，让用户手动安装。

## 初始化后可用入口

| 入口 | 作用 |
|------|------|
| `start-codex.cmd` | 启动 Codex |
| `bin\dispatch-task.cmd "任务"` | 登记任务并生成任务卡片 |
| `bin\task-status.cmd [id]` | 查看任务列表或单个任务 |
| `bin\session-review.cmd [slug]` | 生成复盘模板 |

## 文件夹结构

| 文件夹 | 用途 |
|--------|------|
| `01_user\` | 用户资料，按约定只读 |
| `02_codex\` | 身份、技能索引、学习笔记 |
| `03_conversation\` | 会话复盘 |
| `04_project\` | 协作项目 |
| `.codex\` | 配置、技能、任务状态 |
| `bin\` | PowerShell 与 CMD 入口 |

## 常见问题

**双击 `setup.cmd` 后闪退**

优先改用 PowerShell 打开工作区目录，再执行：

```powershell
.\install.ps1
```

**提示 `codex` 找不到**

说明 Codex CLI 尚未安装，或刚安装完当前终端还没刷新。重新打开 PowerShell，再运行 `start-codex.cmd`。

**PowerShell 提示执行策略拦截**

本分发包的 `.cmd` 入口已经会使用 `-ExecutionPolicy Bypass` 调用脚本。直接双击 `.cmd` 文件即可。

**任务脚本会自动执行后台 agent 吗**

不会。`dispatch-task` 只是工作区任务登记工具，不伪装成不存在的产品能力。
