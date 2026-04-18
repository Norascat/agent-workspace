---
name: dispatch
description: 将任务登记到工作区任务注册表，并生成任务卡片。适用于用户想记录一个后续任务、拆出独立待办、或维护工作区任务列表时。对应脚本：bin/dispatch-task "任务描述"
---

# Dispatch 任务登记

将用户描述的任务登记到工作区任务注册表，生成一张任务卡片，方便后续跟踪。这个 skill 只负责维护任务状态文件，不伪装成后台执行器。

## 执行步骤

### 1. 读取任务注册表

读取文件：`.codex/tasks/01_tasks.json`（相对于工作区根目录）

如果文件不存在，创建它：
```json
{"tasks": []}
```

### 2. 计算下一个任务 ID

取 `tasks` 数组长度 + 1，格式化为两位数字（如 `01`、`02`、`10`）。

### 3. 生成 slug

从用户输入的任务描述中提取前 3-4 个有意义的词，转小写，空格替换为连字符。
示例：`"修复登录模块 token 过期问题"` → `fix-login-token-expire`

### 4. 生成时间戳

格式：`YYYYMMDDHHmmss`，使用当前本地时间。

### 5. 确定文件名

格式：`{id}_{timestamp}_{slug}.md`

### 6. 写入任务详情文件

路径：`.codex/tasks/01_tasks/{文件名}`

```markdown
# 任务：{slug}
状态：running | 开始：{YYYY-MM-DD HH:mm}

## 目标
{用户传入的完整任务描述}

## 进度日志

## 结果
```

### 7. 更新任务注册表

在 `01_tasks.json` 的 `tasks` 数组末尾追加：

```json
{
  "id": "{id}",
  "slug": "{slug}",
  "file": "01_tasks/{文件名}",
  "status": "running",
  "created_at": "{ISO8601时间}",
  "updated_at": "{ISO8601时间}",
  "summary": "{任务描述前50字符}"
}
```

### 8. 输出确认信息

```
任务 #{id} 已登记 ✓
描述：{任务描述}
查看进度：bin/task-status {id}
```
