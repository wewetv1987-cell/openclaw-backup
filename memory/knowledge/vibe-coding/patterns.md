# Vibe Coding 提示词模式库

## 核心模式

### 1. 组件创建模式

**基本格式**
```
Create a [component type] that [does X/Y/Z]
```

**示例**
- "Create a Todo list component that allows adding, deleting, and marking items as complete"
- "Build a responsive navigation bar with a mobile menu"

**效果**: 9/10
**使用次数**: 15+

**最佳实践**
- 明确组件类型（按钮、卡片、表单等）
- 列出所有核心功能
- 如果需要，指定技术栈（React、Vue 等）

---

### 2. 功能扩展模式

**基本格式**
```
Extend [existing code] to [add new functionality]
```

**示例**
- "Extend this form to include validation for email and password fields"
- "Add drag-and-drop functionality to this list component"

**效果**: 8/10
**使用次数**: 10+

**最佳实践**
- 提供现有代码上下文
- 清楚说明新增功能
- 描述期望的用户交互

---

### 3. 代码重构模式

**基本格式**
```
Refactor this code to [goal]: [code]
```

**示例**
- "Refactor this code to improve readability and reduce duplication"
- "Convert this JavaScript to TypeScript with proper types"

**效果**: 8.5/10
**使用次数**: 8+

**最佳实践**
- 明确重构目标（性能、可读性、可维护性）
- 提供完整代码片段
- 指定技术约束

---

### 4. 调试模式

**基本格式**
```
Debug this error: [error message]
Code: [code]
```

**示例**
- "Debug this error: 'TypeError: Cannot read property of undefined'"
- "Fix this bug: The submit button doesn't trigger the form submission"

**效果**: 7.5/10
**使用次数**: 12+

**最佳实践**
- 提供完整错误消息
- 包含相关代码
- 描述预期行为 vs 实际行为

---

### 5. 项目脚手架模式

**基本格式**
```
Create a [project type] with [tech stack]
Features: [list features]
```

**示例**
- "Create a full-stack e-commerce app with React, Node.js, and MongoDB. Features: user auth, product catalog, shopping cart, checkout"

**效果**: 8/10
**使用次数**: 5+

**最佳实践**
- 明确技术栈和版本
- 列出所有必需功能
- 如果需要，指定文件结构

---

### 6. API 开发模式

**基本格式**
```
Create an API endpoint that [does X]
Using: [technology]
```

**示例**
- "Create a REST API endpoint for user authentication using Node.js and Express"
- "Build a GraphQL API for a blog with posts and comments"

**效果**: 8.5/10
**使用次数**: 7+

**最佳实践**
- 指定 API 类型（REST、GraphQL）
- 描述端点功能
- 说明认证和安全要求

---

### 7. UI/UX 实现模式

**基本格式**
```
Design and implement [UI element]
Style: [design requirements]
```

**示例**
- "Design and implement a modern landing page hero section with a gradient background, headline, and CTA button"

**效果**: 8/10
**使用次数**: 6+

**最佳实践**
- 描述视觉风格
- 指定响应式要求
- 提供设计参考（如果有）

---

### 8. 数据处理模式

**基本格式**
```
Process this data: [data]
Requirements: [what to do]
```

**示例**
- "Process this JSON data to calculate total sales per category"
- "Transform this CSV file into a structured array of objects"

**效果**: 9/10
**使用次数**: 9+

**最佳实践**
- 提供示例数据
- 清楚描述输出格式
- 说明任何边缘情况处理

---

### 9. 测试模式

**基本格式**
```
Write tests for [code/function]
Framework: [testing framework]
Coverage: [what to test]
```

**示例**
- "Write unit tests for this user authentication service using Jest. Test successful login, invalid credentials, and error handling"

**效果**: 8/10
**使用次数**: 4+

**最佳实践**
- 指定测试框架
- 列出测试场景
- 说明期望的覆盖率

---

### 10. 性能优化模式

**基本格式**
```
Optimize this code for [goal]
Current: [code]
Constraints: [any limitations]
```

**示例**
- "Optimize this loop for performance. Currently O(n²), need to improve to O(n log n)"

**效果**: 7.5/10
**使用次数**: 3+

**最佳实践**
- 明确优化目标（速度、内存）
- 提供性能分析（如果有）
- 说明功能约束

---

## 高级技巧

### 上下文管理
- 对于复杂任务，分阶段提供信息
- 先概述，然后逐步深入
- 使用对话来澄清需求

### 迭代优化
- 从简单实现开始
- 逐步添加功能
- 每次迭代都保持代码可运行

### 错误处理
- 明确错误处理要求
- 描述边缘情况
- 指定错误消息格式

### 代码风格
- 提供代码风格示例
- 指定命名约定
- 要求注释和文档

---

## 模式组合示例

**场景：创建一个用户管理系统**

```
Phase 1: Setup
"Create a full-stack project with React frontend and Node.js/Express backend. Set up basic folder structure and dependencies."

Phase 2: Backend API
"Create REST API endpoints for user CRUD operations:
- POST /api/users - create user
- GET /api/users - list all users
- GET /api/users/:id - get user by id
- PUT /api/users/:id - update user
- DELETE /api/users/:id - delete user"

Phase 3: Frontend Components
"Create React components for user management:
- UserList component to display all users
- UserForm component to add/edit users
- UserCard component to display single user"

Phase 4: Integration
"Integrate frontend with backend API. Include error handling and loading states."
```

---

*最后更新: 2026-02-17*
*状态: 持续更新中*
