# 工作流: 每日学习

## 描述
每天自动学习新知识，更新知识库

## 输入
- 无 (自动执行)

## 步骤

### 1. 读取学习目标
- 动作: 读取 LEARNING_SYSTEM.md 中的目标
- 工具: read
- 输出: 今日学习重点

### 2. 获取学习资源
- 动作: 抓取技术文章/教程
- 工具: web_fetch / Tavily
- 资源:
  - 技术博客 (Dev.to, Medium)
  - GitHub Trending
  - 金融新闻 (Bloomberg, Reuters)
  - 安全资讯 (Hacker News, Security Weekly)

### 3. 知识提取
- 动作: 总结关键知识点
- 工具: LLM 总结
- 输出: 结构化笔记

### 4. 更新知识库
- 动作: 写入 memory/knowledge/
- 工具: write
- 格式:
  ```markdown
  # [主题]

  ## 核心概念
  - 要点1
  - 要点2

  ## 实践应用
  - 示例1
  - 示例2

  ## 相关资源
  - 链接1
  - 链接2
  ```

### 5. 生成学习报告
- 动作: 汇总今日所学
- 工具: write
- 输出: memory/daily/YYYY-MM-DD.md

### 6. 通知用户 (可选)
- 动作: 发送学习摘要
- 工具: message
- 输出: Telegram 通知

## 输出
- 知识库更新: memory/knowledge/
- 学习记录: memory/daily/
- 进度更新: LEARNING_SYSTEM.md

## 自动化配置

### Cron 任务
```json
{
  "name": "每日学习",
  "schedule": { "kind": "cron", "expr": "0 8 * * *", "tz": "Asia/Bangkok" },
  "payload": {
    "kind": "agentTurn",
    "message": "执行每日学习工作流，今日重点：[根据进度自动选择]",
    "model": "zai/glm-5"
  },
  "sessionTarget": "isolated",
  "notify": false
}
```

## 学习资源列表

### 金融
- Investopedia (基础概念)
- Yahoo Finance (市场数据)
- QuantConnect (量化教程)

### 编程
- Dev.to (技术文章)
- GitHub Trending (热门项目)
- Stack Overflow (常见问题)

### 逆向
- Hacker News (安全资讯)
- /r/ReverseEngineering (技术讨论)
- Malware Analysis (实战案例)

---
*创建时间: 2026-02-17*
