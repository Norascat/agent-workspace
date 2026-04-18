# CodexCat — AI 协作工作区

---

## 协作方法论

### 启动

打开 Finder，右键此文件夹，选择“新建位于文件夹位置的终端窗口”，运行：

```bash
bin/start-codex
```

### 开新项目

直接告诉 Codex 你的目标、约束和验收标准。把长期有效的项目背景整理到项目目录中的 `AGENTS.md` 或相关文档里，这样即使重开会话，工作区规则和项目上下文也都还在。

### 日常节奏

| 场景 | 做法 |
|------|------|
| 直接问问题 | 在当前会话里点对点处理 |
| 复杂任务 | 交给 Codex，工作区内的 skills 会约束规划、调试、验证流程 |
| 切换任务 | 新开会话，项目规则放在工作区文档中持续生效 |
| 想登记一个后续任务 | `bin/dispatch-task "任务描述"` |
| 看任务进度 | `bin/task-status` |
| 阶段结束做复盘 | `bin/session-review [slug]` |

### 工作区脚本

| 脚本 | 作用 |
|------|------|
| `bin/start-codex` | 在当前工作区内启动 Codex |
| `bin/dispatch-task "任务"` | 登记一个工作区任务并生成任务卡片 |
| `bin/task-status [id]` | 查看任务注册表，或查看单个任务 |
| `bin/session-review [slug]` | 生成本次工作的复盘模板 |

---

## 第一步：安装依赖

### 运行配置脚本

1. 打开此文件夹
2. 双击 `setup.command`
3. 如果首次运行被 macOS 拦截，右键 `setup.command`，选择“打开”

也可以在终端执行：

```bash
bash install.sh
```

### 自动安装行为

`install.sh` 会优先自动补齐本工作区需要的工具：

- 缺 `node`、`python3`、`git` 时，如果本机已有 Homebrew，会直接执行 `brew install ...`
- 缺 `codex` 时，如果本机有 `npm`，会直接执行 `npm install -g @openai/codex`
- 不会自动执行 `codex login`

如果机器上缺少 Homebrew，而又少了系统工具，脚本会给出明确提示，让对方手动补装。

---

## 第二步：初始化工作区

在工作区根目录运行：

```bash
bash install.sh
```

初始化完成后，工作区会自动：

- 创建 `.codex/` 运行态目录
- 生成 `.codex/config.json`
- 初始化任务注册表
- 校验脚本权限

---

## 第三步：启动 Codex

在工作区根目录运行：

```bash
bin/start-codex
```

或者先进入目录再运行：

```bash
cd "/path/to/this/folder"
codex
```

---

## 第四步：验证

| # | 输入 | 期望结果 |
|---|------|----------|
| 1 | `bin/task-status` | 打印任务注册表 |
| 2 | `bin/dispatch-task "创建 04_project/hello.txt，内容写 Hello"` | 生成一个任务卡片 |
| 3 | `bin/task-status` | 新任务出现在列表里 |
| 4 | `bin/session-review smoke-test` | 生成复盘文件 |

---

## 第五步：文件夹结构

| 文件夹 | 用途 | 说明 |
|--------|------|------|
| `01_user/` | 个人资料 | 按工作区约定视为只读 |
| `02_codex/` | 身份、技能索引、学习笔记 | AI 工作区元数据 |
| `03_conversation/` | 复盘存档 | `review_*.md` 存放位置 |
| `04_project/` | 协作项目 | 主工作区 |
| `.codex/` | 配置、技能、任务状态 | 工作区运行态 |
| `bin/` | 本地脚本入口 | 启动、任务、复盘 |

---

## 常见问题

**双击 `setup.command` 没反应**

右键文件，选择“打开”，或改用终端执行：

```bash
chmod +x setup.command
bash install.sh
```

**输入 `codex` 提示 `command not found`**

说明 Codex CLI 尚未安装，或安装后当前终端没有刷新环境变量。先确认本机 Codex CLI 的安装方式，然后重新打开终端。

**想清空上下文重新开始**

直接新开一个会话即可。工作区规则、技能和项目文档仍保留在文件系统中。

**想回看上一阶段做了什么**

查看 `03_conversation/` 下的复盘文件，或运行：

```bash
bin/session-review my-topic
```

**任务脚本会自动执行后台 agent 吗**

不会。`bin/dispatch-task` 是任务登记工具，用来记录待办和进度，不会伪装成不存在的产品能力。
