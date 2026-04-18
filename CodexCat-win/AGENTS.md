# AGENTS.md

## 工作区结构

```text
CodexCat/
├── .codex/              # 工作区运行态
│   ├── config.json      # 本地生成的配置
│   ├── config.json.template
│   ├── skills/          # 工作区可用 skills
│   └── tasks/           # 任务注册表与任务文件
├── 01_user/             # 用户个人区，按约定只读
├── 02_codex/            # AI 工作区
│   ├── 01_identity/     # 身份设定
│   ├── 02_skills/       # 技能索引
│   └── 03_learning/     # 学习笔记
├── 03_conversation/     # 复盘存档
└── 04_project/          # 协作项目
```

## 文件规则

- **配置** → `.codex/config.json`
- **skill 发布** → `.codex/skills/{name}/SKILL.md`
- **任务状态** → `.codex/tasks/01_tasks.json` + `.codex/tasks/01_tasks/{file}.md`
- **复盘存档** → `03_conversation/review_{YYYYMMDD}_{slug}.md`
- **新项目** → `04_project/{序号}_{项目名}/`
- **`01_user/` 只读**，禁止写入

## 文件与目录序号规则

- **命名格式**：`{序号}_{名称}`，序号两位，从 `01` 起
- **序号作用域**：仅在同一父目录下唯一
- **递增分配**：新增文件或目录时，取当前父目录最大序号加一
- **禁止冲突**：同一目录内不得存在两个相同序号
- **不回填历史空位**：删除中间序号后，后续编号不回填

## 运作闭环

```text
用户输入
  -> 匹配 skill（.codex/skills/）
  -> 执行工作
  -> 生成产物 / 更新任务（.codex/tasks/）
  -> 复盘归档（03_conversation/review_*.md）
  -> 更新 02_codex/02_skills/skills.md
```

核心原则是：**skill 是复用单元**。重复流程应尽快沉淀为 skill，而不是每次重新描述。

## 思维与行为原则

### 思维内核

- 第一性原理：先辨别真实约束，再推导方案
- 批判性思维：持续检查前提是否成立，避免惯性假设
- 资源效率：有 skill 必用，不做无要求的扩展，不做过度设计

### 执行规范

- 优先使用 skill，减少重复推理
- 发现重复流程，应沉淀为 skill
- 文件按规则命名并放到对应目录
- 废弃文件及时清理，保持工作区干净
- 工作区应可整体迁移，避免隐式全局依赖

### 协作原则

- 用户主导方向，执行细节由 agent 负责
- 破坏性操作前主动确认
- 默认中文沟通，代码与技术术语保持英文
