# 无 Docker 运行指南

## 方案 1：使用 SQLite 数据库（推荐）

### 1. 创建环境变量文件

```bash
# 复制示例文件
cp apps/web/.env.example apps/web/.env.local
```

### 2. 修改数据库配置

编辑 `apps/web/.env.local`，将数据库 URL 改为 SQLite：

```bash
# 使用 SQLite 替代 PostgreSQL
DATABASE_URL="file:./dev.db"

# 其他配置保持不变
NEXT_PUBLIC_BETTER_AUTH_URL=http://localhost:3000
BETTER_AUTH_SECRET=your-secret-key-here
NODE_ENV=development

# Redis 使用模拟服务（可选）
UPSTASH_REDIS_REST_URL=http://localhost:8079
UPSTASH_REDIS_REST_TOKEN=example_token
```

### 3. 安装依赖并启动

```bash
# 设置环境变量
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"

# 安装依赖
bun install

# 运行数据库迁移
cd apps/web
bun run db:migrate

# 启动开发服务器
bun run dev
```

## 方案 2：使用在线数据库服务

### 使用 Supabase（免费 PostgreSQL）

1. 访问 https://supabase.com
2. 创建新项目
3. 获取数据库连接字符串
4. 更新 `DATABASE_URL` 为 Supabase 连接字符串

### 使用 PlanetScale（免费 MySQL）

1. 访问 https://planetscale.com
2. 创建数据库
3. 获取连接字符串
4. 更新 `DATABASE_URL`

## 方案 3：禁用数据库功能

如果只是测试前端功能，可以：

1. 注释掉数据库相关代码
2. 使用模拟数据
3. 跳过数据库迁移

## 推荐方案

**建议使用方案 1（SQLite）**，因为：
- 无需安装额外服务
- 文件数据库，简单易用
- 项目已支持 SQLite
- 开发测试完全够用

要开始吗？我可以帮您配置 SQLite 方案。



