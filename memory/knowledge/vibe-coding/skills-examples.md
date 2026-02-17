# Claude Code Skills 示例集

> 实用技能模板示例

## 示例 1: 代码解释技能

```yaml
# ~/.claude/skills/explain-code/SKILL.md
---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works.
---

When explaining code, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?

Keep explanations conversational. For complex concepts, use multiple analogies.
```

## 示例 2: GitHub Issue 修复

```yaml
# ~/.claude/skills/fix-issue/SKILL.md
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.

1. Use `gh issue view $ARGUMENTS` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR
```

## 示例 3: API 约定

```yaml
# .claude/skills/api-conventions/SKILL.md
---
name: api-conventions
description: REST API design conventions for our services
---

# API Conventions
- Use kebab-case for URL paths
- Use camelCase for JSON properties
- Always include pagination for list endpoints
- Version APIs in the URL path (/v1/, /v2/)
- Return consistent error formats:
  ```json
  {
    "error": {
      "code": "ERROR_CODE",
      "message": "Human readable message"
    }
  }
  ```
```

## 示例 4: 安全审查代理

```yaml
# .claude/agents/security-reviewer.md
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob, Bash
model: opus
---

You are a senior security engineer. Review code for:
- Injection vulnerabilities (SQL, XSS, command injection)
- Authentication and authorization flaws
- Secrets or credentials in code
- Insecure data handling

Provide specific line references and suggested fixes.
```

## 示例 5: 深度研究技能

```yaml
# ~/.claude/skills/deep-research/SKILL.md
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
4. Include line numbers for important code sections
5. Identify patterns and anti-patterns
```

## 示例 6: PR 总结

```yaml
# ~/.claude/skills/pr-summary/SKILL.md
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request:
1. What is the main change?
2. What files were modified?
3. Are there any concerns from comments?
4. Suggested improvements
```

## 示例 7: 代码库可视化

```yaml
# ~/.claude/skills/codebase-visualizer/SKILL.md
---
name: codebase-visualizer
description: Generate interactive tree visualization of codebase
allowed-tools: Bash(python *)
---

# Codebase Visualizer

Generate an interactive HTML tree view that shows project file structure.

## Usage

Run from project root:
```bash
python ~/.claude/skills/codebase-visualizer/scripts/visualize.py .
```

This creates `codebase-map.html` with:
- Collapsible directories
- File sizes
- Color-coded file types
- Directory totals
```

## 示例 8: 部署技能

```yaml
# .claude/skills/deploy/SKILL.md
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
allowed-tools: Bash(npm run *), Bash(git push *)
---

Deploy $ARGUMENTS to production:

1. Run the test suite: `npm test`
2. Build the application: `npm run build`
3. Check for linting errors: `npm run lint`
4. Push to main branch: `git push origin main`
5. Verify deployment succeeded
6. Notify team of deployment
```

## 示例 9: 提交推送 PR

```yaml
# .claude/skills/commit-push-pr/SKILL.md
---
name: commit-push-pr
description: Commit changes, push, and create PR in one step
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *)
---

1. Stage all changes: `git add -A`
2. Create a descriptive commit message based on the changes
3. Commit: `git commit -m "<message>"`
4. Push: `git push -u origin HEAD`
5. Create PR: `gh pr create --title "<title>" --body "<description>"`
6. If CLAUDE.md specifies Slack channels, post PR URL there
```

## 示例 10: 会话记录

```yaml
# ~/.claude/skills/session-logger/SKILL.md
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS

Include timestamp and relevant context.
```

---

*整理时间: 2026-02-17*
*来源: Claude Code 官方文档*
