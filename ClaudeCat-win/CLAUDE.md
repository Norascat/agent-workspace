# CLAUDE.md

## 工作区结构

```
ClaudeCat/
├── .claude/              # CC 运行态
│   ├── settings.json     # 配置（不做全局）
│   ├── skills/           # 活跃 skill（CC 直接加载）
│   └── tasks/            # 后台任务状态：01_tasks.json + 01_tasks/*.md
├── 01_user/              # 用户个人区 ⚠️ 只读，禁止写
├── 02_claude/            # AI 工作区
│   ├── 01_identity/      # 身份设定
│   ├── 02_skills/
│   │   └── skills.md     # 命令→技能 清单（session-review 自动更新）
│   └── 03_learning/      # 学习笔记
├── 03_conversation/      # 复盘存档：review_{YYYYMMDD}_{slug}.md
└── 04_project/           # 协作项目：{序号}_{项目名}/
```

## 文件规则

- **配置** → `.claude/settings.json`
- **skill 发布** → `.claude/skills/{name}/SKILL.md`（唯一位置，不再双写存档）
- **任务状态** → `.claude/tasks/01_tasks.json` + `.claude/tasks/01_tasks/{file}.md`
- **复盘存档** → `03_conversation/review_{YYYYMMDD}_{slug}.md`
- **新项目** → `04_project/{序号}_{项目名}/`
- **01_user/ 只读** — 禁止任何写操作

## 文件与目录序号规则

- **命名格式**：`{序号}_{名称}`，序号为两位数字，从 `01` 起步，如 `01_user/`、`02_claude/`
- **序号作用域**：序号在**同一父目录下唯一**，不同目录互不干扰
- **递增分配**：新增文件或目录时，取当前父目录下已有最大序号 +1，禁止复用或跳号
- **禁止冲突**：同一目录内不得存在两个相同序号，发现冲突须立即修正
- **重命名迁移**：删除中间序号后，后续序号**不回填**，保持历史可追溯；只有全目录整理时才允许重新编排

## 运作闭环

```
用户输入 → 匹配 skill（.claude/skills/）→ 执行
         → 生成产物 / 更新任务（.claude/tasks/）
         → session-review 复盘（03_conversation/review_*.md）
         → 更新 02_claude/02_skills/skills.md 清单
         → 下次同类任务直接复用 skill
```

**核心：skill 是复用单元。**遇到重复操作立即沉淀为 skill，下次通过清单命中直接调用，避免重复描述、重复推理、重复试错 —— token 不能浪费。

## 思维与行为原则

**思维内核**
- 第一性原理：回归底层问题，区分真实约束与惯性假设，从基本事实推导方案
- 批判性思维：对自己的方案保持怀疑——前提假设是否成立？有没有更简单的路径？
- 资源效率：每个 token 都有成本，有 skill 必用，不做没要求的事，不过度设计

**执行规范**
- **优先用 skill，有适用 skill 必须调用** —— 节省 token，避免重复推理
- **发现重复 → 沉淀 skill** —— 同类操作做过两次就提取，更新 skills.md
- 文件按规则命名放到对应目录，废弃文件立即清除，保持工作区干净
- 零全局依赖，工作区可整体迁移

**协作原则**
- 用户主导方向，我主导执行细节
- `01_user/` 只读，禁止写入
- 破坏性操作主动告知并确认
- 默认中文沟通，代码/技术术语保持英文
