---
name: memos
description: Memos note-taking integration for creating, searching, and managing quick notes via API. Use when user wants to save a memo, search memos, or manage their Memos instance.
metadata:
  openclaw:
    emoji: "📝"
    category: "notes"
    requires:
      env: ["MEMOS_URL", "MEMOS_TOKEN"]
---

# Memos Skill

快速记录和管理 Memos 笔记。

## 配置

在 `TOOLS.md` 或环境变量中设置：

```bash
# Memos 实例地址
MEMOS_URL=https://your-memos-instance.com

# API Token (在 Memos 设置中生成)
MEMOS_TOKEN=your-api-token
```

或在 `TOOLS.md` 中添加：

```markdown
### Memos
- Instance: https://your-memos-instance.com
- 用于: 快速笔记、日常记录
```

## 使用方式

### 创建 Memo

```bash
# 通过 OpenClaw
"记录一条 memo: 今天完成了自动化系统配置"

# 直接调用脚本
./scripts/memos.sh create "今天完成了自动化系统配置"
```

### 搜索 Memo

```bash
# 搜索包含关键词的 memo
"搜索 memo 关键词: 自动化"

# 直接调用
./scripts/memos.sh search "自动化"
```

### 列出最近 Memo

```bash
# 列出最近 10 条
"列出最近的 memo"

# 直接调用
./scripts/memos.sh list 10
```

### 删除 Memo

```bash
# 删除指定 ID 的 memo
./scripts/memos.sh delete <memo-id>
```

## API 参考

Memos REST API:

| 端点 | 方法 | 说明 |
|-----|------|-----|
| `/api/v1/memo` | POST | 创建 memo |
| `/api/v1/memo` | GET | 列出 memos |
| `/api/v1/memo/:id` | GET | 获取单条 memo |
| `/api/v1/memo/:id` | PATCH | 更新 memo |
| `/api/v1/memo/:id` | DELETE | 删除 memo |
| `/api/v1/memo?filter=` | GET | 搜索 memos |

## 自动化集成

### 与工作流集成

在 `WORKFLOWS/daily/morning-routine.md` 中添加：

```markdown
### X. 同步到 Memos
- 动作: 将每日简报同步到 Memos
- 工具: memos skill
- 命令: memos.sh create "${DAILY_BRIEF}"
- 输出: memo 创建确认
```

### Cron 定时记录

```json
{
  "name": "每小时记录",
  "schedule": { "kind": "cron", "expr": "0 * * * *" },
  "payload": { "kind": "agentTurn", "message": "记录当前时间和工作状态到 Memos" }
}
```

## 模板

### 快速记录模板

```markdown
# 📝 {{date}} {{time}}

{{content}}

#tags: {{tags}}
```

### 每日总结模板

```markdown
# 📊 每日总结 - {{date}}

## 完成事项
{{completed_tasks}}

## 明日计划
{{tomorrow_tasks}}

## 备注
{{notes}}
```

## 常见用例

| 场景 | 命令 |
|-----|------|
| 快速记录想法 | `记录 memo: [想法内容]` |
| 记录会议要点 | `记录会议 memo: [要点]` |
| 保存代码片段 | `保存代码到 memo: [代码]` |
| 每日总结 | `创建今日总结 memo` |
| 搜索历史记录 | `搜索 memo: [关键词]` |

---
*创建时间: 2026-02-17*
