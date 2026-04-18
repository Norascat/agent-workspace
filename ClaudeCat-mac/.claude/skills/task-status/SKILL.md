---
name: task-status
description: 查看后台任务状态。用法：/task-status 或 /task-status <id>
---

# Task Status 任务状态查看

查看通过 `/dispatch` 派发的后台任务状态。

## 执行步骤

### 1. 读取注册表

读取 `.claude/tasks/01_tasks.json`

如果文件不存在或 `tasks` 为空数组，输出：
```
暂无后台任务记录。使用 /dispatch "任务描述" 派发第一个任务。
```
然后结束。

### 2. 判断是否有 ID 参数

**无参数**（`/task-status`）：执行「列表模式」
**有 ID 参数**（`/task-status 01`）：执行「详情模式」

---

## 列表模式

输出所有任务的摘要表格：

```
ID   状态        任务                              更新时间
──────────────────────────────────────────────────────────
01   ⏳ running  fix-login-token-expire            2026-04-07 10:05
02   ✅ done     write-api-docs-auth               2026-04-07 11:30
03   ❌ failed   deploy-staging-server             2026-04-07 12:00
```

状态 emoji 规则：
- `running` → ⏳
- `done` → ✅
- `failed` → ❌

---

## 详情模式

1. 在 `tasks` 数组中找到 `id` 匹配的条目
2. 如果找不到，输出：`找不到任务 #{id}，请用 /task-status 查看所有任务列表`
3. 读取该条目的 `file` 字段对应的文件：
   `.claude/tasks/{file}`
4. 输出文件的完整内容
