# 快速修复指南 - 解决页面加载问题

## 问题原因

浏览器一直加载是因为 zustand 的 SSR hydration 导致的。

## 🚀 立即执行以下命令

### 方案 1：临时禁用持久化（最快）

在 PowerShell 中执行：

```powershell
# 1. 停止当前进程（按 Ctrl+C）

# 2. 清除浏览器的 localStorage
# 在浏览器控制台（F12）中执行：
localStorage.clear()

# 3. 强制刷新浏览器
# 按 Ctrl + Shift + R
```

### 方案 2：完全重启（推荐）

```powershell
# 1. 停止所有 Node 进程
Get-Process -Name "node","bun" -ErrorAction SilentlyContinue | Stop-Process -Force

# 2. 进入项目目录
cd D:\EASYREACT\OpenCut\apps\web

# 3. 删除构建缓存
Remove-Item -Path ".next" -Recurse -Force -ErrorAction SilentlyContinue

# 4. 清除 node_modules/.cache（如果存在）
Remove-Item -Path "node_modules/.cache" -Recurse -Force -ErrorAction SilentlyContinue

# 5. 重新启动
bun run dev
```

### 方案 3：使用新的安全 Hook

我已经创建了一个新的 `useLocale` hook 来替代直接使用 `useLocaleStore`。

但首先，让我们先让项目跑起来。

## 🔧 浏览器操作

1. **打开浏览器**
2. **按 F12** 打开开发者工具
3. **切换到 Console 选项卡**
4. **输入并执行**：
   ```javascript
   localStorage.clear()
   ```
5. **关闭开发者工具**
6. **强制刷新页面**：按 `Ctrl + Shift + R`

## 🎯 如果还是不行

### 使用无痕模式测试

1. 按 **Ctrl + Shift + N**（Chrome）或 **Ctrl + Shift + P**（Firefox）
2. 访问 http://localhost:3000
3. 如果无痕模式能正常打开，说明是浏览器缓存/localStorage 的问题

### 检查端口

```powershell
# 查看是否有多个进程占用端口
netstat -ano | findstr :3000
```

如果看到多个进程，全部停止：

```powershell
# 根据 PID 停止（替换 12345 为实际的 PID）
Stop-Process -Id 12345 -Force
```

## 📝 下一步

项目启动后，我会帮你：
1. 更新所有组件使用新的安全 Hook
2. 确保不会再出现 hydration 问题
3. 测试语言切换功能

## 💡 临时解决方案

如果你想立即看到效果，可以暂时禁用国际化：

1. 在项目根目录创建 `.env.local.backup`
2. 重命名所有使用国际化的组件回到原始版本

但我不推荐这样做，让我们正确修复它！

---

**请先尝试方案 1 和方案 2，然后告诉我结果！** 🚀





