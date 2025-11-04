# 项目启动指南

## 快速启动步骤

### 1. 打开 PowerShell 终端
在项目根目录 `D:\EASYREACT\OpenCut` 打开 PowerShell

### 2. 设置环境变量（每次启动都需要）
```powershell
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"
```

### 3. 进入 web 应用目录
```powershell
cd apps\web
```

### 4. 创建环境变量文件（如果还没有）
```powershell
# 复制示例文件
Copy-Item .env.example .env.local
```

### 5. 编辑 .env.local 文件
使用记事本或其他编辑器打开 `apps/web/.env.local`，确保包含以下内容：

```bash
DATABASE_URL="file:./dev.db"
NEXT_PUBLIC_BETTER_AUTH_URL=http://localhost:3000
BETTER_AUTH_SECRET=Pmzag1sKjxpVwTOkb3A8tDhvZYeCQrRS
NODE_ENV=development
UPSTASH_REDIS_REST_URL=http://localhost:8079
UPSTASH_REDIS_REST_TOKEN=example_token
```

### 6. 安装依赖（如果还没安装）
```powershell
cd D:\EASYREACT\OpenCut
bun install
```

### 7. 启动开发服务器
```powershell
cd apps\web
bun run dev
```

### 8. 访问应用
打开浏览器访问：**http://localhost:3000**

## 一键启动脚本

如果需要，可以创建一个启动脚本 `start.ps1`：

```powershell
# 设置环境变量
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"

# 进入项目目录
cd D:\EASYREACT\OpenCut\apps\web

# 启动服务器
Write-Host "正在启动开发服务器..." -ForegroundColor Green
Write-Host "应用将在 http://localhost:3000 运行" -ForegroundColor Cyan
bun run dev
```

保存为 `start.ps1` 后，双击运行即可。

## 常见问题

### 端口被占用
如果 3000 端口被占用，Next.js 会自动使用下一个可用端口（如 3001）

### 数据库错误
使用 SQLite 不需要 Docker，但如果遇到数据库错误，检查 `.env.local` 中的 `DATABASE_URL` 是否为 `file:./dev.db`

### 依赖安装失败
尝试：
```powershell
bun install --force
```



