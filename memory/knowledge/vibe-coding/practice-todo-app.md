# Vibe Coding 实战：从零生成 Todo 应用

> 学习时间：2026-02-17 13:30
> 难度：入门级
> 状态：已完成 ✅

## 🎯 学习目标

通过 Vibe Coding 方式完整生成一个 Todo 应用，掌握：
1. 如何用自然语言描述项目需求
2. 迭代式开发流程
3. 从 MVP 到完整产品的演进
4. 测试和部署

---

## 📋 项目规格

### 功能需求
- ✅ 添加新任务
- ✅ 标记任务完成/未完成
- ✅ 删除任务
- ✅ 过滤任务（全部/待办/已完成）
- ✅ 本地存储持久化
- ✅ 清空已完成任务

### 技术栈
- **Frontend**: React + TypeScript
- **Styling**: Tailwind CSS
- **State**: React Hooks (useState, useEffect)
- **Storage**: localStorage

---

## 🚀 生成过程

### 第一步：生成基础结构

**Prompt 1 - 项目骨架**
```markdown
Create a React Todo application with TypeScript:

Tech Stack:
- React 18 + TypeScript
- Tailwind CSS for styling
- Use functional components and hooks

Basic Features:
- Display a list of todos
- Add new todo
- Toggle todo completion
- Delete todo

Structure:
- Use a clean folder structure
- Separate components logically
- Include proper TypeScript types
```

**预期输出**：
```
src/
├── components/
│   ├── TodoList.tsx
│   ├── TodoItem.tsx
│   └── AddTodo.tsx
├── types/
│   └── todo.ts
├── App.tsx
└── index.tsx
```

**类型定义**：
```typescript
interface Todo {
  id: string;
  text: string;
  completed: boolean;
  createdAt: Date;
}

type FilterType = 'all' | 'active' | 'completed';
```

---

### 第二步：添加过滤功能

**Prompt 2 - 过滤器**
```markdown
Add filtering capability to the Todo app:

Requirements:
- Three filter buttons: All | Active | Completed
- Show count of remaining tasks
- Persist selected filter in localStorage

Implementation:
- Add FilterType to state
- Create FilterButtons component
- Update visible todos based on filter
```

**关键代码模式**：
```typescript
const [filter, setFilter] = useState<FilterType>('all');

const filteredTodos = todos.filter(todo => {
  if (filter === 'active') return !todo.completed;
  if (filter === 'completed') return todo.completed;
  return true;
});

const activeCount = todos.filter(t => !t.completed).length;
```

---

### 第三步：数据持久化

**Prompt 3 - LocalStorage**
```markdown
Implement localStorage persistence:

Requirements:
- Save todos to localStorage on every change
- Load todos from localStorage on app start
- Handle potential JSON parse errors
- Add timestamp to each todo

Implementation details:
- Use useEffect for side effects
- Create custom hook: useLocalStorage
- Add error boundaries
```

**自定义 Hook**：
```typescript
function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error('Error reading localStorage:', error);
      return initialValue;
    }
  });

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error('Error saving to localStorage:', error);
    }
  };

  return [storedValue, setValue] as const;
}
```

---

### 第四步：优化用户体验

**Prompt 4 - UX 改进**
```markdown
Enhance user experience with these features:

Features:
1. Empty state when no todos
2. Confirmation before clearing completed
3. Keyboard shortcuts (Enter to add)
4. Visual feedback on actions
5. Smooth animations

UI Polish:
- Add hover effects
- Strike-through for completed todos
- Responsive design
- Accessibility labels (ARIA)
```

**动画和过渡**：
```typescript
// Tailwind CSS classes for animations
const todoClasses = `
  group flex items-center gap-3 p-4 
  bg-white border-b border-gray-200 
  hover:bg-gray-50 transition-all
  ${isDeleting ? 'opacity-0 transform -translate-x-full' : ''}
`;
```

---

## 🎨 完整组件示例

### AddTodo 组件
```typescript
import React, { useState, KeyboardEvent } from 'react';

interface AddTodoProps {
  onAdd: (text: string) => void;
}

export function AddTodo({ onAdd }: AddTodoProps) {
  const [text, setText] = useState('');

  const handleSubmit = () => {
    const trimmed = text.trim();
    if (trimmed) {
      onAdd(trimmed);
      setText('');
    }
  };

  const handleKeyPress = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      handleSubmit();
    }
  };

  return (
    <div className="flex gap-2 p-4 border-b-2 border-gray-200">
      <input
        type="text"
        value={text}
        onChange={(e) => setText(e.target.value)}
        onKeyPress={handleKeyPress}
        placeholder="What needs to be done?"
        className="flex-1 px-4 py-2 border border-gray-300 rounded-lg
                   focus:outline-none focus:ring-2 focus:ring-blue-500"
        aria-label="New todo text"
      />
      <button
        onClick={handleSubmit}
        disabled={!text.trim()}
        className="px-6 py-2 bg-blue-500 text-white rounded-lg
                   hover:bg-blue-600 disabled:opacity-50
                   disabled:cursor-not-allowed transition-colors"
        aria-label="Add todo"
      >
        Add
      </button>
    </div>
  );
}
```

### TodoItem 组件
```typescript
import React from 'react';

interface TodoItemProps {
  id: string;
  text: string;
  completed: boolean;
  onToggle: (id: string) => void;
  onDelete: (id: string) => void;
}

export function TodoItem({ 
  id, 
  text, 
  completed, 
  onToggle, 
  onDelete 
}: TodoItemProps) {
  return (
    <div className="group flex items-center gap-3 p-4 bg-white border-b border-gray-200 hover:bg-gray-50 transition-colors">
      <input
        type="checkbox"
        checked={completed}
        onChange={() => onToggle(id)}
        className="w-5 h-5 rounded border-gray-300 text-blue-500
                   focus:ring-2 focus:ring-blue-500 cursor-pointer"
        aria-label={`Mark "${text}" as ${completed ? 'incomplete' : 'complete'}`}
      />
      
      <span 
        className={`flex-1 ${completed ? 'line-through text-gray-400' : 'text-gray-800'}`}
      >
        {text}
      </span>
      
      <button
        onClick={() => onDelete(id)}
        className="opacity-0 group-hover:opacity-100 px-3 py-1 
                   text-red-500 hover:text-red-700 hover:bg-red-50 
                   rounded transition-all"
        aria-label={`Delete "${text}"`}
      >
        Delete
      </button>
    </div>
  );
}
```

---

## 📊 性能优化

### 1. 使用 React.memo
```typescript
export const TodoItem = React.memo(({ id, text, completed, onToggle, onDelete }: TodoItemProps) => {
  // 组件实现
});
```

### 2. 避免不必要的重渲染
```typescript
const handleToggle = useCallback((id: string) => {
  setTodos(todos.map(todo => 
    todo.id === id ? { ...todo, completed: !todo.completed } : todo
  ));
}, [todos]);
```

### 3. 虚拟列表（对于大量数据）
```typescript
import { FixedSizeList } from 'react-window';

// 当 todo 数量超过 100 时使用
```

---

## 🧪 测试策略

### 单元测试
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { TodoItem } from './TodoItem';

describe('TodoItem', () => {
  it('should display todo text', () => {
    render(
      <TodoItem 
        id="1" 
        text="Test todo" 
        completed={false}
        onToggle={jest.fn()}
        onDelete={jest.fn()}
      />
    );
    
    expect(screen.getByText('Test todo')).toBeInTheDocument();
  });

  it('should call onToggle when checkbox clicked', () => {
    const mockToggle = jest.fn();
    render(
      <TodoItem 
        id="1" 
        text="Test" 
        completed={false}
        onToggle={mockToggle}
        onDelete={jest.fn()}
      />
    );
    
    fireEvent.click(screen.getByRole('checkbox'));
    expect(mockToggle).toHaveBeenCalledWith('1');
  });
});
```

### 集成测试
```typescript
describe('Todo App Integration', () => {
  it('should add, complete, and delete a todo', async () => {
    render(<App />);
    
    // Add todo
    const input = screen.getByPlaceholderText(/what needs to be done/i);
    fireEvent.change(input, { target: { value: 'New task' } });
    fireEvent.click(screen.getByText('Add'));
    
    // Complete todo
    const checkbox = screen.getByRole('checkbox', { name: /new task/i });
    fireEvent.click(checkbox);
    expect(screen.getByText('New task')).toHaveClass('line-through');
    
    // Delete todo
    fireEvent.click(screen.getByLabelText(/delete "new task"/i));
    expect(screen.queryByText('New task')).not.toBeInTheDocument();
  });
});
```

---

## 🚢 部署

### Vercel 部署
```bash
# 安装 Vercel CLI
npm i -g vercel

# 部署
vercel

# 生产环境
vercel --prod
```

### Netlify 部署
```bash
# 构建命令
npm run build

# 发布目录
dist/

# 重定向配置 (_redirects)
/* /index.html 200
```

---

## 💡 关键学习点

### 1. Vibe Coding 工作流
- ✅ 从自然语言描述开始
- ✅ 分阶段迭代生成
- ✅ 每个阶段都可以运行测试
- ✅ 逐步添加复杂度

### 2. Prompt 技巧
- ✅ 明确技术栈和约束
- ✅ 分步骤描述需求
- ✅ 要求完整的类型定义
- ✅ 指定代码风格和规范

### 3. 常见陷阱
- ❌ 一次性要求太多功能
- ❌ 忽略错误处理
- ❌ 不测试就集成
- ❌ 忘记性能优化

### 4. 最佳实践
- ✅ 使用 TypeScript 保证类型安全
- ✅ 组件化思维
- ✅ 关注点分离
- ✅ 可访问性（A11y）
- ✅ 响应式设计

---

## 🎓 扩展练习

### 初级
- [ ] 添加任务编辑功能
- [ ] 实现任务优先级（高/中/低）
- [ ] 添加任务分类/标签

### 中级
- [ ] 拖拽排序（react-dnd）
- [ ] 多语言支持（i18n）
- [ ] 暗黑模式切换

### 高级
- [ ] 后端 API 集成（替换 localStorage）
- [ ] 用户认证系统
- [ ] 实时协作（WebSocket）
- [ ] PWA 支持（离线可用）

---

## 📚 相关资源

- [React 官方文档](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS 文档](https://tailwindcss.com/docs)
- [Testing Library](https://testing-library.com/docs/react-testing-library/intro/)

---

## 📝 笔记总结

这个项目展示了如何用 Vibe Coding 方式从零构建一个完整的应用：

1. **需求分解**：将大功能拆分为小步骤
2. **迭代生成**：每一步都生成可运行的代码
3. **持续优化**：从功能实现到用户体验
4. **质量保证**：测试、性能、可访问性

**关键成功因素**：
- 清晰的 Prompt 描述
- 分阶段开发
- 及时测试验证
- 逐步完善细节

**适用场景**：
- 快速原型验证
- 学习新技术栈
- 小型项目开发
- 代码示例生成

---
*完成时间：2026-02-17 13:30*
*学习状态：已掌握 ✅*
*下一步：实践项目脚手架创建*
