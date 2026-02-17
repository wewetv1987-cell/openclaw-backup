# 工作区索引

> 快速定位工作区资源

## 核心文件

| 文件 | 用途 | 更新频率 |
|-----|------|---------|
| `MEMORY.md` | 长期记忆 | 手动 |
| `state/ACTIVE.md` | 当前任务 | 每次任务 |
| `state/HOLD.md` | 阻塞项 | 有变化时 |
| `state/DECISIONS.md` | 技术决策 | 有决策时 |
| `HEARTBEAT.md` | 心跳规则 | 很少 |
| `LEARNING_SYSTEM.md` | 学习系统 | 很少 |

## 目录结构

```
workspace/
├── MEMORY.md              # 长期记忆 (本文件)
├── AGENTS.md              # 代理规则
├── SOUL.md                # 身份人格
├── USER.md                # 用户信息
├── TOOLS.md               # 工具配置
│
├── state/                 # 活跃状态
│   ├── ACTIVE.md          # 当前任务
│   ├── HOLD.md            # 阻塞项
│   ├── STAGING.md         # 待审批
│   └── DECISIONS.md       # 最近决策
│
├── memory/                # 历史记忆
│   ├── recent-work.md     # 最近工作
│   ├── knowledge/         # 知识库
│   │   ├── finance/       # 金融
│   │   ├── programming/   # 编程
│   │   └── reverse/       # 逆向
│   ├── daily/             # 每日日志
│   └── archive/           # 归档
│
├── skills/                # 技能库 (36个)
│
├── WORKFLOWS/             # 工作流定义
├── TEMPLATES/             # 脚本模板
│
└── tasks/                 # 任务队列
    └── QUEUE.md           # 任务状态
```

## 记忆系统架构

```
┌─────────────────────────────────────────────┐
│              记忆检索优先级                   │
├─────────────────────────────────────────────┤
│  1. state/HOLD.md      (最高 - 阻塞所有)     │
│  2. state/ACTIVE.md    (当前任务)           │
│  3. state/DECISIONS.md (最近决策)           │
│  4. MEMORY.md          (长期记忆)           │
│  5. memory/recent-work.md (最近工作)        │
│  6. Neural Memory      (联想记忆)           │
└─────────────────────────────────────────────┘
```

## 技能分类

| 类别 | 数量 | 主要技能 |
|-----|------|---------|
| 开发框架 | 3 | clawgator-superpowers, developer |
| 记忆系统 | 5 | neural-memory, dory-memory, openclaw-mem |
| 代码质量 | 5 | audit-code, clean-code-review, tdd-guide |
| Git | 3 | git-essentials, git-helper, git-workflows |
| API | 2 | api, api-dev |
| 数据/系统 | 4 | sql-toolkit, linux, docker-essentials |
| 安全 | 1 | security-auditor |
| 金融 | 2 | finance, stock-watcher |
| 自动化 | 4 | agent-autonomy-kit, memos |
| AI/写作 | 2 | ai-humanizer, claude-optimised |

---
*最后更新: 2026-02-17*
