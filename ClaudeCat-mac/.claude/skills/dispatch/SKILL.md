---
name: dispatch
description: 将任务派发给后台 agent 执行。用法：/dispatch "任务描述"
---

# Dispatch 后台任务

将用户描述的任务派发给后台 agent 执行。执行期间用户可自由切换对话，后台 agent 会实时更新任务状态文件。

## 执行步骤

### 1. 读取任务注册表

读取文件：`.claude/tasks/01_tasks.json`（相对于工作区根目录）

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

路径：`.claude/tasks/01_tasks/{文件名}`

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

### 8. 派发后台 agent

使用 `Agent` 工具，参数：
- `run_in_background: true`
- `prompt` 内容如下（用实际值填入）：

```
你是一个后台任务执行 agent。

任务描述：{用户的完整任务描述}

状态文件路径：.claude/tasks/01_tasks/{文件名}
注册表路径：.claude/tasks/01_tasks.json
任务 ID：{id}

执行要求：

1. 按任务描述完成工作，你有完整权限：读写文件、运行命令

2. 每完成一个阶段，在状态文件的"## 进度日志"部分追加一行：
   `- {HH:mm} {做了什么}`
   同时更新注册表中该任务的 updated_at 字段为当前时间

3. 全部完成后：
   a. 在"## 结果"写入摘要
   b. 状态文件第一行 running → done（失败则 failed）
   c. 注册表 status 改 done/failed，更新 updated_at
```

### 9. 输出确认信息

```
后台任务 #{id} 已启动 ✓
描述：{任务描述}
查看进度：/task-status {id}
```
