# 工作流: 自主问题解决

## 描述
遇到问题时自动搜索解决方案或安装技能

## 触发条件

### 1. 技能缺失
```
检测: 任务需要特定技能但未安装
动作: 搜索并安装相关技能
```

### 2. 知识盲区
```
检测: 遇到不熟悉的概念/技术
动作: 联网搜索学习
```

### 3. 错误诊断
```
检测: 代码/命令执行失败
动作: 搜索错误原因和解决方案
```

## 步骤

### 1. 问题识别
- 动作: 分析问题类型
- 工具: NLP 分析
- 输出: 问题分类

### 2. 搜索策略

#### 技能搜索
```yaml
优先级:
  1. clawhub search [关键词]
  2. 浏览 https://clawhub.ai
  3. 检查 https://github.com/VoltAgent/awesome-openclaw-skills
  
安装:
  clawhub install [skill-name] --force
```

#### 知识搜索
```yaml
工具选择:
  - Tavily Search (深度搜索)
  - web_fetch (抓取文档)
  - MCP web-reader (网页解析)

搜索关键词:
  - 错误信息
  - 技术概念
  - 最佳实践
```

### 3. 执行搜索
- 动作: 调用搜索工具
- 工具: Tavily / web_fetch / clawhub
- 输出: 搜索结果

### 4. 方案实施
- 动作: 应用搜索到的方案
- 工具: 执行命令/代码
- 输出: 实施结果

### 5. 记录学习
- 动作: 保存到知识库
- 工具: write
- 路径: memory/knowledge/

## 资源列表

### 技能仓库
| 名称 | URL | 用途 |
|-----|-----|------|
| ClawHub | https://clawhub.ai | 官方技能市场 |
| Awesome Skills | https://github.com/VoltAgent/awesome-openclaw-skills | 社区技能精选 |

### 学习资源
| 类型 | 来源 |
|-----|------|
| 技术文档 | web_fetch 官方文档 |
| 代码示例 | GitHub Trending |
| 最佳实践 | Dev.to, Medium |
| 问题解决 | Stack Overflow |

## 自动化规则

### 遇到错误时
```
1. 提取错误信息
2. Tavily 搜索: "[错误信息] solution fix"
3. 分析搜索结果
4. 尝试解决方案
5. 记录有效方案
```

### 缺少技能时
```
1. 识别所需技能
2. clawhub search [技能关键词]
3. 选择评分最高的技能
4. 安装: clawhub install [name]
5. 验证技能可用
6. 记录到 MEMORY.md
```

### 知识盲区时
```
1. 提取核心概念
2. Tavily 搜索: "[概念] tutorial guide"
3. web_fetch 抓取教程
4. 总结关键知识点
5. 写入 memory/knowledge/
```

## 示例场景

### 场景 1: 代码错误
```
错误: Module not found: 'xyz'
→ Tavily: "npm module xyz install solution"
→ 找到: npm install xyz
→ 执行安装
→ 记录到知识库
```

### 场景 2: 技能缺失
```
任务: 处理 Excel 文件
检测: 缺少 Excel 处理技能
→ clawhub search excel
→ 安装: excel-processor
→ 执行任务
```

### 场景 3: 新技术
```
问题: 如何使用 WebSocket?
→ Tavily: "WebSocket tutorial guide"
→ web_fetch: 抓取教程
→ 总结要点
→ 写入 memory/knowledge/programming/
```

---
*创建时间: 2026-02-17*
