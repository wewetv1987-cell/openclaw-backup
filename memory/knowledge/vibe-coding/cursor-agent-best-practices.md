# Cursor Agent 最佳实践

> 来源：Cursor Blog - Best practices for coding with agents
> 学习时间：2026-02-17 11:00
> 适用场景：使用 AI 编程代理进行软件开发

---

## 📌 核心概念

### Agent Harness（代理工具集）

代理工具集由三个核心组件构成：

1. **Instructions（指令）**：系统提示和规则，指导代理行为
2. **Tools（工具）**：文件编辑、代码库搜索、终端执行等
3. **User Messages（用户消息）**：你的提示和后续指令

**关键点**：不同模型对相同提示的响应不同。Cursor 的代理为每个模型调优指令和工具。

---

## 🎯 最佳实践

### 1. 从计划开始（Start with Plans）

**最重要的改变**：编写代码前先规划。

**芝加哥大学研究**：经验丰富的开发者更倾向于在生成代码前规划。

#### 使用 Plan Mode

按 `Shift+Tab` 切换计划模式。代理会：

1. 研究你的代码库，找到相关文件
2. 询问关于需求的澄清问题
3. 创建详细的实施计划（包含文件路径和代码引用）
4. 等待你的批准后再构建

**计划文件**：
- 打开为 Markdown 文件，可直接编辑
- 点击 "Save to workspace" 保存到 `.cursor/plans/`
- 为团队创建文档，方便恢复中断的工作

**何时不需要计划**：
- 快速更改
- 已经做过很多次的任务

#### 从计划重新开始

如果代理构建的内容不符合预期：

1. ✅ 回到计划
2. ✅ 恢复更改
3. ✅ 细化计划
4. ✅ 重新运行

**比修复进行中的代理更快，结果更清晰。**

---

### 2. 管理上下文（Managing Context）

你的工作变为：**给代理提供完成任务所需的上下文**。

#### 让代理查找上下文

**不需要手动标记每个文件**。

代理有强大的搜索工具：
- Grep：毫秒级搜索代码库
- 语义搜索：理解意图，找到相关文件

**原则**：
- 知道确切文件 → 标记它
- 不知道 → 让代理找
- 包含无关文件 → 混淆代理

**有用工具**：
- `@Branch`：给代理当前分支的上下文
- "Review the changes on this branch"
- "What am I working on?"

#### 何时开始新对话

**开始新对话**：
- ✅ 移动到不同任务或功能
- ✅ 代理似乎困惑或重复错误
- ✅ 完成一个逻辑工作单元

**继续对话**：
- ✅ 迭代同一功能
- ✅ 代理需要早期讨论的上下文
- ✅ 调试刚刚构建的内容

**长对话问题**：
- 上下文积累噪音
- 代理可能失去焦点或切换到无关任务
- 注意到效果下降 → 开始新对话

#### 引用过去的工作

使用 `@Past Chats` 引用之前的工作，而不是复制整个对话。

代理可以选择性读取聊天历史，只提取需要的上下文。

---

### 3. 扩展代理能力（Extending the Agent）

#### Rules：项目的静态上下文

**作用**：持久指令，塑造代理如何处理代码
**位置**：`.cursor/rules/` 中的 Markdown 文件

**示例规则**：

```markdown
# Commands

- `npm run build`: 构建项目
- `npm run typecheck`: 运行类型检查
- `npm run test`: 运行测试（优先单个测试文件以提高速度）

# Code style

- 使用 ES modules (import/export)，而非 CommonJS (require)
- 尽可能解构导入：`import { foo } from 'bar'`
- 参见 `components/Button.tsx` 了解标准组件结构

# Workflow

- 进行一系列代码更改后始终运行类型检查
- API 路由放在 `app/api/`，遵循现有模式
```

**最佳实践**：
- ✅ 专注于基本要素
- ✅ 引用文件而非复制内容
- ✅ 提交到 git，让整个团队受益
- ❌ 复制整个风格指南（使用 linter）
- ❌ 记录每个可能的命令
- ❌ 添加很少适用的边缘情况指令

**提示**：从简单开始。只在代理重复犯错时添加规则。

#### Skills：动态能力和工作流

**作用**：扩展代理能力，包含领域知识、工作流和脚本
**位置**：SKILL.md 文件
**加载**：动态加载（代理决定相关时）

**包含**：
- **自定义命令**：在代理输入中用 `/` 触发的可重用工作流
- **Hooks**：代理操作前后运行的脚本
- **领域知识**：代理可按需调用的特定任务指令

#### 示例：长时间运行的代理循环

创建一个持续工作直到所有测试通过的代理。

**配置 hook**（`.cursor/hooks.json`）：

```json
{
  "version": 1,
  "hooks": {
    "stop": [{ "command": "bun run .cursor/hooks/grind.ts" }]
  }
}
```

**Hook 脚本**（`.cursor/hooks/grind.ts`）：

```typescript
import { readFileSync, existsSync } from "fs";

interface StopHookInput {
  conversation_id: string;
  status: "completed" | "aborted" | "error";
  loop_count: number;
}

const input: StopHookInput = await Bun.stdin.json();
const MAX_ITERATIONS = 5;

if (input.status !== "completed" || input.loop_count >= MAX_ITERATIONS) {
  console.log(JSON.stringify({}));
  process.exit(0);
}

const scratchpad = existsSync(".cursor/scratchpad.md")
  ? readFileSync(".cursor/scratchpad.md", "utf-8")
  : "";

if (scratchpad.includes("DONE")) {
  console.log(JSON.stringify({}));
} else {
  console.log(JSON.stringify({
    followup_message: `[迭代 ${input.loop_count + 1}/${MAX_ITERATIONS}] 继续工作。完成时更新 .cursor/scratchpad.md 为 DONE。`
  }));
}
```

**适用场景**：
- 运行（并修复）直到所有测试通过
- 迭代 UI 直到匹配设计模型
- 任何可验证成功的目标导向任务

---

### 4. 包含图像（Including Images）

代理可以直接处理图像：粘贴截图、拖入设计文件或引用图像路径。

#### 设计到代码（Design to Code）

粘贴设计模型，要求代理实现。代理可以匹配布局、颜色和间距。

**高级**：使用 Figma MCP server。

#### 视觉调试（Visual Debugging）

截图错误状态或意外 UI，要求代理调查。

**比用文字描述问题更快。**

**浏览器控制**：代理可以控制浏览器截图、测试应用、验证视觉更改。

---

## 🔄 常见工作流

### 1. 测试驱动开发（TDD）

代理可以编写代码、运行测试并自动迭代：

1. **编写测试**：基于预期输入/输出对编写测试
   - 明确说明你在做 TDD
   - 避免创建尚不存在的功能的模拟实现

2. **运行测试**：确认失败
   - 明确说在此阶段不编写实现代码

3. **提交测试**：满意后提交

4. **编写实现**：编写通过测试的代码
   - 指示不要修改测试
   - 继续迭代直到所有测试通过

5. **提交实现**：对更改满意后提交

**原则**：代理在有明确目标迭代时表现最佳。

### 2. 代码库理解

使用代理学习和探索新代码库。问同样的问题：

- "这个项目的日志是如何工作的？"
- "如何添加新的 API 端点？"
- "CustomerOnboardingFlow 处理哪些边缘情况？"
- "为什么第 1738 行调用 setUser() 而不是 createUser()？"

**代理使用 grep 和语义搜索查找答案。这是快速上手不熟悉代码库的最快方式之一。**

### 3. Git 工作流

代理可以搜索 git 历史、解决合并冲突、自动化 git 工作流。

#### 示例：/pr 命令

提交、推送并打开 pull request：

```markdown
# 创建当前更改的 pull request

1. 使用 `git diff` 查看暂存和未暂存的更改
2. 根据更改编写清晰的提交消息
3. 提交并推送到当前分支
4. 使用 `gh pr create` 打开带有标题/描述的 pull request
5. 完成后返回 PR URL
```

**存储**：作为 Markdown 文件在 `.cursor/commands/` 中，提交到 git 供团队使用。

**其他示例**：
- `/fix-issue [number]`：获取 issue 详情，查找相关代码，实施修复，打开 PR
- `/review`：运行 linter，检查常见问题，总结需要注意的内容
- `/update-deps`：检查过时的依赖项并逐个更新，每次运行测试

**代理可以自主使用这些命令**，用单个 `/` 调用委托多步骤工作流。

---

## 🔍 代码审查

AI 生成的代码需要审查。Cursor 提供多种选项。

### 1. 生成过程中审查

**观察代理工作**：
- 差异视图实时显示更改
- 看到代理走错方向 → 按 Escape 中断并重定向

### 2. Agent 审查

**完成后**：点击 Review → Find Issues

代理逐行分析建议的编辑并标记潜在问题。

**本地更改**：打开 Source Control 选项卡，运行 Agent Review 与主分支比较。

### 3. Bugbot for Pull Requests

推送到源代码控制，在 pull request 上获得自动审查。

---

## 💡 实用技巧

### 1. 保持简单

- 知道文件 → 标记它
- 不知道 → 让代理找
- 不要包含无关文件

### 2. 及时开始新对话

- 完成逻辑单元 → 新对话
- 代理困惑 → 新对话
- 切换任务 → 新对话

### 3. 使用 Rules 和 Skills

- **Rules**：每个项目一次的配置（命令、风格、工作流）
- **Skills**：动态能力（命令、hooks、领域知识）
- 提交到 git，让团队受益

### 4. 利用图像

- 设计模型 → 代码
- 错误截图 → 调试
- 比文字描述更高效

### 5. 使用 Plan Mode

复杂任务：
1. 研究代码库
2. 提出澄清问题
3. 创建实施计划
4. 等待批准
5. 构建

不满意？重新规划，而不是修复。

---

## 🚀 实践应用

### 第一次使用 Agent

1. **小项目开始**：Todo 列表、计算器等简单应用
2. **使用 Plan Mode**：熟悉代理的工作方式
3. **观察和学习**：看代理如何搜索、规划、实施
4. **逐步增加复杂度**：从单文件到多文件，从简单功能到复杂系统

### 进阶使用

1. **创建自定义 Rules**：为项目定义特定规则
2. **开发 Skills**：创建可重用的工作流和命令
3. **配置 Hooks**：自动化长时间运行的任务
4. **集成工具**：连接 MCP servers（Slack、Datadog、Sentry 等）

### 团队协作

1. **共享 Rules**：提交到 git，统一团队标准
2. **创建 Commands**：常用工作流（/pr、/review、/fix-issue）
3. **文档化 Skills**：记录团队特定的模式和最佳实践
4. **审查 AI 代码**：使用 Agent Review 和 Bugbot 确保质量

---

## 📚 相关资源

- [Cursor Documentation](https://cursor.com/docs)
- [Agent Skills Guide](https://cursor.com/docs/context/skills)
- [Hooks Documentation](https://cursor.com/docs/agent/hooks)
- [MCP Directory](https://cursor.com/docs/context/mcp/directory)
- [Browser Documentation](https://cursor.com/docs/agent/browser)

---

## 🎓 学习总结

### 核心要点

1. **规划优先**：复杂任务前先规划，使用 Plan Mode
2. **上下文管理**：让代理查找上下文，适时开始新对话
3. **能力扩展**：用 Rules 和 Skills 自定义代理行为
4. **视觉辅助**：使用图像加速开发和调试
5. **迭代改进**：通过 TDD 和循环 hooks 实现自动化

### 下一步学习

- [ ] 实践 Plan Mode 创建简单 Web 应用
- [ ] 为项目创建自定义 Rules
- [ ] 开发一个 Skill 用于常用工作流
- [ ] 尝试长时间运行的代理循环
- [ ] 集成 MCP servers 扩展能力

---

*学习日期：2026-02-17*
*来源：Cursor Blog - Best practices for coding with agents*
*领域：Vibe Coding / AI 辅助编程*
