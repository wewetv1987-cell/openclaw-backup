# 多代理模型分配策略 v3.0

> 基于 GLM 模型配额优化，复杂任务用 GLM-5，其他自动分配最快模型

## 模型配额概览

### 🟢 充足配额 (适合高频任务)
| 模型 | 配额 | 速度 | 用途 |
|------|------|------|------|
| **GLM-4-Flash** | 1000 | ⚡⚡⚡ | 高频简单任务 |
| **GLM-4-Air** | 200 | ⚡⚡⚡ | 快速简单任务 |
| **GLM-4-FlashX** | 100 | ⚡⚡ | 快速响应 |
| **GLM-Z1-FlashX** | 100 | ⚡⚡ | 快速推理 |

### 🟡 中等配额 (适合日常任务)
| 模型 | 配额 | 速度 | 用途 |
|------|------|------|------|
| GLM-4.6V | 20 | ⚡⚡ | 视觉+通用 |
| GLM-4.5 | 20 | ⚡⚡ | 中等任务 |
| GLM-4-Air-250414 | 40 | ⚡⚡⚡ | 简单任务 |
| GLM-4-Flash-250414 | 40 | ⚡⚡⚡ | 简单任务 |

### 🔴 稀缺配额 (复杂任务专用)
| 模型 | 配额 | 速度 | 用途 |
|------|------|------|------|
| **GLM-5** | 5 | ⚡ | 复杂设计/深度分析 |
| GLM-4.7 | 5 | ⚡ | 中复杂任务 |
| GLM-4.7-FlashX | 4 | ⚡⚡ | 快速中等 |
| GLM-4.7-Flash | 2 | ⚡⚡ | 快速中等 |

---

## 代理模型分配

### 🎯 Orchestrator (协调中心)
```json
{
  "model": {
    "primary": "GLM-4-Flash",
    "fallbacks": ["GLM-4-Air", "GLM-4-FlashX"]
  }
}
```
**原因**: 高频使用，需要快速响应，配额充足

---

### 💻 Coder (代码实现)
```json
{
  "model": {
    "primary": "GLM-4.6V",
    "fallbacks": ["GLM-4.5", "GLM-4-Flash"]
  }
}
```
**原因**: 代码需要理解上下文，中等复杂度
- 复杂代码任务 → 升级到 GLM-5
- 简单代码 → 降级到 GLM-4-Flash

---

### 🔧 Architect (架构设计)
```json
{
  "model": {
    "primary": "GLM-5",
    "fallbacks": ["GLM-4.7", "GLM-4.5"]
  }
}
```
**原因**: 架构设计是最复杂的任务，需要最好的推理能力

---

### 🤖 Automator (自动化执行)
```json
{
  "model": {
    "primary": "GLM-4-Air",
    "fallbacks": ["GLM-4-Flash", "GLM-4.7-FlashX"]
  }
}
```
**原因**: 自动化任务频率高，需要快速响应，配额充足

---

### 📚 Researcher (深度研究)
```json
{
  "model": {
    "primary": "GLM-5",
    "fallbacks": ["GLM-4.5", "GLM-4.6V"]
  }
}
```
**原因**: 研究需要深度理解，复杂任务

---

### 💰 Analyst (金融分析)
```json
{
  "model": {
    "primary": "GLM-4.5",
    "fallbacks": ["GLM-4.6V", "GLM-4-Flash"]
  }
}
```
**原因**: 金融分析需要准确性，中等复杂度

---

### 📢 Reporter (进度汇报)
```json
{
  "model": {
    "primary": "GLM-4-FlashX",
    "fallbacks": ["GLM-4-Flash", "GLM-4-Air"]
  }
}
```
**原因**: 汇报任务简单但频繁，需要极快响应

---

## 自动升降级规则

### 升级到 GLM-5 的条件
```
触发升级:
- 系统架构设计
- 深度技术研究
- 复杂算法设计
- 多系统集成
- 用户明确要求 "仔细分析"

配额限制: 5次/周期 (谨慎使用)
```

### 降级到 GLM-4-Flash 的条件
```
触发降级:
- 简单查询
- 快速问答
- 状态汇报
- 简单数据处理
- 用户要求 "快速回答"

配额充足: 1000次 (随意使用)
```

---

## 完整配置文件

```json
{
  "agents": {
    "defaults": {
      "subagents": {
        "maxConcurrent": 8,
        "maxSpawnDepth": 2,
        "maxChildrenPerAgent": 10,
        "model": {
          "primary": "GLM-4-Flash",
          "fallbacks": ["GLM-4-Air"]
        }
      }
    },
    "list": [
      {
        "id": "main",
        "name": "协调中心",
        "default": true,
        "model": {
          "primary": "GLM-4-Flash",
          "fallbacks": ["GLM-4-Air", "GLM-4-FlashX"]
        }
      },
      {
        "id": "coder",
        "name": "编程代理",
        "workspace": "~/.openclaw/workspace-coder",
        "model": {
          "primary": "GLM-4.6V",
          "fallbacks": ["GLM-4.5", "GLM-4-Flash"]
        }
      },
      {
        "id": "architect",
        "name": "架构代理",
        "workspace": "~/.openclaw/workspace-architect",
        "model": {
          "primary": "GLM-5",
          "fallbacks": ["GLM-4.7", "GLM-4.5"]
        }
      },
      {
        "id": "automator",
        "name": "自动化代理",
        "workspace": "~/.openclaw/workspace-automator",
        "model": {
          "primary": "GLM-4-Air",
          "fallbacks": ["GLM-4-Flash", "GLM-4.7-FlashX"]
        }
      },
      {
        "id": "researcher",
        "name": "学习代理",
        "workspace": "~/.openclaw/workspace-researcher",
        "model": {
          "primary": "GLM-5",
          "fallbacks": ["GLM-4.5", "GLM-4.6V"]
        }
      },
      {
        "id": "analyst",
        "name": "金融代理",
        "workspace": "~/.openclaw/workspace-analyst",
        "model": {
          "primary": "GLM-4.5",
          "fallbacks": ["GLM-4.6V", "GLM-4-Flash"]
        }
      }
    ]
  }
}
```

---

## 配额使用策略

### 日常操作 (95%)
```
协调/汇报 → GLM-4-Flash (1000次)
自动化   → GLM-4-Air (200次)
编程     → GLM-4.6V (20次)
金融     → GLM-4.5 (20次)
```

### 复杂任务 (5%)
```
架构设计 → GLM-5 (5次)
深度研究 → GLM-5 (5次)
```

### 预估日消耗
```
GLM-4-Flash:  ~50次/天
GLM-4-Air:    ~20次/天
GLM-4.6V:     ~5次/天
GLM-4.5:      ~3次/天
GLM-5:        ~1次/天 (谨慎)
```

---

## 特殊模型使用

| 模型 | 用途 | 触发条件 |
|------|------|---------|
| **GLM-4V-Flash** | 图像理解 | 涉及图片 |
| **GLM-OCR** | 文字识别 | 识别图片文字 |
| **GLM-Image** | 生成图片 | 画图需求 |
| **GLM-4-Voice** | 语音处理 | 语音相关 |
| **Search-Pro** | 联网搜索 | 需要实时信息 |
| **CodeGeeX-4** | 代码专用 | 纯编程任务 |

---
*Created: 2026-02-16 19:55*
