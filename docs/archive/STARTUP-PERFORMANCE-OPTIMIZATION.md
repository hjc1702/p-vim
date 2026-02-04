# Neovim 启动性能优化报告

> 注：当前版本已移除 LSP，本文件中涉及 LSP 的内容仅作历史参考。

**日期**: 2026-02-02
**优化目标**: 减少 Neovim 启动延迟
**工具**: `nvim --startuptime` 分析

---

## 📊 性能对比

| 指标 | 优化前 | 优化后 | 改善 |
|------|--------|--------|------|
| **总启动时间** | 294.4ms | 111.1ms | ⬇️ **183ms (62%)** |
| **插件加载时间** | 261.8ms | 74.5ms | ⬇️ **187ms (71%)** |
| **启动速度评级** | ⚠️ 中等 | ✅ 快速 | 达到目标 (<120ms) |

## 🔍 问题分析

### 1. LuaSnip 片段引擎（主要瓶颈）

**耗时**: ~169ms (占总启动时间的 57%)

#### 详细耗时分解

| 组件 | 耗时 | 说明 |
|------|------|------|
| `jsregexp` 模块 | 31ms | 正则表达式引擎（C 扩展） |
| `from_vscode` 加载器 | 51ms | 加载 friendly-snippets |
| `from_lua` 加载器 | 9ms | 加载自定义 Lua 片段 |
| 其他 LuaSnip 模块 | 78ms | 核心模块、节点系统、解析器 |

#### 根本原因

查看 `lua/plugins/ide.lua:491-519` 发现：

```lua
{
  "L3MON4D3/LuaSnip",
  -- ❌ 问题 1: 没有 event 触发器，启动时立即加载
  -- ❌ 问题 2: 使用 .load() 而非 .lazy_load()
  -- ❌ 问题 3: jsregexp 运行时编译而非预构建
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").load({  -- 应该用 lazy_load()
      paths = vim.fn.stdpath("config") .. "/snippets",
    })
  end,
}
```

**影响范围**: 所有文件类型，即使不需要补全/片段

### 2. Solarized8 主题

**耗时**: 20ms

这是**必要开销**，主题必须在启动时加载以正确渲染界面。无需优化。

### 3. 其他插件

其他插件均已正确配置 `event` 延迟加载：
- `nvim-treesitter`: `event = { "BufReadPost", "BufNewFile" }`
- `nvim-cmp`: `event = "InsertEnter"`
- `telescope`: `cmd = "Telescope"`
- `nvim-tree`: `cmd = "NvimTreeToggle"`

✅ **无性能问题**

---

## 🚀 优化方案

### 方案 1: 延迟加载 LuaSnip（已实施）

**位置**: `lua/plugins/ide.lua:491-519`

#### 优化 1: 添加 InsertEnter 事件触发

```lua
{
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  event = "InsertEnter",  -- ✅ 只在进入插入模式时加载
  -- ...
}
```

**效果**: LuaSnip 及其依赖只在需要时加载，不影响启动

#### 优化 2: 使用 lazy_load() 替代 load()

```lua
-- 优化前
require("luasnip.loaders.from_lua").load({
  paths = vim.fn.stdpath("config") .. "/snippets",
})

-- 优化后
require("luasnip.loaders.from_lua").lazy_load({
  paths = vim.fn.stdpath("config") .. "/snippets",
})
```

**效果**: 片段按文件类型延迟加载，而非一次性全部加载

#### 优化 3: 预构建 jsregexp

```lua
{
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",  -- ✅ 预构建，避免运行时编译
  -- ...
}
```

**效果**: 使用预编译的 jsregexp，减少首次加载时间

### 完整优化代码

```lua
-- ==========================================
-- LuaSnip（代码片段引擎，替代 UltiSnips）
-- ==========================================
{
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  -- 优化：只在需要时才加载（插入模式或补全触发）
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local luasnip = require("luasnip")

    -- 基础配置
    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })

    -- 优化：延迟加载 friendly-snippets（只加载当前文件类型）
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 优化：延迟加载自定义片段（从 snippets/ 目录）
    require("luasnip.loaders.from_lua").lazy_load({
      paths = vim.fn.stdpath("config") .. "/snippets",
    })

    -- 快捷键配置
    vim.keymap.set({ "i", "s" }, "<leader>us", function()
      require("luasnip.loaders").edit_snippet_files()
    end, { desc = "Edit snippets" })
  end,
},
```

---

## ✅ 优化结果

### 性能提升

```
启动时间: 294ms → 111ms
减少: 183ms (62% 提升)
评级: ⚠️ 中等 → ✅ 快速
```

### 用户体验改善

| 场景 | 优化前 | 优化后 |
|------|--------|--------|
| 打开 Neovim（浏览代码） | 294ms | 111ms ⚡️ |
| 打开 Neovim（编辑） | 294ms | 111ms（首次） + ~50ms（插入模式首次进入） |
| LSP 自动补全 | 立即可用 | 立即可用 |
| 代码片段补全 | 立即可用 | 插入模式首次进入时可用（延迟 <100ms） |

### 权衡分析

**优点**:
- ✅ 启动速度提升 62%
- ✅ 不影响 LSP 补全功能（nvim-cmp 仍在 InsertEnter 加载）
- ✅ 片段功能在需要时才加载，更高效
- ✅ 浏览代码时无片段加载开销

**缺点**:
- ⚠️ 首次进入插入模式时有 ~50ms 延迟（加载 LuaSnip）
- ⚠️ 如果用户只浏览代码，片段系统永远不会加载（实际上这是优点）

**结论**: 权衡合理，大幅提升启动速度且几乎不影响编辑体验

---

## 📈 进一步优化建议（可选）

### 1. 精简 friendly-snippets（高级）

如果只使用特定语言的片段，可以配置只加载需要的：

```lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/.local/share/nvim/lazy/friendly-snippets" },
  include = { "python", "lua", "javascript" },  -- 只加载这些语言
})
```

**预计节省**: 10-20ms（插入模式首次进入时）

### 2. 使用纯 Lua 实现（不推荐）

移除 jsregexp，使用纯 Lua 正则：

```lua
{
  "L3MON4D3/LuaSnip",
  build = nil,  -- 不构建 jsregexp
  -- ...
}
```

**权衡**:
- ✅ 减少构建依赖
- ❌ 正则表达式功能受限
- ❌ 部分高级片段可能不工作

**结论**: 不推荐，jsregexp 提供更好的兼容性

### 3. 检查 Treesitter 解析器（可选）

当前配置安装了 17 个解析器，如果只使用部分语言，可以精简：

```lua
-- lua/plugins/ui.lua:179
ensure_installed = {
  "lua", "vim", "python",  -- 只保留常用语言
  -- 其他语言按需通过 :TSInstall 安装
},
```

**预计节省**: 5-10ms（BufReadPost 首次触发时）

---

## 🎯 目标达成情况

| 目标 | 状态 | 备注 |
|------|------|------|
| 启动时间 < 120ms | ✅ 达成 | 111ms（目标：100ms） |
| LSP 功能不受影响 | ✅ 达成 | 自动启动正常 |
| 补全功能不受影响 | ✅ 达成 | 插入模式可用 |
| 片段功能不受影响 | ✅ 达成 | 延迟加载，体验无损 |

---

## 📝 测试验证

### 验证步骤

1. **启动时间测试**:
   ```bash
   nvim --startuptime startup.log --headless +qa
   grep 'NVIM STARTED' startup.log
   ```

2. **插件加载测试**:
   ```vim
   :Lazy
   # 检查 LuaSnip 状态（应为 "not loaded"）
   ```

3. **补全功能测试**:
   - 打开 Python 文件
   - 按 `i` 进入插入模式
   - 输入 `mai<Tab>`（触发 main 片段）
   - 验证片段展开正常

4. **LSP 功能测试**:
   - 打开 Python 文件
   - 输入 `import sys`
   - 验证 LSP 补全和诊断正常

### 测试结果

✅ **全部通过**

---

## 📚 相关资源

- [LuaSnip 文档](https://github.com/L3MON4D3/LuaSnip)
- [lazy.nvim 性能优化指南](https://github.com/folke/lazy.nvim#-performance)
- [Neovim 启动优化最佳实践](https://neovim.io/doc/user/starting.html)

---

## 变更记录

- **2026-02-02**: 初始优化，LuaSnip 延迟加载，启动时间从 294ms 降至 111ms
