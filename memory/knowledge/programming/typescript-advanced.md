# TypeScript 高级类型 - 泛型

> 学习时间: 2026-02-17 05:30
> 来源: TypeScript 官方文档
> 难度: 中级

---

## 📚 核心概念

泛型允许创建可重用的组件，能够处理多种类型而非单一类型。

---

## 🎯 基础语法

### 泛型函数

```typescript
// 不使用泛型 - 类型丢失
function identity(arg: any): any {
    return arg;
}

// 使用泛型 - 保持类型信息
function identity<T>(arg: T): T {
    return arg;
}

// 调用方式1: 显式指定类型
let output = identity<string>("myString");

// 调用方式2: 类型推断（推荐）
let output = identity("myString"); // 自动推断为 string
```

### 泛型约束

```typescript
// 问题：无法访问 .length
function loggingIdentity<T>(arg: T): T {
    console.log(arg.length); // ❌ 错误
    return arg;
}

// 解决方案：使用约束
interface Lengthwise {
    length: number;
}

function loggingIdentity<T extends Lengthwise>(arg: T): T {
    console.log(arg.length); // ✅ 正确
    return arg;
}

loggingIdentity(3); // ❌ 错误：number 没有 length
loggingIdentity({ length: 10, value: 3 }); // ✅ 正确
```

---

## 🏗️ 泛型类型

### 泛型接口

```typescript
// 方式1: 泛型函数类型
interface GenericIdentityFn {
    <T>(arg: T): T;
}

// 方式2: 泛型接口
interface GenericIdentityFn<T> {
    (arg: T): T;
}

let myIdentity: GenericIdentityFn<number> = identity;
```

### 泛型类

```typescript
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
myGenericNumber.zeroValue = 0;
myGenericNumber.add = (x, y) => x + y;

// 也适用于字符串
let stringNumeric = new GenericNumber<string>();
stringNumeric.zeroValue = "";
stringNumeric.add = (x, y) => x + y;
```

---

## 🔧 高级技巧

### 使用类型参数约束

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];
}

let x = { a: 1, b: 2, c: 3, d: 4 };

getProperty(x, "a"); // ✅ 正确
getProperty(x, "m"); // ❌ 错误：m 不是 x 的属性
```

### 工厂函数

```typescript
function create<T>(c: { new (): T }): T {
    return new c();
}

class BeeKeeper {
    hasMask: boolean = true;
}

class ZooKeeper {
    nametag: string = "Mikkle";
}

class Animal {
    numLegs: number = 4;
}

class Bee extends Animal {
    keeper: BeeKeeper = new BeeKeeper();
}

class Lion extends Animal {
    keeper: ZooKeeper = new ZooKeeper();
}

function createInstance<A extends Animal>(c: new () => A): A {
    return new c();
}

createInstance(Lion).keeper.nametag; // 类型安全
createInstance(Bee).keeper.hasMask;  // 类型安全
```

---

## 💡 实用模式

### 1. 泛型数组

```typescript
function loggingIdentity<T>(arg: T[]): T[] {
    console.log(arg.length);
    return arg;
}

// 或使用 Array<T>
function loggingIdentity<T>(arg: Array<T>): Array<T> {
    console.log(arg.length);
    return arg;
}
```

### 2. 多类型参数

```typescript
function map<T, U>(array: T[], fn: (item: T) => U): U[] {
    return array.map(fn);
}

const numbers = [1, 2, 3];
const strings = map(numbers, n => n.toString());
```

### 3. 默认类型参数

```typescript
interface Container<T = string> {
    value: T;
}

const a: Container = { value: "hello" };     // T = string
const b: Container<number> = { value: 123 }; // T = number
```

---

## 🎯 最佳实践

### DO ✅
- 使用描述性的类型参数名 (T, K, V, TResult)
- 尽可能让编译器推断类型
- 使用约束限制类型范围
- 为复杂泛型添加注释

### DON'T ❌
- 过度使用泛型（简单场景用 any 或 unknown）
- 创建过于复杂的泛型约束
- 忽略类型推断失败的情况

---

## 📚 参考资源

- TypeScript 官方文档
- TypeScript Deep Dive
- Effective TypeScript

---

## 🎓 学习清单

- [x] 理解泛型基础语法
- [x] 掌握泛型约束
- [x] 学会泛型接口和类
- [ ] 实践: 创建泛型工具函数
- [ ] 进阶: 条件类型
- [ ] 进阶: 映射类型

---

*学习时长: 20分钟 | 掌握程度: 中级*
