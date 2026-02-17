# WORKFLOWS 目录

> 常用工作流定义库

## 目录结构

```
WORKFLOWS/
├── daily/          # 日常任务
│   ├── morning-routine.md
│   └── end-of-day.md
├── development/    # 开发流程
│   ├── code-review.md
│   ├── deploy.md
│   └── testing.md
├── data/           # 数据处理
│   ├── etl.md
│   └── report.md
└── automation/     # 自动化场景
    ├── file-sync.md
    └── monitoring.md
```

## 工作流格式

每个工作流文件包含以下结构：

```markdown
# 工作流名称

## 描述
简短描述工作流用途

## 输入
- 输入项1: 类型, 必填/可选
- 输入项2: 类型, 必填/可选

## 步骤
1. 步骤1名称
   - 动作: 具体操作
   - 工具: 使用的工具
   - 预期输出: 期望结果

2. 步骤2名称
   - ...

## 输出
- 输出项1: 说明
- 输出项2: 说明

## 注意事项
- 注意点1
- 注意点2

## 模板引用
- TEMPLATES/xxx.sh
- AUTOMATION_PATTERNS.md#pattern-xxx
```

## 快速索引

| 工作流 | 用途 | 自动化程度 |
|-------|------|-----------|
| morning-routine | 每日启动检查 | 半自动 |
| code-review | 代码审查流程 | 手动 |
| deploy | 部署流程 | 半自动 |
| etl | 数据抽取转换 | 自动 |
| file-sync | 文件同步 | 自动 |
| monitoring | 系统监控 | 自动 |

---
*最后更新: 2026-02-17*
