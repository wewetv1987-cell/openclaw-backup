# Claude Code 完全指南

> 基于官方文档整理 (2026-02-17)

## 🎯 核心理念

Claude Code 是一个 **Agentic Coding Tool**，与普通聊天机器人不同，它能：
- 读取你的代码库
- 编辑文件
- 运行命令
- 自主工作解决问题

**关键变化**：不是你写代码让 Claude 审查，而是你描述需求，Claude 自己探索、规划并实现。

---

## ⚡ 最佳实践

### 1. 提供验证方式（最重要！）

> **单一最高效的做法**：包含测试、截图或预期输出让 Claude 自我验证。

| 策略 | ❌ 之前 | ✅ 之后 |
|------|---------|---------|
| 提供验证条件 | "implement a function that validates email" | "write validateEmail, test cases: user@example.com is true, invalid is false" |
| 视觉验证 UI | "make the dashboard look better" | "[paste screenshot] implement this design, take screenshot and compare" |
| 解决根本原因 | "the build is failing" | "build fails with: [paste error], fix root cause, don't suppress" |

### 2. 先探索，后规划，再编码

推荐四阶段工作流：

1. **Explore (探索)** - 进入 Plan Mode，读取文件，回答问题
2. **Plan (规划)** - 创建详细实现计划
3. **Implement (实现)** - 切换 Normal Mode，按计划编码
4. **Commit (提交)** - 提交并创建 PR

**何时跳过规划**：范围清晰、修复简单（改 typo、加日志、重命名变量）

### 3. 提供具体上下文

| 策略 | ❌ 之前 | ✅ 之后 |
|------|---------|---------|
| 明确范围 | "add tests for foo.py" | "write test for foo.py covering edge case where user is logged out" |
| 指向来源 | "why is ExecutionFactory weird?" | "look through ExecutionFactory's git history and summarize how its api came to be" |
| 引用现有模式 | "add a calendar widget" | "look at how existing widgets are implemented, HotDogWidget.php is a good example" |

### 4. 上下文窗口管理

> **最重要的资源**：Claude 的上下文窗口填满得很快，性能会随之下降。

**最佳实践**：
- 使用 `/clear` 在不相关任务之间重置上下文
- 用自定义状态栏持续监控上下文使用
- 长会话后运行 `/compact` 保留关键内容

---

## 🛠️ CLAUDE.md 配置

CLAUDE.md 是 Claude 每次对话都会读取的特殊文件。

### 包含 vs 排除

| ✅ 包含 | ❌ 排除 |
|---------|---------|
| Claude 猜不到的 Bash 命令 | Claude 能从代码推断的内容 |
| 与默认不同的代码风格规则 | 标准语言惯例 |
| 测试指令和首选测试运行器 | 详细 API 文档（链接到文档） |
| 仓库礼仪（分支命名、PR 约定） | 经常变化的信息 |
| 特定于项目的架构决策 | 长篇教程 |
| 开发环境特殊配置 | 显而易见的做法 |

### 导入其他文件

```markdown
See @README.md for project overview
See @package.json for available npm commands

# Additional Instructions
- Git workflow: @docs/git-instructions.md
- Personal overrides: @~/.claude/my-project-instructions.md
```

---

## 🔄 常见工作流

### 探索新代码库

```bash
cd /path/to/project
claude
```

```
> give me an overview of this codebase
> explain the main architecture patterns
> what are the key data models?
> how is authentication handled?
```

### 修复 Bug

```
> I'm seeing an error when I run npm test
> suggest a few ways to fix the @ts-ignore in user.ts
> update user.ts to add the null check you suggested
```

### 重构代码

```
> find deprecated API usage in our codebase
> suggest how to refactor utils.js to use modern JavaScript features
> refactor utils.js to use ES2024 features while maintaining the same behavior
> run tests for the refactored code
```

### 测试工作

```
> find functions in NotificationsService.swift that are not covered by tests
> add tests for the notification service
> add test cases for edge conditions
> run the new tests and fix any failures
```

---

## 🧩 Skills（技能系统）

Skills 是扩展 Claude 能力的主要方式。创建 `SKILL.md` 文件即可。

### 基础结构

```yaml
---
name: explain-code
description: Explains code with visual diagrams and analogies
---

When explaining code, always include:

1. **Start with an analogy**: Compare to everyday life
2. **Draw a diagram**: Use ASCII art
3. **Walk through the code**: Explain step-by-step
4. **Highlight a gotcha**: Common mistake or misconception
```

### 存储位置

| 位置 | 路径 | 适用范围 |
|------|------|----------|
| 企业 | managed settings | 组织内所有用户 |
| 个人 | `~/.claude/skills/<skill>/SKILL.md` | 所有项目 |
| 项目 | `.claude/skills/<skill>/SKILL.md` | 仅此项目 |
| 插件 | `<plugin>/skills/<skill>/SKILL.md` | 启用插件处 |

### Frontmatter 字段

| 字段 | 说明 |
|------|------|
| `name` | 显示名称，成为 `/slash-command` |
| `description` | 帮助 Claude 决定何时加载 |
| `disable-model-invocation` | 设为 `true` 阻止 Claude 自动加载 |
| `allowed-tools` | 限制可用工具 |
| `context: fork` | 在子代理中运行 |

### 参数传递

```yaml
---
name: fix-issue
description: Fix a GitHub issue
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

运行 `/fix-issue 123` 会将 `$ARGUMENTS` 替换为 `123`。

---

## 🚀 高级技巧

### 子代理（Subagents）

用于隔离任务，保护主对话上下文：

```
Use subagents to investigate how our authentication system handles token refresh.
```

### 检查点（Checkpoints）

- 每个动作自动创建检查点
- 双击 `Esc` 或 `/rewind` 打开回退菜单
- 可以恢复对话、代码或两者

### 并行会话

使用 Git worktree 实现完全隔离：

```bash
git worktree add ../project-feature-a -b feature-a
cd ../project-feature-a
claude
```

### Headless 模式

```bash
# 一次性查询
claude -p "Explain what this project does"

# 结构化输出
claude -p "List all API endpoints" --output-format json

# 流式输出
claude -p "Analyze this log file" --output-format stream-json
```

---

## ⚠️ 常见失败模式

| 模式 | 解决方案 |
|------|----------|
| **厨房水槽会话** - 一个会话塞太多不相关任务 | 不相关任务间使用 `/clear` |
| **反复纠正** - Claude 反复做错 | 两次失败后 `/clear`，写更好的初始提示 |
| **过度规范的 CLAUDE.md** | 精简 - 如果 Claude 已经做对了，删除规则 |
| **信任后验证差距** | 总是提供验证（测试、脚本、截图） |
| **无限探索** | 限制调查范围或使用子代理 |

---

## 📊 核心 Takeaway

1. **提供验证方式** - 让 Claude 能自我检查
2. **管理上下文** - 定期 `/clear`，使用子代理
3. **具体明确** - 指向文件、描述症状、引用模式
4. **分离规划与执行** - 复杂任务用 Plan Mode
5. **利用扩展** - CLAUDE.md、Skills、Hooks、MCP

---

*学习来源: Claude Code 官方文档 (code.claude.com/docs)*
*整理时间: 2026-02-17*
