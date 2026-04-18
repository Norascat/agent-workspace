# Agent Workspace — 人机协作工作区安装包

这个仓库是**人机协作打造区**的可交付安装包集合，涵盖三款主流 AI Agent，每款均提供 macOS 和 Windows 两个版本，按需下载即可搭建完整的本地 AI 协作工作区。

---

## 版本一览

| AI 模型 | 平台 | 文件夹 | CLI 工具 |
|---------|------|--------|---------|
| Claude (Anthropic) | macOS | `ClaudeCat-mac/` | `claude` |
| Claude (Anthropic) | Windows | `ClaudeCat-win/` | `claude` |
| Codex (OpenAI) | macOS | `CodexCat-mac/` | `codex` |
| Codex (OpenAI) | Windows | `CodexCat-win/` | `codex` |
| Gemini (Google) | macOS | `GeminiCat-mac/` | `gemini` |
| Gemini (Google) | Windows | `GeminiCat-win/` | `gemini` |

---

## 下载与安装

### 第一步：下载对应版本

按照你使用的 AI 模型和操作系统，只下载对应的文件夹：

```
# 示例：只需要 Claude + macOS 版本
下载 / Clone 后，只使用 ClaudeCat-mac/ 目录
```

> 也可以克隆整个仓库，按需使用其中一个文件夹。

### 第二步：进入目录，运行安装脚本

**macOS**

```bash
cd ClaudeCat-mac      # 或 CodexCat-mac / GeminiCat-mac
bash install.sh       # 或双击 setup.command
```

**Windows**

```
进入 ClaudeCat-win    # 或 CodexCat-win / GeminiCat-win
双击 setup.bat        # 或右键用 PowerShell 运行 setup.ps1
```

### 第三步：启动 AI

| 版本 | 启动命令 |
|------|---------|
| ClaudeCat | `claude` |
| CodexCat | `bin/start-codex`（mac）/ `start-codex.cmd`（win） |
| GeminiCat | `gemini` |

---

## 工作区结构

每个安装包都是独立完整的工作区，结构如下：

```
{AI}Cat-{platform}/
├── 01_user/          # 个人文档区（只读，AI 不写入）
├── 02_{ai}/          # AI 身份 / 技能清单 / 学习笔记
├── 03_conversation/  # 对话复盘存档
├── 04_project/       # 协作项目主战场
└── .{ai}/            # 技能、任务状态（运行态配置）
```

---

## 核心理念

- **技能复用**：遇到重复操作立即提炼为 skill，下次自动调用
- **零全局依赖**：工作区可整体打包迁移
- **人主导方向，AI 主导执行**：通过 `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` 固化项目背景

---

## 关于本仓库

这是一个私密仓库，仅供授权协作者使用。工作区由人机协作共同打造和迭代，持续演进中。
