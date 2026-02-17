# 多代理模型角色分配 v4.0

> 每个代理角色使用专用模型，根据任务难度自动分配，支持并发

## 模型资源池

### 🔴 复杂模型 (GLM-5)
- **配额**: 5次/周期
- **能力**: 最强推理、深度分析、复杂设计
- **适用**: 架构设计、深度研究、复杂算法

### 🟡 中等模型 (GLM-4.7, GLM-4.6V, GLM-4.5)
- **GLM-4.7**: 5次 - 高质量推理
- **GLM-4.6V**: 20次 - 视觉+通用
- **GLM-4.5**: 20次 - 平衡性能

### 🟢 快速模型 (GLM-4-Flash, GLM-4-Air)
- **GLM-4-Flash**: 1000次 - 极速响应
- **GLM-4-Air**: 200次 - 快速简单
- **GLM-4-FlashX**: 100次 - 快速+推理

---

## 代理角色模型分配

### 🎯 Main (协调中心)
```json
{
  "id": "main",
  "model": {
    "primary": "zai/glm-4-flash",
    "fallbacks": ["zai/glm-4-air"]
  },
  "reason": "高频使用，需要极快响应，配额充足"
}
```

**任务类型**: 任务分配、状态汇报、用户交互
**预期消耗**: ~50次/天
**并发能力**: ⭐⭐⭐⭐⭐ (极高)

---

### 💻 Coder (编程代理)
```json
{
  "id": "coder",
  "model": {
    "primary": "zai/glm-4.7-flash",
    "fallbacks": ["zai/glm-4.6v", "zai/glm-4.5"]
  },
  "reason": "代码需要理解上下文，中等复杂度"
}
```

**任务类型**: 写代码、调试、代码审查
**预期消耗**: ~10次/天
**并发能力**: ⭐⭐⭐⭐ (高)

**自动升级规则**:
- 复杂算法设计 → 升级到 GLM-5
- 简单代码修改 → 降级到 GLM-4.5

---

### 🔧 Architect (架构代理) ⭐ GLM-5 专用
```json
{
  "id": "architect",
  "model": {
    "primary": "zai/glm-5",
    "fallbacks": ["zai/glm-4.7-flash"]
  },
  "reason": "架构设计是最复杂的任务，需要最强推理能力"
}
```

**任务类型**: 系统架构、技术选型、API设计、复杂决策
**预期消耗**: ~2次/天 (谨慎使用)
**并发能力**: ⭐⭐ (低，配额稀缺)

**使用条件**:
- ✅ 系统架构设计
- ✅ 复杂技术选型
- ✅ 多系统集成
- ✅ 用户明确要求 "仔细设计"

---

### 🤖 Automator (自动化代理)
```json
{
  "id": "automator",
  "model": {
    "primary": "zai/glm-4.5",
    "fallbacks": ["zai/glm-4-air", "zai/glm-4-flash"]
  },
  "reason": "自动化任务频率高，需要快速响应"
}
```

**任务类型**: 浏览器自动化、批量处理、定时任务
**预期消耗**: ~20次/天
**并发能力**: ⭐⭐⭐⭐⭐ (极高)

---

### 📚 Researcher (研究员) ⭐ GLM-5 专用
```json
{
  "id": "researcher",
  "model": {
    "primary": "zai/glm-5",
    "fallbacks": ["zai/glm-4.6v"]
  },
  "reason": "深度研究需要最强的理解和分析能力"
}
```

**任务类型**: 深度研究、技术学习、知识整理、复杂分析
**预期消耗**: ~2次/天 (谨慎使用)
**并发能力**: ⭐⭐ (低，配额稀缺)

**使用条件**:
- ✅ 深度技术研究
- ✅ 学习复杂新技术
- ✅ 整理复杂知识体系
- ✅ 用户要求 "深度研究"

---

### 💰 Analyst (金融分析师)
```json
{
  "id": "analyst",
  "model": {
    "primary": "zai/glm-4.6v",
    "fallbacks": ["zai/glm-4.5", "zai/glm-4-flash"]
  },
  "reason": "金融分析需要视觉能力（看图表）+ 准确性"
}
```

**任务类型**: 股票分析、金融数据处理、投资建议
**预期消耗**: ~10次/天
**并发能力**: ⭐⭐⭐⭐ (高)

**自动升级规则**:
- 复杂投资策略 → 升级到 GLM-5
- 简单数据查询 → 降级到 GLM-4-Flash

---

### 📢 Reporter (进度汇报)
```json
{
  "id": "reporter",
  "model": {
    "primary": "zai/glm-4-flashx",
    "fallbacks": ["zai/glm-4-flash"]
  },
  "reason": "汇报任务简单但频繁，需要快速响应"
}
```

**任务类型**: 进度汇报、状态通知、结果汇总
**预期消耗**: ~30次/天
**并发能力**: ⭐⭐⭐⭐⭐ (极高)

---

## 并发任务分配示例

### 场景1: 简单查询
```
用户: "现在几点了？"

分配:
- Main: GLM-4-Flash ⚡⚡⚡ (0.1秒)
并发: 1个模型
总消耗: 1次 Flash
```

---

### 场景2: 编程任务
```
用户: "写一个登录功能"

分配:
- Main: GLM-4-Flash (任务分配)
- Coder: GLM-4.7-Flash (代码实现)

并发: 2个模型同时工作
总消耗: 1次 Flash + 1次 4.7
```

---

### 场景3: 复杂系统设计
```
用户: "设计一个电商系统"

分配:
- Main: GLM-4-Flash (协调)
- Architect: GLM-5 ⭐ (架构设计)
- Coder: GLM-4.7-Flash (代码实现)
- Analyst: GLM-4.6V (数据分析)

并发: 4个模型同时工作
总消耗: 1次 Flash + 1次 5 + 1次 4.7 + 1次 4.6V
```

---

### 场景4: 并发多任务
```
任务1: "分析腾讯股票"
任务2: "写一个爬虫"
任务3: "学习React"

并发分配:
- 任务1 → Analyst: GLM-4.6V
- 任务2 → Coder: GLM-4.7-Flash
- 任务3 → Researcher: GLM-5 ⭐

3个代理同时工作，互不干扰
```

---

## 完整配置

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "zai/glm-4-flash",
        "fallbacks": ["zai/glm-4-air"]
      },
      "subagents": {
        "maxConcurrent": 8,
        "maxSpawnDepth": 2,
        "maxChildrenPerAgent": 10
      }
    },
    "list": [
      {
        "id": "main",
        "name": "协调中心",
        "default": true,
        "model": {
          "primary": "zai/glm-4-flash",
          "fallbacks": ["zai/glm-4-air"]
        }
      },
      {
        "id": "coder",
        "name": "编程代理",
        "model": {
          "primary": "zai/glm-4.7-flash",
          "fallbacks": ["zai/glm-4.6v", "zai/glm-4.5"]
        }
      },
      {
        "id": "architect",
        "name": "架构代理",
        "model": {
          "primary": "zai/glm-5",
          "fallbacks": ["zai/glm-4.7-flash"]
        }
      },
      {
        "id": "automator",
        "name": "自动化代理",
        "model": {
          "primary": "zai/glm-4.5",
          "fallbacks": ["zai/glm-4-air"]
        }
      },
      {
        "id": "researcher",
        "name": "研究代理",
        "model": {
          "primary": "zai/glm-5",
          "fallbacks": ["zai/glm-4.6v"]
        }
      },
      {
        "id": "analyst",
        "name": "金融代理",
        "model": {
          "primary": "zai/glm-4.6v",
          "fallbacks": ["zai/glm-4.5"]
        }
      }
    ]
  },
  "tools": {
    "agentToAgent": {
      "enabled": true,
      "allow": ["*"]
    }
  }
}
```

---

## 配额消耗预估

### 每日消耗
```
GLM-5:        ~2次  (Architect + Researcher)
GLM-4.7:      ~10次 (Coder)
GLM-4.6V:     ~10次 (Analyst)
GLM-4.5:      ~20次 (Automator)
GLM-4-Flash:  ~50次 (Main + Reporter)
GLM-4-Air:    ~20次 (Fallback)
```

### 峰值并发
```
最多同时运行: 8个子代理
配置分布:
- 2个 GLM-5 (复杂任务)
- 2个 GLM-4.7 (编程)
- 2个 GLM-4.6V/4.5 (分析/自动化)
- 2个 GLM-4-Flash (协调/汇报)
```

---

## 自动升级/降级规则

### 升级到 GLM-5
```
触发条件:
- 系统架构设计
- 复杂算法设计
- 深度技术研究
- 多系统集成
- 用户明确要求

限制: 每天不超过2次
```

### 降级到 GLM-4-Flash
```
触发条件:
- 简单查询
- 快速问答
- 状态汇报
- 简单数据处理

无限制: 配额充足 (1000次)
```

---

## 模型角色对照表

| 代理 | 主模型 | 复杂度 | 配额 | 并发能力 |
|------|--------|--------|------|---------|
| 🎯 Main | GLM-4-Flash | 简单 | 1000 | ⭐⭐⭐⭐⭐ |
| 💻 Coder | GLM-4.7-Flash | 中等 | 5 | ⭐⭐⭐⭐ |
| 🔧 Architect | **GLM-5** | **复杂** | **5** | ⭐⭐ |
| 🤖 Automator | GLM-4.5 | 简单 | 20 | ⭐⭐⭐⭐⭐ |
| 📚 Researcher | **GLM-5** | **复杂** | **5** | ⭐⭐ |
| 💰 Analyst | GLM-4.6V | 中等 | 20 | ⭐⭐⭐⭐ |
| 📢 Reporter | GLM-4-FlashX | 简单 | 100 | ⭐⭐⭐⭐⭐ |

---
*Created: 2026-02-16 20:56*
*Version: 4.0 - 角色专用模型分配*
