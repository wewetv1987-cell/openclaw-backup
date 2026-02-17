# React Hooks 最佳实践

> 学习时间: 2026-02-17 04:20
> 来源: React 官方文档 (react.dev)

---

## 📚 核心概念

### 什么是 Hooks?
Hooks 让你在组件中使用不同的 React 特性。你可以使用内置 Hooks 或组合它们创建自己的 Hooks。

### Hooks 的优势
- 在不改变组件层级的情况下复用状态逻辑
- 将复杂组件拆分为更小的函数
- 使用更少的代码实现相同功能

---

## 🎯 内置 Hooks 分类

### 1. State Hooks（状态 Hooks）

#### `useState`
声明一个可以直接更新的状态变量。

```javascript
function ImageGallery() {
  const [index, setIndex] = useState(0);
  // ...
}
```

#### `useReducer`
声明一个状态变量，更新逻辑在 reducer 函数内部。

```javascript
function TodoList() {
  const [todos, dispatch] = useReducer(todoReducer, []);
  // ...
}
```

**选择建议**:
- 简单状态 → `useState`
- 复杂状态逻辑 → `useReducer`

---

### 2. Context Hooks（上下文 Hooks）

#### `useContext`
读取并订阅 context。

```javascript
function Button() {
  const theme = useContext(ThemeContext);
  // ...
}
```

**用途**: 从远距离父组件接收信息，无需传递 props。

---

### 3. Ref Hooks（引用 Hooks）

#### `useRef`
声明一个 ref，常用于持有 DOM 节点。

```javascript
function Form() {
  const inputRef = useRef(null);
  // ...
}
```

**特点**:
- 更新 ref 不会重新渲染组件
- 是 React 范式的"逃生舱"

#### `useImperativeHandle`
自定义组件暴露的 ref（很少使用）。

---

### 4. Effect Hooks（副作用 Hooks）

#### `useEffect`
将组件连接到外部系统。

```javascript
function ChatRoom({ roomId }) {
  useEffect(() => {
    const connection = createConnection(roomId);
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]);
  // ...
}
```

**重要原则**:
- Effects 是 React 范式的"逃生舱"
- 不要用 Effects 编排应用数据流
- 如果不与外部系统交互，可能不需要 Effect

**变体**:
- `useLayoutEffect` - 浏览器重新绘制屏幕前触发
- `useInsertionEffect` - React 修改 DOM 前触发（用于 CSS-in-JS）
- `useEffectEvent` - 从 Effect 中分离事件

---

### 5. Performance Hooks（性能 Hooks）

#### 缓存优化

##### `useMemo`
缓存昂贵计算的结果。

```javascript
function TodoList({ todos, tab, theme }) {
  const visibleTodos = useMemo(() => filterTodos(todos, tab), [todos, tab]);
  // ...
}
```

##### `useCallback`
缓存函数定义，传递给优化组件。

```javascript
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

#### 优先级渲染

##### `useTransition`
将状态转换标记为非阻塞。

```javascript
const [isPending, startTransition] = useTransition();
```

##### `useDeferredValue`
推迟更新非关键 UI 部分。

```javascript
const deferredValue = useDeferredValue(value);
```

---

### 6. Other Hooks（其他 Hooks）

- `useDebugValue` - 自定义 React DevTools 标签
- `useId` - 生成唯一 ID（无障碍 API）
- `useSyncExternalStore` - 订阅外部 store
- `useActionState` - 管理操作状态

---

## 🎨 自定义 Hooks

### 核心原则

1. **Hook 名称必须以 `use` 开头**（后跟大写字母）
2. **组件名称必须以大写字母开头**
3. **自定义 Hooks 共享状态逻辑，而非状态本身**

### 示例: `useOnlineStatus`

**提取前（重复代码）**:
```javascript
function StatusBar() {
  const [isOnline, setIsOnline] = useState(true);
  useEffect(() => {
    function handleOnline() {
      setIsOnline(true);
    }
    function handleOffline() {
      setIsOnline(false);
    }
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  return <h1>{isOnline ? '✅ Online' : '❌ Disconnected'}</h1>;
}
```

**提取后（自定义 Hook）**:
```javascript
// useOnlineStatus.js
import { useState, useEffect } from 'react';

export function useOnlineStatus() {
  const [isOnline, setIsOnline] = useState(true);
  useEffect(() => {
    function handleOnline() {
      setIsOnline(true);
    }
    function handleOffline() {
      setIsOnline(false);
    }
    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);
    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);
  return isOnline;
}

// 使用
function StatusBar() {
  const isOnline = useOnlineStatus();
  return <h1>{isOnline ? '✅ Online' : '❌ Disconnected'}</h1>;
}
```

### 优势
- **代码描述"做什么"而非"如何做"**
- 隐藏外部系统的复杂细节
- 组件代码表达意图，而非实现

---

## ⚠️ 重要规则

### 1. 只在顶层调用 Hooks
❌ 不要在循环、条件或嵌套函数中调用 Hooks
✅ 在 React 函数的顶层使用 Hooks

### 2. 只在 React 函数中调用 Hooks
- React 函数组件
- 自定义 Hooks

### 3. 自定义 Hooks 必须使用其他 Hooks
```javascript
// ❌ 错误: 不使用任何 Hook 的"Hook"
function useSorted(items) {
  return items.slice().sort();
}

// ✅ 正确: 使用其他 Hook 的 Hook
function useAuth() {
  return useContext(Auth);
}
```

---

## 🔍 最佳实践

### 1. 状态管理
- 简单状态 → `useState`
- 复杂状态逻辑 → `useReducer`
- 全局状态 → Context API + Hooks

### 2. 副作用处理
- 外部系统同步 → `useEffect`
- 数据获取 → 考虑 React Query / SWR
- 订阅管理 → 清理函数必不可少

### 3. 性能优化
- 昂贵计算 → `useMemo`
- 回调函数 → `useCallback`
- 非阻塞更新 → `useTransition`

### 4. 自定义 Hooks
- 重复逻辑 → 提取为自定义 Hook
- 相关逻辑 → 组合在自定义 Hook 中
- 命名清晰 → 描述它做什么

---

## 💡 实战模式

### 模式 1: 表单输入
```javascript
function useFormInput(initialValue) {
  const [value, setValue] = useState(initialValue);

  function handleChange(e) {
    setValue(e.target.value);
  }

  return {
    value: value,
    onChange: handleChange
  };
}

// 使用
function Form() {
  const firstNameProps = useFormInput('Mary');
  const lastNameProps = useFormInput('Poppins');

  return (
    <>
      <input {...firstNameProps} />
      <input {...lastNameProps} />
      <p>{firstNameProps.value} {lastNameProps.value}</p>
    </>
  );
}
```

### 模式 2: 数据获取
```javascript
function useFetch(url) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(error => {
        setError(error);
        setLoading(false);
      });
  }, [url]);

  return { data, loading, error };
}
```

### 模式 3: 本地存储
```javascript
function useLocalStorage(key, initialValue) {
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      return initialValue;
    }
  });

  const setValue = (value) => {
    try {
      setStoredValue(value);
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue];
}
```

---

## 🎯 何时提取自定义 Hook?

**考虑提取的信号**:
1. 多个组件有重复的状态逻辑
2. Effect 中的代码变得复杂
3. 需要在不同组件间共享副作用

**不需要提取的情况**:
1. 只在一个组件使用
2. 逻辑简单清晰
3. 为了提取而提取

---

## 📚 参考资源

- [React 官方文档 - Hooks](https://react.dev/reference/react/hooks)
- [React 官方文档 - 自定义 Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks)
- [React Hooks 规则](https://react.dev/reference/rules/rules-of-hooks)

---

## ✅ 学习清单

- [x] 理解 Hooks 的基本概念
- [x] 掌握内置 Hooks 的分类和用途
- [x] 学会创建自定义 Hooks
- [x] 了解 Hooks 的命名约定和规则
- [x] 掌握常见的 Hooks 最佳实践
- [ ] 实践: 创建一个自定义 Hook
- [ ] 深入: React 18 并发特性
- [ ] 扩展: 状态管理库集成

---

*学习时长: 约15分钟 | 掌握程度: 基础*
