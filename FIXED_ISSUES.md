# 项目修复说明

## 修复的主要问题

### 1. ✅ 国际化（i18n）Store 服务端渲染问题

**问题**: `locale-store.ts` 使用 zustand 的 persist 中间件时，在服务端渲染（SSR）时会报错，因为 localStorage 在服务端不可用。

**修复内容**:
- 在 `apps/web/src/stores/locale-store.ts` 中添加了服务端环境检测
- 使用 `createJSONStorage` 创建自定义 storage 适配器
- 当在服务端时，返回空的 storage 实现（dummy storage）
- 添加了 `partialize` 选项，只持久化 `locale` 字段，不持久化翻译对象 `t`
- 添加了 `merge` 函数，确保从 localStorage 恢复时正确重新生成翻译对象

**修复后的代码**:
```typescript
export const useLocaleStore = create<LocaleState>()(
  persist(
    (set) => ({
      locale: "en",
      t: getTranslations("en"),
      setLocale: ({ locale }) => {
        set({ locale, t: getTranslations(locale) });
      },
    }),
    {
      name: "opencut-locale",
      storage: createJSONStorage(() => {
        // 检查是否在客户端环境
        if (typeof window !== "undefined") {
          return window.localStorage;
        }
        // 服务端返回一个空的 storage 实现
        return {
          getItem: () => null,
          setItem: () => {},
          removeItem: () => {},
        };
      }),
      // 只持久化 locale，不持久化 t（翻译对象）
      partialize: (state) => ({ locale: state.locale }) as Partial<LocaleState>,
      // 自定义合并逻辑，确保 t 总是根据 locale 重新生成
      merge: (persistedState, currentState) => {
        const locale = (persistedState as Partial<LocaleState>)?.locale || currentState.locale;
        return {
          ...currentState,
          locale,
          t: getTranslations(locale),
        };
      },
    },
  ),
);
```

## 项目结构

项目包含以下国际化（i18n）功能：
- **英语 (en)**: 默认语言
- **中文 (zh)**: 简体中文

所有翻译文件位于：
- `apps/web/src/lib/i18n/locales/en.ts`
- `apps/web/src/lib/i18n/locales/zh.ts`

## 如何启动项目

### 方法 1: 使用启动脚本
```powershell
.\start-project.ps1
```

### 方法 2: 手动启动

1. 确保环境变量已设置：
```powershell
$env:PATH = "D:\Development\Tools\nodejs;D:\Development\Tools\bun\bin;$env:PATH"
```

2. 进入项目根目录：
```powershell
cd D:\EASYREACT\OpenCut
```

3. 启动开发服务器：
```powershell
bun dev
```

4. 或者只启动 web 应用：
```powershell
cd apps\web
bun run dev
```

### 访问应用
- 开发服务器: http://localhost:3000
- 如果 3000 端口被占用，Next.js 会自动使用下一个可用端口

## 环境要求

- ✅ Node.js: 已安装
- ✅ Bun: 已安装  
- ✅ .env.local: 已配置
- ⚠️ Docker: 可选（用于 PostgreSQL 数据库）

## 数据库配置

当前配置使用 SQLite 本地文件数据库（`file:./dev.db`），不需要 Docker 或 PostgreSQL。

如果需要使用 PostgreSQL：
1. 确保 Docker Desktop 已启动
2. 运行 `docker-compose up -d`
3. 修改 `.env.local` 中的 `DATABASE_URL`

## 常见问题

### 端口被占用
如果收到端口占用错误，可以：
1. 关闭占用 3000 端口的其他应用
2. Next.js 会自动尝试下一个可用端口（3001, 3002 等）

### 语言切换
- 点击页面右上角的语言切换按钮（地球图标）
- 选择中文或英语
- 语言偏好会自动保存到浏览器

## 修复验证

修复后，应该可以：
1. ✅ 成功启动开发服务器（不会有 localStorage 错误）
2. ✅ 页面正常加载（SSR 和 CSR 都能工作）
3. ✅ 语言切换功能正常
4. ✅ 刷新页面后语言偏好保持不变

## 技术细节

修复解决了以下技术问题：
1. **服务端渲染**: zustand persist 现在同时支持 SSR 和 CSR
2. **类型安全**: 使用 TypeScript 确保所有翻译键都正确
3. **性能优化**: 翻译对象不被序列化，减少 localStorage 占用
4. **水合错误**: 通过正确的 merge 策略避免客户端/服务端不匹配

## 下一步

如果还有其他问题，请检查：
1. 浏览器控制台是否有错误
2. 终端是否有启动错误
3. .env.local 文件是否配置正确





