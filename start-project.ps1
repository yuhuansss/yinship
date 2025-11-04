# OpenCut 项目启动脚本
# 此脚本将帮助您启动项目

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenCut 项目启动脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 设置 PATH
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"

# 检查工具
Write-Host "检查必要的工具..." -ForegroundColor Green
Write-Host ""

# 检查 Node.js
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($nodeCmd) {
    $nodeVer = node --version
    Write-Host "✓ Node.js: $nodeVer" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js: 未找到" -ForegroundColor Red
    exit 1
}

# 检查 Bun
$bunCmd = Get-Command bun -ErrorAction SilentlyContinue
if ($bunCmd) {
    $bunVer = bun --version
    Write-Host "✓ Bun: $bunVer" -ForegroundColor Green
} else {
    Write-Host "✗ Bun: 未找到" -ForegroundColor Red
    exit 1
}

# 检查 Docker
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerCmd) {
    $dockerVer = docker --version
    Write-Host "✓ Docker: $dockerVer" -ForegroundColor Green
} else {
    Write-Host "⚠ Docker: 未找到（数据库功能将不可用）" -ForegroundColor Yellow
    Write-Host "  数据库连接可能会失败，但前端部分可能可以运行" -ForegroundColor Yellow
}

Write-Host ""

# 检查环境变量文件
Write-Host "检查环境变量文件..." -ForegroundColor Green
if (Test-Path "apps\web\.env.local") {
    Write-Host "✓ 环境变量文件存在" -ForegroundColor Green
} else {
    Write-Host "⚠ 环境变量文件不存在，正在创建..." -ForegroundColor Yellow
    Copy-Item "apps\web\.env.example" -Destination "apps\web\.env.local"
    Write-Host "✓ 已创建环境变量文件" -ForegroundColor Green
}
Write-Host ""

# 启动 Docker 服务
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "步骤 1: 启动 Docker 服务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($dockerCmd) {
    Write-Host "检查 Docker 容器状态..." -ForegroundColor Green
    $containers = docker ps -a 2>&1
    
    if ($containers -like "*opencut*" -or $containers -like "*CONTAINER*") {
        Write-Host "启动 Docker 容器..." -ForegroundColor Green
        docker-compose up -d
        Write-Host "等待服务启动..." -ForegroundColor Green
        Start-Sleep -Seconds 5
        Write-Host "✓ Docker 服务已启动" -ForegroundColor Green
    } else {
        Write-Host "启动 Docker Compose 服务..." -ForegroundColor Green
        docker-compose up -d
        Start-Sleep -Seconds 5
        Write-Host "✓ Docker 服务已启动" -ForegroundColor Green
    }
} else {
    Write-Host "⚠ Docker 未安装，跳过数据库服务启动" -ForegroundColor Yellow
    Write-Host "  注意：应用可能需要数据库连接才能正常运行" -ForegroundColor Yellow
}
Write-Host ""

# 运行数据库迁移
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "步骤 2: 运行数据库迁移" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($dockerCmd) {
    Write-Host "运行数据库迁移..." -ForegroundColor Green
    Set-Location apps\web
    bun run db:migrate
    Set-Location ..\..
    Write-Host "✓ 数据库迁移完成" -ForegroundColor Green
} else {
    Write-Host "⚠ 跳过数据库迁移（Docker 未安装）" -ForegroundColor Yellow
}
Write-Host ""

# 启动开发服务器
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "步骤 3: 启动开发服务器" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "启动开发服务器..." -ForegroundColor Green
Write-Host "应用将在 http://localhost:3000 运行" -ForegroundColor Cyan
Write-Host ""
Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Yellow
Write-Host ""

Set-Location apps\web
bun run dev




