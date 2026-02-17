# 编程知识库

> 持续更新的编程知识

---

## 前端开发

### React Hooks
**学习日期**: 2026-02-17

#### 核心概念
- `useState` - 状态管理
- `useEffect` - 副作用处理
- `useContext` - 上下文共享
- `useMemo` / `useCallback` - 性能优化

#### 最佳实践
```javascript
// 依赖数组要完整
useEffect(() => {
  fetchData(userId);
}, [userId]); // ✅ 包含所有依赖

// 避免在循环中使用 Hooks
// ❌ 错误
for (let item of items) {
  const [value, setValue] = useState(item);
}

// ✅ 正确 - 使用数组状态
const [values, setValues] = useState(items);
```

#### 相关资源
- [React 官方文档](https://react.dev)
- [useHooks](https://usehooks.com)

### React/Vue 最佳实践
**学习日期**: 2026-02-17 07:00

#### React 组件设计原则
1. **单一职责原则** - 每个组件只做一件事
2. **组件复用** - 使用自定义 Hooks 复用逻辑
3. **合理拆分** - 容器组件 vs 展示组件
4. **Props 验证** - 使用 TypeScript 或 PropTypes

```javascript
// ✅ 好的组件拆分
function UserList({ users }) {
  return (
    <div>
      {users.map(user => <UserCard key={user.id} user={user} />)}
    </div>
  );
}

// 自定义 Hook 复用逻辑
function useUserData(userId) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUser(userId).then(data => {
      setUser(data);
      setLoading(false);
    });
  }, [userId]);

  return { user, loading };
}
```

#### Vue 3 组合式 API 最佳实践
```javascript
// 使用 <script setup> 语法糖
<script setup>
import { ref, computed, onMounted } from 'vue';

const count = ref(0);
const doubled = computed(() => count.value * 2);

onMounted(() => {
  console.log('Component mounted');
});
</script>

// 组合式函数 (类似 React Hooks)
function useCounter(initial = 0) {
  const count = ref(initial);
  const increment = () => count.value++;
  const decrement = () => count.value--;

  return { count, increment, decrement };
}
```

#### 状态管理选择
- **小型应用**: React Context / Vue provide-inject
- **中型应用**: Zustand (React) / Pinia (Vue)
- **大型应用**: Redux Toolkit / Vuex

#### 关键要点
- React: 善用 useMemo/useCallback 避免不必要渲染
- Vue: 善用 computed 和 watch 处理派生状态
- 两者都避免在模板中写复杂逻辑

---

### TypeScript 高级类型
**学习日期**: 2026-02-17 07:00

#### 泛型 (Generics)
```typescript
// 泛型函数
function identity<T>(arg: T): T {
  return arg;
}

// 泛型接口
interface Box<T> {
  value: T;
}

// 泛型约束
interface Lengthwise {
  length: number;
}
function loggingIdentity<T extends Lengthwise>(arg: T): T {
  console.log(arg.length);
  return arg;
}
```

#### 高级类型工具
```typescript
// Partial - 所有属性可选
type PartialUser = Partial<User>;

// Required - 所有属性必需
type RequiredUser = Required<User>;

// Pick - 选择部分属性
type UserPreview = Pick<User, 'id' | 'name'>;

// Omit - 排除部分属性
type UserWithoutPassword = Omit<User, 'password'>;

// Record - 构造对象类型
type UserMap = Record<string, User>;

// 条件类型
type NonNullable<T> = T extends null | undefined ? never : T;
```

#### 实用模式
```typescript
// 类型守卫
function isString(value: unknown): value is string {
  return typeof value === 'string';
}

// 映射类型
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

// 模板字面量类型
type EventName = 'click' | 'scroll' | 'mousemove';
type EventHandler = `on${Capitalize<EventName>}`;
// "onClick" | "onScroll" | "onMousemove"
```

---

### 性能优化技巧
**学习日期**: 2026-02-17 07:00

#### React 性能优化
1. **代码分割**
```javascript
const LazyComponent = React.lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <LazyComponent />
    </Suspense>
  );
}
```

2. **虚拟化长列表**
```javascript
import { FixedSizeList } from 'react-window';

function VirtualList({ items }) {
  return (
    <FixedSizeList
      height={600}
      itemCount={items.length}
      itemSize={35}
    >
      {({ index, style }) => (
        <div style={style}>{items[index]}</div>
      )}
    </FixedSizeList>
  );
}
```

3. **避免不必要渲染**
```javascript
// 使用 React.memo
const UserCard = React.memo(({ user }) => {
  return <div>{user.name}</div>;
});

// 使用 useMemo 缓存计算
const sortedUsers = useMemo(
  () => users.sort((a, b) => a.name.localeCompare(b.name)),
  [users]
);

// 使用 useCallback 缓存回调
const handleClick = useCallback(() => {
  console.log('clicked');
}, []);
```

#### Vue 性能优化
1. **异步组件**
```javascript
const AsyncComponent = defineAsyncComponent(() =>
  import('./HeavyComponent.vue')
);
```

2. **v-once 和 v-memo**
```vue
<!-- 只渲染一次 -->
<div v-once>{{ staticContent }}</div>

<!-- 条件性缓存 -->
<div v-memo="[item.id]">
  {{ item.content }}
</div>
```

3. **合理使用计算属性**
```javascript
// ✅ 好 - 缓存计算结果
const filteredList = computed(() =>
  list.value.filter(item => item.active)
);

// ❌ 差 - 每次都重新计算
const filteredList = list.value.filter(item => item.active);
```

#### 通用优化技巧
- 图片优化: WebP 格式, lazy loading
- 字体优化: font-display: swap
- 代码压缩: Terser, CSSNano
- Gzip/Brotli 压缩
- CDN 加速静态资源
- Service Worker 缓存

---

### 测试驱动开发 (TDD)
**学习日期**: 2026-02-17 07:00

#### TDD 流程: Red-Green-Refactor
1. **Red** - 写一个失败的测试
2. **Green** - 写最少的代码让测试通过
3. **Refactor** - 重构代码保持测试通过

#### React 测试示例
```javascript
// UserCard.test.jsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import UserCard from './UserCard';

describe('UserCard', () => {
  it('should display user name', () => {
    render(<UserCard user={{ name: 'Alice' }} />);
    expect(screen.getByText('Alice')).toBeInTheDocument();
  });

  it('should call onClick when clicked', async () => {
    const handleClick = jest.fn();
    render(<UserCard user={{ name: 'Bob' }} onClick={handleClick} />);

    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

#### Vue 测试示例
```javascript
import { mount } from '@vue/test-utils';
import Counter from './Counter.vue';

describe('Counter', () => {
  it('increments count when button is clicked', async () => {
    const wrapper = mount(Counter);

    await wrapper.find('button').trigger('click');
    expect(wrapper.vm.count).toBe(1);
  });
});
```

#### 测试工具
- **单元测试**: Jest / Vitest
- **React 测试**: React Testing Library
- **Vue 测试**: Vue Test Utils
- **E2E 测试**: Playwright / Cypress

#### 测试原则
- 测试行为, 而非实现细节
- 用户看到什么就测什么
- 保持测试简单独立
- Mock 外部依赖

---

## 后端开发

### Node.js 并发
**学习日期**: 待学习

#### 核心概念
- (待补充)

---

## 系统设计

### 微服务架构
**学习日期**: 待学习

#### 核心概念
- (待补充)

---

*最后更新: 2026-02-17*
