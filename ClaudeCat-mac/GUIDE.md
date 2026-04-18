# ClaudeCat — AI 协作工作区

---

## 协作方法论

### 启动

点击此文件夹右键 → 在终端中打开，输入 `claude` 回车。

### 开新项目

告诉 Claude「开一个新项目，需求是……」，把总体要求说清楚，让它整理成项目里的 `CLAUDE.md`。这样项目记忆就固定下来——即使 `/clear` 清空对话，下次 Claude 照样能读到背景。

### 日常节奏

| 场景 | 做法 |
|------|------|
| 直接问问题 | 窗口对话，点对点解决 |
| 复杂任务 | 交给 Claude，superpowers skill 自动调用规划/调试能力 |
| 上下文太长 | `/clear` 新建对话，`CLAUDE.md` 里的项目记忆不会丢 |
| 切换任务、不想等结果 | `/dispatch` 派到后台 |
| 看多个任务进度 | `/task-status` |
| 回到之前的对话 | `/resume` |
| 阶段结束 | `/session-review` 复盘，提炼可复用 skill |

### 常用命令

| 命令 | 作用 |
|------|------|
| `/clear` | 新建对话 |
| `/resume` | 恢复上一个对话 |
| `/dispatch "任务描述"` | 派发后台任务 |
| `/task-status` | 查看任务进度 |
| `/session-review` | 对话复盘 |
| `/status` | 查看 token 用量 / 账号状态 |
| `/model` | 切换模型（Opus / Sonnet / Haiku） |
| `/help` | 查看所有命令 |

---

## 第一步：安装依赖

### 运行配置脚本

1. 打开这个文件夹
2. 双击 `setup.bat`（弹安全提示选「仍要运行」）

脚本自动检测环境并配置。缺少软件按下面安装：

### Node.js（必须）

打开 https://nodejs.org，点绿色按钮下载，一路「下一步」装完。

### Claude Code（必须）

装完 Node.js 后，`Win + R` 输入 `cmd` 回车：

```bash
npm install -g @anthropic-ai/claude-code
claude login
```

按提示登录 Anthropic 账号（注册：https://console.anthropic.com）

### Git（可选）

https://git-scm.com，一路默认安装。

装完后重新运行 `setup.ps1`，全部绿色 ✓ 即可。

---

## 第二步：启动

打开命令行（cmd 或 PowerShell）：

```bash
cd "这个文件夹的完整路径"
claude
```

---

## 第三步：快捷键

| 快捷键 | 作用 |
|--------|------|
| `Shift + Tab` | 切换模式（Plan 规划 / Code 执行） |
| `Alt + V` | 粘贴截图给 Claude |
| `Ctrl + C` 两次 | 撤销当前输入 |

**.md 文档用 VSCode 打开**，按 `Ctrl + Shift + V` 实时预览。

---

## 第四步：核心命令详解

### 对话管理

| 命令 | 作用 |
|------|------|
| `/clear` | 新建对话 |
| `/resume` | 恢复上一个对话 |
| `/model` | 切换模型 |
| `/status` | 查看 token 用量 |
| `/help` | 所有命令列表 |

### 后台任务

| 命令 | 作用 |
|------|------|
| `/dispatch "任务"` | 派发后台任务，不用等，继续聊别的 |
| `/task-status` | 查看所有任务进度 |
| `/task-status 01` | 查看某个任务详情 |

### 工作流

| 命令 | 作用 |
|------|------|
| `/session-review` | 对话复盘，总结决定和待办 |
| `/skill-creator` | 把重复操作做成技能，以后自动触发 |

---

## 第五步：验证

| # | 输入 | 期望结果 |
|---|------|----------|
| 1 | `有哪些可用的技能` | 列出技能名称 |
| 2 | `/dispatch "创建 04_project/hello.txt，内容写 Hello"` | 后台任务启动 |
| 3 | `/task-status` | 任务状态为 done |
| 4 | `/session-review` | 生成复盘文件 |

---

## 第六步：文件夹结构

| 文件夹 | 用途 | 能改吗 |
|--------|------|--------|
| `01_user/` | 你的个人资料 | 随便放 |
| `02_claude/` | Claude 的身份、技能、学习笔记 | 别手动改 |
| `03_conversation/` | 对话复盘存档 | 只读 |
| `04_project/` | 协作项目 | 主战场 |
| `.claude/` | 配置、技能、任务状态 | 别手动改 |

---

## 常见问题

**输入 claude 提示「不是内部命令」**：Node.js 没装好，或装完没重启命令行。

**claude login 失败**：检查网络，确认账号已在 https://console.anthropic.com 注册。

**对话太长**：`/clear` 新建，`/resume` 可以恢复。

**怎么预览 .md 文件**：VSCode 打开，`Ctrl + Shift + V`。

**手机操控**：用 ToDesk 远程桌面。
