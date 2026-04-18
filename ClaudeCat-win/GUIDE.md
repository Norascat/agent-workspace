# ClaudeCat — AI 协作工作区

---

## 协作方法论

### 启动

打开 Finder，右键此文件夹 → 「新建位于文件夹位置的终端窗口」，输入 `claude` 回车。

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

1. 打开此文件夹
2. **双击 `setup.command`**（首次弹安全提示 → 右键 → 打开）

脚本自动检测环境并配置。缺少软件按下面安装：

### Node.js（必须）

**方式 A — Homebrew（推荐）：**

```bash
# 先安装 Homebrew（如未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install node
```

**方式 B — 官网安装包：** 访问 https://nodejs.org，下载 macOS .pkg，双击安装。

### Claude Code（必须）

装完 Node.js 后，打开终端：

```bash
npm install -g @anthropic-ai/claude-code
claude login
```

按提示登录 Anthropic 账号（注册：https://console.anthropic.com）

### Git（可选）

macOS 通常已预装。终端输入 `git --version` 确认；若弹提示点「安装」即可（Xcode Command Line Tools）。

装完后重新运行 `setup.command`，全部绿色 ✓ 即可。

---

## 第二步：启动

打开终端，cd 到此文件夹：

```bash
cd "/path/to/this/folder"
claude
```

**快捷方式：** 打开 Finder，把文件夹拖到终端图标 → 自动 cd 进去。

---

## 第三步：快捷键

| 快捷键 | 作用 |
|--------|------|
| `Shift + Tab` | 切换模式（Plan 规划 / Code 执行） |
| `Ctrl + V` | 粘贴截图给 Claude（截图后直接粘贴） |
| `Ctrl + C`  | 撤销当前输入 |

**.md 文档用 VSCode 打开**，按 `Cmd + Shift + V` 实时预览。

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

**双击 setup.command 没反应或「无法打开」**：
右键 → 打开 → 点「打开」（绕过 Gatekeeper 首次验证）。
或终端执行：`chmod +x setup.command && bash install.sh`

**输入 `claude` 提示「command not found」**：
Node.js 未正确安装，或安装后未重启终端。
执行 `source ~/.zshrc`（或 `source ~/.bash_profile`）刷新环境变量。

**`claude login` 失败**：检查网络，确认账号已在 https://console.anthropic.com 注册。

**对话太长**：`/clear` 新建，`/resume` 可以恢复。

**怎么预览 .md 文件**：VSCode 打开，`Cmd + Shift + V`。

**手机操控 Mac**：用 ToDesk 或 Screen Sharing 远程桌面。
