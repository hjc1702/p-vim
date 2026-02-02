# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个现代化的 Neovim 编辑器配置项目，使用 Lua 配置语言和 lazy.nvim 插件管理器。项目已完全重构为纯 Neovim 配置，采用原生 LSP、Treesitter 等现代特性，提供完整的 IDE 体验。

**配置方式**：所有配置文件存储在此仓库中，通过软连接到 `~/.config/nvim` 生效，便于版本控制和跨设备同步。

**重要更新（2026-02-02）**：
- ✅ 已从 Vim + Vim-plug 完全迁移到 Neovim + lazy.nvim
- ✅ 移除了 YouCompleteMe、vim-go 等旧插件
- ✅ 使用 nvim-lspconfig + Mason 提供 LSP 支持
- ✅ LSP 自动启动机制已修复，包括新文件支持
- ✅ LSP 性能优化完成，消除 "Loading workspace" 延迟
- ✅ 项目文档已整理到 docs/ 目录

## 核心架构

### 配置文件结构（Neovim + Lua）

```
p-vim/
├── init.lua                          # 主入口文件
├── lua/
│   ├── config/
│   │   ├── options.lua              # 编辑器基础设置（含 Mason PATH）
│   │   ├── keymaps.lua              # 快捷键映射（45+ 个）
│   │   ├── functions.lua            # 自定义函数（5 个）
│   │   ├── autocmds.lua             # 自动命令
│   │   └── lsp-debug.lua            # LSP 调试工具
│   └── plugins/
│       ├── init.lua                 # lazy.nvim 引导配置
│       ├── ui.lua                   # 界面插件（solarized8、lualine、treesitter）
│       ├── navigation.lua           # 导航插件（nvim-tree、telescope、aerial、flash）
│       ├── editing.lua              # 编辑增强（autopairs、surround、comment）
│       ├── ide.lua                  # LSP、补全、linting、formatting
│       └── integration.lua          # 集成插件（orgmode）
├── snippets/                         # LuaSnip 代码片段
│   ├── python.lua                   # 40+ Python 片段
│   ├── c.lua                        # 20+ C 片段
│   └── all.lua                      # 通用片段
├── after/                            # 文件类型插件
│   └── ftplugin/
│       ├── python.lua               # Python LSP 自动启动
│       └── lua.lua                  # Lua LSP 自动启动
├── docs/                             # 项目文档
│   ├── README.md                    # 文档索引
│   ├── MIGRATION-SUMMARY.md         # 迁移总结
│   ├── REFACTORING-COMPLETE.md      # 重构报告
│   ├── CLEANUP-REPORT.md            # 清理报告
│   ├── LSP-FIX-REPORT.md            # LSP 修复报告
│   └── LSP-PERFORMANCE-OPTIMIZATION.md  # LSP 性能优化报告
├── install-neovim.sh                # 自动安装脚本
├── lazy-lock.json                   # 插件版本锁定
├── README.md                        # 项目主页
└── CLAUDE.md                        # 本文档

注：旧的 Vim 配置（vimrc、vimrc.bundles、UltiSnips/）已清理
```

### 架构理念

1. **模块化设计**: 使用 Lua 模块系统，配置按功能分类到不同文件
2. **懒加载优化**: 使用 lazy.nvim，插件按需加载，启动速度快（< 100ms）
3. **原生特性**: 充分利用 Neovim 0.11+ 的原生 LSP、Treesitter、vim.lsp.config API
4. **双重保障**: LSP 自动启动使用多事件监听 + ftplugin 确保可靠性
5. **Git 版本控制**: 配置文件在仓库中，通过软连接生效

## 技术栈

- **Neovim**: 0.11.6+
- **配置语言**: Lua
- **插件管理**: lazy.nvim
- **LSP**: nvim-lspconfig + Mason
- **补全引擎**: nvim-cmp
- **片段引擎**: LuaSnip
- **语法高亮**: nvim-treesitter
- **搜索**: Telescope + ripgrep
- **Linting**: nvim-lint
- **Formatting**: conform.nvim

## 常用命令

### Neovim 内置命令

```vim
:Lazy                     # 插件管理
:Mason                    # LSP 服务器管理
:LspInfo                  # 查看 LSP 状态
:LspDebug                 # LSP 调试信息（自定义命令）
:checkhealth              # 健康检查
:Telescope                # 模糊搜索
:NvimTreeToggle           # 文件树
:AerialToggle             # 代码大纲
```

### 安装和更新

```bash
# 安装配置
./install-neovim.sh

# 更新插件
nvim
:Lazy sync

# 更新 LSP 服务器
:Mason
```

## 快捷键系统

### Leader 键
- Leader: `,` (逗号)
- LocalLeader: `,` (逗号)

### 核心快捷键（45+ 个）

#### 基础操作
| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `kj` | Insert | 退出插入模式 | 替代 Esc |
| `;` | Normal | 命令行模式 | 替代 `:` |
| `<Space>` | Normal | 搜索 | 替代 `/` |
| `,/` | Normal | 清除搜索高亮 | :nohlsearch |

#### 窗口管理
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-h/j/k/l>` | 窗口导航 | 支持 tmux |
| `<C-w>` | 窗口命令前缀 | 标准 Vim |
| `,z` | 窗口缩放切换 | 最大化/恢复 |

#### 文件和导航
| 快捷键 | 功能 | 插件 | 说明 |
|--------|------|------|------|
| `,n` | 文件树切换 | nvim-tree | NERDTree 替代 |
| `,p` | 文件搜索 | Telescope | CtrlP 替代 |
| `,f` | 最近文件 | Telescope | 历史文件 |
| `\` | 全局搜索 | Telescope | CtrlSF 替代 |
| `,fu` | 文档符号搜索 | Telescope | 函数/类列表 |
| `F9` | 代码大纲 | Aerial | Tagbar 替代 |

#### LSP 功能
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,jd` | 跳转到定义 | Jump to Definition |
| `,gd` | 跳转到声明 | Go to Declaration |
| `K` | 显示文档 | Hover Documentation |
| `gi` | 查看实现 | Go to Implementation |
| `gr` | 查看引用 | References |
| `,rn` | 重命名符号 | Rename |
| `,ca` | 代码操作 | Code Action |
| `,fm` | 格式化 | Format |
| `,ld` | LSP 调试信息 | 自定义命令 |

#### 编辑增强
| 快捷键 | 功能 | 插件 | 说明 |
|--------|------|------|------|
| `gcc` | 注释行 | Comment.nvim | 切换注释 |
| `gc` + motion | 注释选区 | Comment.nvim | 可视模式 |
| `cs"'` | 修改包围符号 | nvim-surround | "替换为' |
| `ds"` | 删除包围符号 | nvim-surround | 删除引号 |
| `ys{motion}"` | 添加包围符号 | nvim-surround | 添加引号 |
| `,<space>` | 清理尾部空格 | mini.trailspace | 自动清理 |
| `,a` | 格式化文件 | conform.nvim | Python/Lua/JS |
| `,y` | 格式化选区 | conform.nvim | Visual 模式 |

#### 代码片段
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<Tab>` | 展开/跳转 | LuaSnip 片段 |
| `<S-Tab>` | 反向跳转 | 片段占位符 |

#### 补全
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-j>` | 下一个补全项 | nvim-cmp |
| `<C-k>` | 上一个补全项 | nvim-cmp |
| `<C-Space>` | 触发补全 | 手动触发 |
| `<CR>` | 确认补全 | 回车确认 |
| `<C-e>` | 取消补全 | 关闭菜单 |

#### 自定义函数
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,zz` | 折叠切换 | toggle_fold |
| `<C-n>` | 行号切换 | 相对/绝对 |

## 插件系统

### 插件管理器
- **lazy.nvim**: 现代化插件管理，支持懒加载、版本锁定

### 已安装插件（25 个）

#### 界面增强
- **vim-solarized8**: Solarized 主题
- **lualine.nvim**: 状态栏（替代 vim-airline）
- **nvim-treesitter**: 语法解析和高亮
- **nvim-ts-rainbow2**: 彩虹括号
- **nvim-web-devicons**: 图标支持

#### 导航和搜索
- **nvim-tree.lua**: 文件树（替代 NERDTree）
- **telescope.nvim**: 模糊搜索（替代 CtrlP/CtrlSF）
- **telescope-fzf-native.nvim**: Telescope FZF 扩展
- **aerial.nvim**: 代码大纲（替代 Tagbar）
- **flash.nvim**: 快速跳转（替代 EasyMotion）

#### 编辑增强
- **nvim-autopairs**: 自动括号（替代 delimitMate）
- **nvim-surround**: 包围符号（替代 vim-surround）
- **Comment.nvim**: 注释（替代 nerdcommenter）
- **mini.trailspace**: 尾部空格处理

#### LSP 和补全
- **nvim-lspconfig**: LSP 配置
- **mason.nvim**: LSP 服务器管理
- **mason-lspconfig.nvim**: Mason 和 lspconfig 桥接
- **nvim-cmp**: 补全引擎（替代 YouCompleteMe）
- **cmp-nvim-lsp**: LSP 补全源
- **cmp-buffer**: Buffer 补全源
- **cmp-path**: 路径补全源
- **cmp-cmdline**: 命令行补全源
- **LuaSnip**: 代码片段引擎（替代 UltiSnips）
- **cmp_luasnip**: LuaSnip 补全源
- **lspkind.nvim**: 补全图标
- **friendly-snippets**: 预定义片段集合

#### 代码质量
- **nvim-lint**: Linting（替代 ALE linting）
- **conform.nvim**: 代码格式化

#### 集成
- **vim-tmux-navigator**: Tmux 集成
- **orgmode**: Org-mode 支持（Lua 版本）

### LSP 服务器（通过 Mason 管理）
- **pyright**: Python
- **lua_ls**: Lua
- **gopls**: Go（已安装但未配置）
- **rust_analyzer**: Rust（已安装但未配置）
- **taplo**: TOML
- **vue_ls**: Vue

## 自定义功能

### 自定义函数（5 个）

1. **toggle_fold()** - 折叠切换
   - 快捷键: `,zz`
   - 功能: 切换当前行的折叠状态

2. **number_toggle()** - 行号切换
   - 快捷键: `<C-n>`
   - 功能: 在相对行号和绝对行号之间切换

3. **zoom_toggle()** - 窗口缩放
   - 快捷键: `,z`
   - 功能: 最大化/恢复当前窗口

4. **strip_trailing_whitespaces()** - 清理尾部空格
   - 快捷键: `,<space>`
   - 功能: 删除文件中的尾部空格

5. **auto_set_file_head()** - 自动文件头
   - 触发: 新建 .sh/.py 文件时
   - 功能: 自动插入文件头（shebang、编码等）

### 自动命令

1. **行号自动切换**
   - 插入模式: 绝对行号
   - 普通模式: 相对行号

2. **保存时清理空格**
   - 文件类型: Python, JavaScript, C, C++, Java 等
   - 自动删除尾部空格

3. **文件头自动插入**
   - 新建 .sh 文件: 添加 `#!/bin/bash`
   - 新建 .py 文件: 添加 `# -*- coding: utf-8 -*-`

4. **跳转到上次位置**
   - 重新打开文件时跳转到上次编辑位置

5. **文件类型特定配置**
   - Python: 4 空格缩进
   - Markdown: 2 空格缩进
   - Ruby: 2 空格缩进

## LSP 配置

### 自动启动机制

LSP 使用**双重保障**确保可靠启动：

1. **多事件监听**（lua/plugins/ide.lua）
   - FileType 事件
   - BufEnter 事件
   - BufWritePost 事件

2. **文件类型插件**（after/ftplugin/）
   - `python.lua`: 自动启动 pyright
   - `lua.lua`: 自动启动 lua_ls

### PATH 配置

Mason bin 目录已添加到 PATH（lua/config/options.lua）：
```lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

### 调试工具

```vim
:LspDebug        # 或 ,ld - 显示 LSP 调试信息
:LspInfo         # 查看 LSP 状态
:Mason           # 管理 LSP 服务器
:LspStart SERVER # 手动启动 LSP
:LspRestart      # 重启 LSP
```

## 代码片段

### Python 片段（40+）
- `main` - if __name__ == '__main__'
- `code` - # coding: utf-8
- `im`/`from` - import 语句
- `def`/`class` - 函数/类定义
- `for`/`if`/`try` - 控制结构

### C 片段（20+）
- `main` - main 函数
- `inc` - #include
- `if`/`for`/`while` - 控制结构

### 通用片段
- 日期时间
- TODO/FIXME 注释

## 文件和目录

### 重要文件
- `init.lua`: 主入口，加载所有配置模块
- `lazy-lock.json`: 插件版本锁定，确保环境一致性
- `install-neovim.sh`: 自动化安装脚本

### 配置目录
- `lua/config/`: 基础配置（options、keymaps、functions、autocmds、lsp-debug）
- `lua/plugins/`: 插件配置（ui、navigation、editing、ide、integration）
- `snippets/`: 代码片段定义
- `after/ftplugin/`: 文件类型专用配置

### 文档目录
- `docs/`: 项目技术文档
  - `MIGRATION-SUMMARY.md`: 迁移总结
  - `REFACTORING-COMPLETE.md`: 重构报告
  - `CLEANUP-REPORT.md`: 清理报告
  - `LSP-FIX-REPORT.md`: LSP 问题解决

## 工作流程

### 日常使用
1. 启动 Neovim: `nvim`
2. 打开文件: `,p` (搜索) 或 `,n` (文件树)
3. 编辑代码:
   - LSP 自动补全和诊断
   - `gcc` 注释
   - `,jd` 跳转定义
   - `K` 查看文档
4. 保存: `:w` (自动格式化和 lint)
5. 搜索: `\` 全局搜索

### 插件管理
```vim
:Lazy               # 打开插件管理界面
:Lazy sync          # 同步插件（安装、更新、清理）
:Lazy update        # 更新所有插件
:Lazy clean         # 清理未使用的插件
```

### LSP 管理
```vim
:Mason              # 打开 LSP 服务器管理界面
:MasonInstall NAME  # 安装 LSP 服务器
:MasonUpdate        # 更新所有服务器
:LspInfo            # 查看当前 buffer 的 LSP 状态
```

## 性能

- **启动时间**: < 100ms
- **插件数量**: 25 个（全部懒加载）
- **内存使用**: ~50MB（空闲时）
- **配置文件**: 14 个 Lua 文件，~2000+ 行代码

## 故障排除

### LSP 不工作
1. 检查 LSP 状态: `:LspInfo`
2. 运行诊断: `:LspDebug` 或 `,ld`
3. 检查服务器安装: `:Mason`
4. 手动启动: `:LspStart pyright`
5. 查看日志: `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`

### 插件问题
1. 同步插件: `:Lazy sync`
2. 清理缓存: `:Lazy clean`
3. 查看日志: `:Lazy log`
4. 检查健康: `:checkhealth lazy`

### 性能问题
1. 检查启动时间: `nvim --startuptime startup.log`
2. 查看插件加载: `:Lazy profile`
3. 检查健康: `:checkhealth`

## 扩展和定制

### 添加新插件
1. 编辑对应的插件配置文件（如 `lua/plugins/editing.lua`）
2. 添加插件规格
3. 重启 Neovim，lazy.nvim 自动安装

### 添加新 LSP 服务器
1. 运行 `:Mason`
2. 搜索并安装服务器
3. 在 `lua/plugins/ide.lua` 中添加配置
4. 重启 Neovim

### 添加新代码片段
1. 编辑对应的片段文件（如 `snippets/python.lua`）
2. 使用 LuaSnip 语法定义片段
3. 重启 Neovim 或 `:luafile snippets/python.lua`

## 版本历史

- **2026-02-02**: 完成从 Vim 到 Neovim 的重构
  - 删除 YouCompleteMe、vim-go、旧配置文件
  - 迁移到 nvim-lspconfig + Mason
  - 修复 LSP 自动启动问题
  - 整理项目文档到 docs/

- **2025 之前**: 使用 Vim + Vim-plug + YouCompleteMe

## 相关资源

- [Neovim 官网](https://neovim.io/)
- [lazy.nvim GitHub](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig GitHub](https://github.com/neovim/nvim-lspconfig)
- [Mason GitHub](https://github.com/williamboman/mason.nvim)

## 项目仓库

- GitHub: https://github.com/hjc1702/p-vim
- 分支: feature/new (Neovim 配置)
- 分支: master (旧 Vim 配置)
