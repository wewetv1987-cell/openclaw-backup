# 🎯 团队编排快速参考

> 一张卡片掌握多代理协作

## 📍 任务状态流转

```
Inbox → Assigned → In Progress → Review → Done
                   ↓
                 Failed
```

| 状态 | 执行者 | 动作 |
|------|--------|------|
| Inbox → Assigned | Main | 选择代理 |
| Assigned → In Progress | Main | 启动代理 |
| In Progress → Review | 代理 | 提交交付物 |
| Review → Done | Reviewer | 审查通过 |
| Review → In Progress | Reviewer | 返回修改 |
| Any → Failed | Main | 取消任务 |

## 🎭 代理角色速查

| 代理 | 角色 | 模型 | 做什么 | 不做什么 |
|------|------|------|--------|----------|
| **Main** | Orchestrator | GLM-4-Flash | 协调、路由、跟踪 | ❌ 不执行具体工作 |
| **Coder** | Builder | GLM-4.7 | 编码、测试、修Bug | ❌ 不做架构决策 |
| **Architect** | Builder+Reviewer | GLM-5 | 设计、决策、审查 | ❌ 不审查自己的工作 |
| **Automator** | Ops | GLM-4.5 | 脚本、Cron、维护 | ❌ 不做复杂逻辑 |
| **Researcher** | Researcher | GLM-5 | 调研、对比、文档 | ❌ 不做最终决策 |
| **Analyst** | Analyst | GLM-4.6V | 分析、解读、图表 | ❌ 不给投资建议 |

## 🔀 任务路由规则

```
编程/Bug → Coder → Architect审查
架构设计 → Architect → Researcher审查
技术调研 → Researcher → Architect审查
自动化 → Automator → Coder审查
金融分析 → Analyst → Researcher审查
日常维护 → Automator → 无需审查
```

## 📝 交接必填项

### ✅ 必须包含
1. **完成内容** - 做了什么
2. **产出位置** - 文件在哪里
3. **验证方法** - 如何测试
4. **已知问题** - 还有什么没做
5. **下一步** - 建议后续行动

### ❌ 错误示例
```
"做完了，看文件。" ← 太简略
```

### ✅ 正确示例
```
## 交接报告

**任务**: #001 天气功能

### 完成内容
- 实现了天气查询模块
- 添加了单元测试

### 产出文件
- /shared/artifacts/code/weather/weather.js
- /shared/artifacts/code/weather/weather.test.js

### 验证方法
```bash
cd /shared/artifacts/code/weather
npm test
```

### 已知问题
- 暂不支持中文城市名

### 下一步
请Architect审查代码质量
```

## 🚨 规则速记

### 必须做
- ✅ 每个任务都要审查
- ✅ 交接要写清楚产出位置
- ✅ 阻塞超过10分钟立即上报
- ✅ 每30秒输出进度（如果有变化）

### 绝对不做
- ❌ Orchestrator执行具体工作
- ❌ 跳过审查步骤
- ❌ 审查自己的工作
- ❌ 代理沉默不报告
- ❌ 无交接直接提交

## 🔥 紧急插队流程

```
1. 新任务 → 标记 🔥 紧急
2. 当前任务 → 标记 ⏸️ 暂停
3. 执行紧急任务
4. 完成后 → 恢复原任务
```

## 📂 文件位置速查

```
/workspace/
├── tasks/
│   ├── QUEUE.md          ← 任务队列
│   └── COMPLETED.md      ← 已完成
├── shared/
│   ├── specs/            ← 规范文档
│   ├── artifacts/        ← 交付物
│   ├── reviews/          ← 审查记录
│   └── decisions/        ← 决策记录
└── agents/
    └── [agent]/SOUL.md   ← 代理身份
```

## 🎯 进度报告格式

```markdown
📍 [任务名] - [当前步骤]
✅ 已完成: [完成的子任务]
🔄 进行中: [正在做的事]
⏳ 待处理: [接下来要做的]
⚠️ 问题: [如有阻塞说明]
```

## 📞 何时上报用户

- ✅ 任务完成
- ⚠️ 任务阻塞
- ❓ 需要决策
- ❌ 任务失败
- 🔥 插队任务

---
*快速参考 v1.0 | 2026-02-17*
