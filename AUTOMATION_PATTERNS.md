# AUTOMATION_PATTERNS.md

> 自动化任务识别规则库

## 模式匹配规则

### 1. 文件处理模式

| 触发关键词 | 自动化方案 | 工具选择 |
|-----------|-----------|---------|
| 批量转换、格式转换 | 脚本自动化 | Node.js/Python |
| 重命名、整理文件 | 文件操作脚本 | shell/zsh |
| 压缩、解压 | 归档脚本 | shell |
| 图片处理、缩放、裁剪 | 图片处理流水线 | ImageMagick/sharp |

### 2. 数据转换模式

| 触发关键词 | 自动化方案 | 工具选择 |
|-----------|-----------|---------|
| CSV、Excel、JSON 互转 | 数据转换脚本 | Python/pandas |
| 数据清洗、去重 | 数据处理流程 | Python |
| 抓取、爬取、采集 | 爬虫自动化 | Puppeteer/Playwright |
| API 调用、同步 | API 集成工作流 | n8n/Make |

### 3. 定时任务模式

| 触发关键词 | 自动化方案 | 工具选择 |
|-----------|-----------|---------|
| 每天、每周、定期 | 定时工作流 | cron/n8n |
| 监控、检测、提醒 | 监控流程 | OpenClaw cron |
| 备份、同步 | 定时备份 | shell/rsync |

### 4. 通知推送模式

| 触发关键词 | 自动化方案 | 工具选择 |
|-----------|-----------|---------|
| 发送到、通知、推送 | 消息推送流程 | message tool |
| Telegram、微信、邮件 | 多渠道通知 | OpenClaw channels |

## 工具选择决策树

```
任务输入
    │
    ├─ 是否需要定时执行？
    │   ├─ 是 → cron + n8n
    │   └─ 否 → 继续判断
    │
    ├─ 是否涉及外部 API？
    │   ├─ 是 + 简单 → Zapier/Make
    │   ├─ 是 + 复杂 → Node.js + axios
    │   └─ 否 → 继续判断
    │
    ├─ 是否需要 UI 交互？
    │   ├─ 是 → Puppeteer/Playwright
    │   └─ 否 → 继续判断
    │
    ├─ 是否涉及数据处理？
    │   ├─ 是 + 简单 → shell/jq
    │   ├─ 是 + 复杂 → Python/pandas
    │   └─ 否 → shell 脚本
```

## 模式模板

### 模式定义格式
```yaml
pattern:
  id: auto-001
  name: 批量图片压缩
  triggers:
    - "压缩图片"
    - "批量压缩"
    - "图片优化"
  conditions:
    - 文件数量 > 1
    - 文件类型 = image/*
  automation:
    tool: sharp/imagemagick
    script: TEMPLATES/image-compress.sh
    params:
      quality: 80
      format: webp
  output:
    - 压缩后的文件
    - 处理报告
```

## 常用自动化脚本索引

| ID | 名称 | 路径 | 用途 |
|----|-----|------|-----|
| T001 | 图片批量处理 | TEMPLATES/image-batch.sh | 图片压缩、转换、缩放 |
| T002 | 数据格式转换 | TEMPLATES/data-convert.py | CSV/JSON/Excel 互转 |
| T003 | API 调用模板 | TEMPLATES/api-call.js | REST API 调用封装 |
| T004 | 定时备份 | TEMPLATES/backup.sh | 文件/数据库备份 |
| T005 | 通知推送 | TEMPLATES/notify.sh | 多渠道消息推送 |
| T006 | Memos 记录 | skills/memos/memos.sh | 快速笔记到 Memos |

## Memos 自动化模式

### 5. 笔记记录模式

| 触发关键词 | 自动化方案 | 工具选择 |
|-----------|-----------|---------|
| 记录、memo、笔记 | 快速记录到 Memos | memos skill |
| 每日总结、日结 | 生成总结并同步 | Memos + 工作流 |
| 保存、存档 | 永久保存到 Memos | memos skill |
| 想法、灵感 | 快速捕捉想法 | memos skill |

### Memos 触发规则
```yaml
pattern:
  id: auto-memos-001
  name: 快速记录
  triggers:
    - "记录"
    - "memo"
    - "笔记"
    - "保存"
    - "记下来"
  automation:
    tool: skills/memos/memos.sh
    action: create
    params:
      visibility: PRIVATE
  output:
    - memo ID
    - 创建确认
```

---
*最后更新: 2026-02-17*
