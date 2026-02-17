# Tavily Search Skill

为 OpenClaw 提供 Tavily AI 搜索能力。

## 状态

✅ 已配置并测试通过

## API Key

存储位置: `skills.entries.tavily-search.apiKey`

## 使用方法

当用户需要搜索时，使用 exec 调用 Tavily API：

```bash
TAVILY_API_KEY="tvly-dev-xxx"
curl -s -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d '{
    "api_key": "'"$TAVILY_API_KEY"'",
    "query": "搜索内容",
    "search_depth": "basic",
    "include_answer": true,
    "include_raw_content": false,
    "max_results": 5
  }'
```

## 参数说明

| 参数 | 类型 | 说明 |
|------|------|------|
| query | string | 搜索查询（必需）|
| search_depth | string | "basic" 或 "advanced" |
| include_answer | boolean | 返回 AI 生成的答案摘要 |
| include_raw_content | boolean | 返回原始网页内容 |
| max_results | number | 返回结果数量（1-10）|
| include_images | boolean | 返回相关图片 |
| country | string | 国家代码过滤 |

## 返回格式

```json
{
  "query": "搜索词",
  "answer": "AI 生成的答案摘要",
  "results": [
    {
      "url": "网页URL",
      "title": "标题",
      "content": "摘要内容",
      "score": 0.99
    }
  ],
  "response_time": 1.15
}
```

## 优势

- 🚀 快速响应（~1秒）
- 🎯 高相关度（score 0.99+）
- 🤖 AI 生成答案摘要
- 🌐 实时搜索结果

---
*Created: 2026-02-16*
