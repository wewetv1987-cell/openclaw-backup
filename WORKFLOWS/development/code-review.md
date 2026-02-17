# 工作流: 代码审查

## 描述
使用 Claude Code 进行自动化代码审查

## 输入
- 代码路径: string, 必填
- 审查重点: string[], 可选 (默认: 全部)
- 目标分支: string, 可选 (默认: main)

## 步骤

### 1. 准备环境
- 动作: 确保在干净的 git 状态
- 工具: git
- 输出: 工作目录状态

### 2. 获取变更
- 动作: 获取代码差异
- 工具: git diff
- 命令: `git diff origin/main...HEAD`
- 输出: 变更内容

### 3. 调用 Claude Code
- 动作: 执行代码审查
- 工具: Claude Code CLI
- 命令:
  ```bash
  claude 'Review the code changes. Focus on:
  - 代码质量
  - 潜在 bug
  - 性能问题
  - 安全隐患
  - 最佳实践

  Output a structured review with:
  - 总体评分 (1-10)
  - 问题列表 (严重程度)
  - 改进建议'
  ```
- 输出: 审查报告

### 4. 生成报告
- 动作: 格式化审查结果
- 工具: 写入文件
- 输出: workspace/REVIEW_REPORT.md

### 5. 反馈
- 动作: 通知用户审查完成
- 工具: message
- 输出: 审查摘要

## 输出
- REVIEW_REPORT.md: 详细审查报告
- 评分: 1-10 分
- 问题数: 按严重程度统计

## 注意事项
- 不要在 OpenClaw 源码目录执行
- 使用临时目录或 git worktree
- 大型 PR 建议分批审查

## 模板引用
- CLAUDE_INTEGRATION.md
- TEMPLATES/shell/notify.sh

---
*创建时间: 2026-02-17*
