# 工作流: 每日启动检查

## 描述
每天开始的自动化检查流程

## 输入
- 无 (自动执行)

## 步骤

### 1. 系统状态检查
- 动作: 检查系统资源
- 工具: shell
- 命令: 
  ```bash
  # CPU/内存/磁盘
  top -l 1 | head -n 10
  df -h
  ```
- 输出: 系统状态报告

### 2. 待办事项检查
- 动作: 读取任务队列
- 工具: read
- 文件: tasks/QUEUE.md
- 输出: 待处理任务列表

### 3. 日程提醒
- 动作: 检查今日日程
- 工具: gog (Google Calendar)
- 输出: 今日日程列表

### 4. 消息汇总
- 动作: 汇总未读消息
- 工具: 各消息渠道
- 输出: 未读消息摘要

### 5. 生成报告
- 动作: 汇总生成报告
- 工具: write
- 输出: workspace/DAILY_BRIEF.md

### 6. 发送通知
- 动作: 发送早安简报
- 工具: message
- 输出: Telegram 通知

### 7. 同步到 Memos
- 动作: 将每日简报同步到 Memos
- 工具: skills/memos/memos.sh
- 命令: `./memos.sh create "${DAILY_BRIEF}"`
- 标签: #daily #routine
- 输出: memo 创建确认

## 输出
- DAILY_BRIEF.md: 每日简报
- 通知消息: 发送到配置渠道

## 自动化配置

### Cron 设置
```yaml
schedule: "0 8 * * *"  # 每天 8:00
timezone: "Asia/Bangkok"
```

### OpenClaw Cron 配置
```json
{
  "name": "每日启动检查",
  "schedule": { "kind": "cron", "expr": "0 8 * * *", "tz": "Asia/Bangkok" },
  "payload": { "kind": "agentTurn", "message": "执行每日启动检查工作流" },
  "sessionTarget": "isolated",
  "notify": true
}
```

## 注意事项
- 首次运行需要授权各服务
- 可自定义检查项目
- 支持跳过某些步骤

## 模板引用
- WORKFLOWS/automation/monitoring.md
- TEMPLATES/shell/notify.sh

---
*创建时间: 2026-02-17*
