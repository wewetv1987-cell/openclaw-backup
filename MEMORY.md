# MEMORY.md - 长期记忆

> 这是 Claw 的核心记忆库，存储重要事实、偏好、决策和待办事项。
> 每次会话开始时会自动检索相关记忆。

## 用户档案

- **称呼**: k总
- **时区**: Asia/Bangkok (GMT+7)
- **交流风格**: 简洁直接
- **主要语言**: 中文
- **Telegram ID**: 7279130522 (最高权限)

## 技术配置

- **主机**: mac的MacBook Pro (192.168.1.51)
- **OpenClaw 版本**: 2026.2.15
- **模型配置**:
  - 主模型: zai/glm-5
  - 故障转移: zai/glm-4.7-flash
- **渠道**: 
  - Telegram: @My_KK_OpenClaw_Bot (已启用，最高权限)
  - Webchat: 已启用
- **GitHub 账户**: wewetv1987-cell
- **联网能力**:
  - web_fetch: ✅ 已启用
  - web_search: ❌ 已禁用 (Brave)
  - Tavily 搜索: ✅ 已配置并测试

## 重要决策

- [2026-02-16] 启用记忆系统 + 自主学习能力
- [2026-02-16] 配置多代理协同系统 (7个代理: Main/Coder/Architect/Automator/Researcher/Analyst)
- [2026-02-16] **多代理专用模型分配**:
  - **GLM-5**: Architect（架构）+ Researcher（研究）- 复杂任务
  - **GLM-4.7**: Coder（编程）- 中等复杂
  - **GLM-4.6V**: Analyst（金融）- 视觉+分析
  - **GLM-4.5**: Automator（自动化）- 简单任务
  - **GLM-4-Flash**: Main（协调）- 快速响应
  - **最大并发**: 8个子代理同时运行

## 待办事项

- [x] 安装并配置 agent-team-orchestration 团队编排技能
- [ ] 完善 writing 技能安装（遇到速率限制）
- [ ] 配置 seedream-image-for-openclaw 生图技能

## 团队编排系统

**已安装**: agent-team-orchestration v1.0.0
**配置文件**: TEAM_ORCHESTRATION.md

### 代理角色分配
- **Main** (Orchestrator): 任务协调、状态跟踪、优先级管理
- **Coder** (Builder): 代码实现、Bug修复、测试编写
- **Architect** (Builder + Reviewer): 架构设计、技术决策、质量审查
- **Automator** (Ops): Cron任务、自动化脚本、日常维护
- **Researcher** (Researcher): 技术调研、方案对比、文档整理
- **Analyst** (Analyst): 金融分析、数据解读、图表分析

### 任务生命周期
```
Inbox → Assigned → In Progress → Review → Done | Failed
```

### 质量保证
- 所有非平凡任务必须经过审查
- 不能审查自己的工作
- 交接必须包含：产出位置 + 验证方法 + 已知问题

## 自动化系统

### 已配置组件
- **AUTOMATION_PATTERNS.md**: 模式识别规则 + 工具选择决策树
- **CLAUDE_INTEGRATION.md**: Claude Code CLI/Web 集成配置
- **TEMPLATES/**: 脚本模板库 (shell/python/nodejs)
- **WORKFLOWS/**: 工作流定义库 (daily/development)
- **skills/memos/**: Memos 快速笔记技能
- **LEARNING_SYSTEM.md**: 自主学习系统配置
- **memory/knowledge/**: 知识库 (金融/编程/逆向)
- **Neural Memory**: 神经网络记忆系统 (已配置)
- **Moltbook**: AI 代理社交网络 (已安装，待配置)

### 自主能力
- **联网搜索**: Tavily Search + web_fetch
- **技能仓库**:
  - https://clawhub.ai (ClawHub 官方)
  - https://github.com/VoltAgent/awesome-openclaw-skills (社区技能)
- **自动学习**: 
  - 空闲时自动学习 (每30分钟检查)
  - 每日定时学习 (8:00)
  - 每周深度学习 (周日 10:00)
- **遇到问题**: 自动搜索/安装技能

## 偏好设置

- **进度反馈**: 每完成一小段任务必须输出进度报告

---
*最后更新: 2026-02-16*
