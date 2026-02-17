# 工作流: Memos 快速记录

## 描述
快速记录内容到 Memos，支持标签和分类

## 输入
- 内容: string, 必填
- 标签: string[], 可选
- 可见性: string, 可选 (PUBLIC/PRIVATE, 默认 PRIVATE)

## 步骤

### 1. 解析输入
- 动作: 提取内容和标签
- 工具: NLP 解析
- 输出: 结构化内容

### 2. 格式化内容
- 动作: 添加时间戳和标签
- 工具: 模板格式化
- 模板:
  ```markdown
  # 📝 {{timestamp}}
  
  {{content}}
  
  {{#tags}}
  #{{tag}}
  {{/tags}}
  ```

### 3. 调用 Memos API
- 动作: 创建 memo
- 工具: skills/memos/memos.sh
- 命令: `./memos.sh create "${formatted_content}"`
- 输出: memo ID

### 4. 确认反馈
- 动作: 返回创建结果
- 工具: message
- 输出: "✅ 已记录到 Memos [#id]"

## 输出
- memo ID: 创建的 memo 编号
- 确认消息: 发送到当前会话

## 快捷触发

| 关键词 | 示例 |
|-------|------|
| 记录 | "记录 今天完成了 API 集成" |
| memo | "memo 下午3点开会" |
| 保存 | "保存 代码片段: ..." |
| 笔记 | "笔记 关于 Memos API 的想法" |

## 与其他工作流集成

### 每日总结 → Memos
```yaml
触发: 每日 22:00
流程:
  1. 生成每日总结
  2. 调用 memos.dailySummary()
  3. 确认同步
```

### 任务完成 → Memos
```yaml
触发: 任务标记完成
流程:
  1. 记录完成的任务
  2. 自动记录到 Memos
  3. 添加 #completed 标签
```

## 模板引用
- skills/memos/SKILL.md
- skills/memos/memos.sh

---
*创建时间: 2026-02-17*
