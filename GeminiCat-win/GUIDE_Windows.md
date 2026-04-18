# GeminiCat — AI 协作工作区 (Windows 版)

---

## 协作方法论

### 启动

在文件夹内右键点击「在终端中打开」，输入 `gemini` 回车。

### 开新项目

告诉 Gemini「开一个新项目，需求是……」，让它整理成项目里的 `GEMINI.md`。这样项目背景就能跨 session 持久化。

### 日常节奏

| 场景 | 做法 |
|------|------|
| 直接问问题 | 窗口对话，快速解决 |
| 复杂任务 | 使用 `activate_skill` 手动加载技能，或依赖自动触发 |
| 并行任务 | 使用 `generalist` 或 `codebase_investigator` 子代理 |
| 阶段结束 | 使用 `session-review` 技能复盘并提炼经验 |

---

## 第一步：环境配置 (Windows)

### 运行配置脚本

1. 打开该文件夹
2. 双击运行 `setup.bat` (会自动调用 PowerShell 执行环境检测)
3. 脚本会自动初始化 `.gemini` 运行态目录。

### 核心软件

- **Node.js**: [https://nodejs.org](https://nodejs.org) (下载 LTS 版本安装)
- **Gemini CLI**: 在终端运行 `npm install -g @google/gemini-cli`
- **登录**: `gemini login`

---

## 第二步：常见操作

| 意图 | 命令 |
|------|------|
| 查找文件 | `glob` |
| 搜索内容 | `grep_search` |
| 加载技能 | `activate_skill` |
| 进入规划模式 | `enter_plan_mode` |

---

## 第三步：目录结构

| 文件夹 | 用途 | 读写规则 |
|--------|------|--------|
| `01_user/` | 用户个人资料/文档 | **只读** (AI 禁止写入) |
| `02_gemini/` | Gemini 的身份、技能清单、学习笔记 | AI 维护 |
| `03_conversation/` | 对话复盘存档 (.md) | 归档区 |
| `04_project/` | 实际项目开发区 | **主战场** |
| `.gemini/` | 技能实现 (SKILL.md) 与任务状态 | 运行态配置 |

---

## 常见问题

**PowerShell 禁止运行脚本**：以管理员身份运行 PowerShell，输入 `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`。
**命令没找到**：如果装完 `npm install -g` 后找不到 `gemini` 命令，可能需要重启电脑或手动将 npm 的 bin 目录添加到环境变量 PATH 中。
**一键迁移**：直接复制整个文件夹到另一台电脑，双击 `setup.bat` 即可恢复生产力环境。
