---
name: session-review
description: "Review and summarize the current conversation session. Use this skill whenever the user says 'review', 'summarize session', 'session summary', 'wrap up', 'what did we do', 'checklist', or any variation of wanting to look back at what happened in the conversation. Also triggers on Chinese equivalents like '复盘', '总结', '回顾对话', '收尾'. Always use this skill at the end of a working session, even if the user just says 'done' or 'finished' — offer to run a review."
---

# Session Review

When a working session ends, this skill helps capture what happened and extract lasting value from it. The goal is threefold:

1. **Summarize** — What was accomplished, what decisions were made, what's still open
2. **Extract reusable workflows** — If the same pattern appeared multiple times (or would clearly recur in future sessions), turn it into a skill
3. **Update the inventory** — Keep a living checklist of all available tools (skills, hooks, plugins) so the user always knows what's at their disposal

The reason this matters: conversations are ephemeral, but the workflows discovered in them shouldn't be. A user who spends 30 minutes figuring out a multi-step process shouldn't have to rediscover it next time. This skill is the bridge between "we did it once" and "it's automated forever."

## Step 1: Conversation Analysis

Read through the entire conversation and identify:

- **Tasks completed** — What did the user ask for? What got done?
- **Decisions made** — Any architectural choices, tool selections, or trade-offs
- **Problems solved** — Bugs fixed, errors debugged, workarounds found
- **Repeated patterns** — Did you do something similar more than once? Did you follow a multi-step process that could be templated?
- **Unfinished work** — Anything started but not completed, or explicitly deferred

Write a concise review report. Structure it like this:

```markdown
# Session Review — {date}

## Completed
- {task 1}: {one-line summary}
- {task 2}: {one-line summary}

## Key Decisions
- {decision}: {why}

## Problems & Solutions
- {problem}: {how it was solved}

## Open Items
- {item}: {status/next step}
```

Save this report to `03_conversation/` with filename format `review_{YYYYMMDD}_{slug}.md`.

## Step 2: Workflow Extraction

Look for patterns that should become skills. Good candidates are:

- **Multi-step processes** you performed more than once in this session
- **Workflows with specific tool sequences** (e.g., "read config, modify, validate, restart")
- **Debugging patterns** that followed a consistent approach
- **Any process the user corrected you on** — the correction itself is a workflow worth capturing

For each candidate workflow:

1. Describe what it does and when it's useful
2. Ask the user: "I noticed we did {X} a few times. Want me to turn this into a reusable skill?"
3. If yes, invoke the `skill-creator` skill to create it properly
4. Save the new skill to `.claude/skills/{name}/SKILL.md` (唯一位置，不再双写存档)

If no repeated workflows are found, say so — don't force it. Not every session produces a new skill.

## Step 3: Inventory Checklist

Scan the workspace and generate a comprehensive checklist of all available tools. This gives the user a single place to see everything they can use.

### What to scan

1. **Skills** — `.claude/skills/*/SKILL.md` — read each skill's name and description from frontmatter
2. **Hooks** — `.claude/settings.json` hooks section
3. **显式命令** — 从每个 skill 的 description 中提取 `/xxx` 样式的命令关键词

### Output format

Write/update the file `02_claude\02_skills\skills.md`. 这是一个「命令→技能」映射清单，不是完整元数据表：

```markdown
# Skills 清单

> session-review 自动维护。命令/触发词 → 技能名。

## 显式命令（用户直接输入）

| 命令 | 技能 | 作用 |
|------|------|------|
| `/xxx` | skill-name | 一句话作用 |

## 自动触发（按场景命中）

| 场景关键词 | 技能 |
|------------|------|
| {trigger} | {skill} |

## Hooks

{从 settings.json 提取；无则写"无"}
```

保持简明易懂，一屏看完。不写路径、不写 description 全文。

### Keep it current

Every time this skill runs, regenerate the checklist from scratch by scanning the filesystem. This ensures it's always accurate — no stale entries, no missing new additions.

## Step 4: Present to User

After completing all steps, present a brief summary:

1. Link to the session review file
2. Number of workflow candidates found (and which ones became skills)
3. Confirm the checklist was updated, with a count of items in each category

Keep it short — the user can read the files for details.
