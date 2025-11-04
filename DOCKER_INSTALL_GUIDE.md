# Docker 安装和配置指南

## 安装 Docker Desktop

1. **下载地址**: https://www.docker.com/products/docker-desktop/
2. **安装步骤**:
   - 下载 Docker Desktop Installer.exe
   - 运行安装程序
   - 安装完成后重启电脑

3. **配置 Docker 数据目录（可选，避免占用 C 盘）**:
   - 打开 Docker Desktop
   - 进入 Settings > Resources > Advanced
   - 修改 "Disk image location" 到 `D:\Development\Tools\docker\data`

## 验证安装

安装完成后，打开新的 PowerShell 窗口，运行：

```powershell
docker --version
docker-compose --version
```

如果显示版本号，说明安装成功。

## 启动项目服务

安装 Docker 后，运行以下命令启动数据库和 Redis：

```powershell
cd D:\EASYREACT\OpenCut
docker-compose up -d
```

## 等待服务启动

启动后，等待约 30 秒让数据库和 Redis 完全启动，然后运行数据库迁移：

```powershell
cd apps\web
bun run db:migrate
```

## 然后启动开发服务器

```powershell
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"
bun run dev
```

应用将在 http://localhost:3000 运行！



