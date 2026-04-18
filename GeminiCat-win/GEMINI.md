# GEMINI.md

## 工作区结构 (GeminiCat)

```
GeminiCat/
├── .gemini/              # Gemini 运行态 (适配自 .claude)
│   ├── settings.json     # 配置
│   ├── skills/           # 活跃 skill
│   └── tasks/            # 后台任务状态
├── 01_user/              # 用户个人区 ⚠️ 只读，禁止写
├── 02_gemini/            # AI 工作区 (原 02_claude)
│   ├── 01_identity/      # 身份设定
│   ├── 02_skills/
│   │   └── skills.md     # 命令→技能 清单
│   └── 03_learning/      # 学习笔记
├── 03_conversation/      # 复盘存档：review_{YYYYMMDD}_{slug}.md
└── 04_project/           # 协作项目：{序号}_{项目名}/
```

## 文件规则

- **核心指令** → `GEMINI.md` (本文件，最高优先级)
- **配置** → `.gemini/settings.json`
- **skill 发布** → `.gemini/skills/{name}/SKILL.md` (调用 `activate_skill` 加载)
- **任务状态** → `.gemini/tasks/01_tasks.json`
- **01_user/ 只读** — 禁止任何写操作

## 命名规范

- **序号逻辑**：遵循 `{序号}_{名称}` 格式（如 `01_user/`），序号在父目录下唯一。
- **递增原则**：新增内容取最大序号 +1，禁止复用或跳号。

## 运作闭环

1. **意图识别**：匹配 `skills.md` 中的命令或场景。
2. **技能激活**：使用 `activate_skill` 加载对应技能。
3. **执行与记录**：执行任务并在 `.gemini/tasks/` 更新状态。
4. **复盘沉淀**：通过 `session-review` 总结并更新 `02_gemini/02_skills/skills.md`。

## 思维原则

- **Gemini 优先**：充分利用 Gemini CLI 的并行工具执行能力。
- **上下文效率**：优先使用 `grep_search` 和 `read_file` 的行号读取，减少 token 浪费。
- **技能驱动**：同类操作做过两次必须提取为 skill。
- **macOS 适配**：所有脚本和路径需符合 Darwin 规范。

**协作原则**：用户决定"做什么"，我决定"怎么做"。`01_user/` 绝对禁止写入。
