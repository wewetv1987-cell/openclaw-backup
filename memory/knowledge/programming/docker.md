# Docker 容器化部署知识

> 学习日期: 2026-02-17
> 来源: Docker 官方文档

## 核心概念

### 1. 容器 (Container)

**定义**: 容器是应用程序组件的隔离进程。每个组件在自己的隔离环境中运行。

**核心特性**:
- **自包含 (Self-contained)**: 拥有运行所需的一切，不依赖主机预装依赖
- **隔离性 (Isolated)**: 与主机和其他容器最小化影响，提高安全性
- **独立性 (Independent)**: 每个容器独立管理，删除一个不影响其他
- **可移植性 (Portable)**: 在开发机、数据中心、云端运行一致

**容器 vs 虚拟机**:
- VM: 完整操作系统 + 内核 + 驱动 + 程序 (高开销)
- 容器: 仅隔离进程 + 所需文件，共享内核 (轻量级)

**最佳实践**: 常见云环境在 VM 上运行容器运行时，运行多个容器化应用提高资源利用率。

---

### 2. 镜像 (Image)

**定义**: 标准化包，包含运行容器的所有文件、二进制、库和配置。

**两个重要原则**:
1. **不可变性 (Immutable)**: 镜像创建后不可修改，只能创建新镜像或在其上添加层
2. **分层结构 (Layered)**: 每层代表文件系统变更（添加/删除/修改文件）

**镜像组成**:
```
Python 基础镜像 (底层)
  ↓
安装依赖层
  ↓
应用代码层
  ↓
配置文件层
```

**镜像来源**:
- **Docker Hub**: 默认全球镜像市场，100,000+ 镜像
- **Docker Official Images**: Docker 精选官方镜像 (Node, Redis, PostgreSQL 等)
- **Docker Hardened Images**: 生产级安全镜像，近乎零 CVE
- **Docker Verified Publishers**: Docker 验证的商业发布者镜像
- **Docker-Sponsored Open Source**: Docker 赞助的开源项目镜像

---

### 3. Docker Compose

**定义**: 用于定义和运行多容器应用的工具，通过 YAML 文件配置所有容器。

**核心优势**:
- **声明式配置**: 定义所需状态，Docker Compose 智能应用变更
- **单文件管理**: `compose.yaml` 包含所有服务配置
- **一键部署**: `docker compose up` 启动整个应用栈
- **易于清理**: `docker compose down` 移除所有资源

**Dockerfile vs Compose 文件**:
- Dockerfile: 构建容器镜像的指令
- Compose 文件: 定义运行中的容器配置
- 常见模式: Compose 引用 Dockerfile 构建镜像

**Compose 示例结构**:
```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - mysql
  
  mysql:
    image: mysql:8
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret

volumes:
  todo-mysql-data:
```

---

## 最佳实践

### 1. 单一职责原则
- ✅ 每个容器做一件事并做好
- ❌ 避免一个容器做多个事情
- 示例: 前端、后端、数据库分别在不同容器

### 2. 分层策略
```dockerfile
# 从基础镜像开始
FROM node:18-alpine

# 安装依赖 (利用缓存层)
COPY package*.json ./
RUN npm install

# 添加应用代码 (最上层)
COPY . .

# 配置启动命令
CMD ["npm", "start"]
```

### 3. 数据持久化
- 使用 **Volumes** 持久化数据
- 默认 `docker compose down` 不删除卷
- 删除卷: `docker compose down --volumes`

### 4. 网络管理
- Docker Compose 自动创建网络
- 容器通过服务名互相访问
- 示例: `app` 容器可通过 `mysql:3306` 访问数据库

---

## 常用命令

### 容器管理
```bash
# 运行容器
docker run -d -p 8080:80 nginx

# 查看运行容器
docker ps

# 查看所有容器 (包括停止的)
docker ps -a

# 停止容器
docker stop <container-id>

# 删除容器
docker rm <container-id>
```

### 镜像管理
```bash
# 搜索镜像
docker search nginx

# 拉取镜像
docker pull nginx:latest

# 查看本地镜像
docker image ls

# 查看镜像层
docker image history nginx:latest

# 删除镜像
docker image rm nginx:latest
```

### Compose 管理
```bash
# 启动应用
docker compose up -d --build

# 查看日志
docker compose logs -f

# 停止应用
docker compose down

# 停止并删除卷
docker compose down --volumes
```

---

## 实战场景

### 场景 1: 开发环境标准化
```yaml
# docker-compose.dev.yml
version: '3.8'
services:
  frontend:
    build: 
      context: ./frontend
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
  
  backend:
    build: ./backend
    ports:
      - "5000:5000"
    volumes:
      - ./backend:/app
    depends_on:
      - db
  
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

### 场景 2: 微服务架构
```yaml
# 每个微服务一个容器
services:
  api-gateway:
    image: nginx:alpine
    ports:
      - "80:80"
  
  user-service:
    build: ./user-service
    expose:
      - "8080"
  
  order-service:
    build: ./order-service
    expose:
      - "8080"
  
  message-queue:
    image: redis:alpine
  
  database:
    image: mysql:8
```

---

## 与 Vibe Coding 结合

### 1. 快速原型开发
- 使用 Vibe Coding 生成应用代码
- 自动生成 Dockerfile 和 docker-compose.yml
- 一键部署测试环境

### 2. 环境一致性
- 开发、测试、生产环境统一
- 避免 "在我机器上能跑" 问题
- AI 生成代码可直接容器化运行

### 3. 多项目管理
- 每个项目独立容器栈
- 资源隔离，避免冲突
- 快速切换和清理

### 示例 Vibe Prompt:
```
"创建一个包含 Node.js 后端和 React 前端的全栈应用，
生成 Dockerfile 和 docker-compose.yml 配置文件，
确保开发环境可以通过 docker compose up 一键启动"
```

---

## 关键要点总结

✅ **容器**: 隔离、轻量、可移植的应用运行环境
✅ **镜像**: 不可变、分层的应用打包格式
✅ **Compose**: 声明式多容器应用编排工具
✅ **最佳实践**: 单一职责、分层构建、数据持久化
✅ **与 Vibe Coding**: 环境标准化、快速原型、多项目隔离

---

## 下一步学习

- [ ] Dockerfile 编写最佳实践
- [ ] 多阶段构建优化镜像大小
- [ ] Docker 网络深度理解
- [ ] Kubernetes 基础 (容器编排)
- [ ] CI/CD 集成 Docker

---

*学习时间: 2026-02-17 16:30*
*参考资源: Docker 官方文档 (docs.docker.com)*
