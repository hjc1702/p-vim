# p-vim - Modern Neovim Configuration

现代化的 Neovim 编辑器配置，使用 Lua + lazy.nvim，提供完整的 IDE 体验。

## ✨ 核心特性

- ⚡ **极速启动**: 111ms 启动时间（优化后提升 62%）
- 🎨 **现代界面**: Solarized8 主题 + Lualine 状态栏 + Bufferline 标签页
- 🔍 **强大搜索**: Telescope 模糊搜索 + Trouble 诊断界面
- 💡 **智能补全**: LSP 原生支持 + nvim-cmp + LuaSnip 代码片段
- 🌳 **语法高亮**: Treesitter 语法解析 + 彩虹括号
- 📦 **插件管理**: lazy.nvim 懒加载（42 个插件）
- 🔧 **Git 集成**: Gitsigns 提供 diff/blame/stage 功能
- 🛠️ **自动化**: Mason 自动管理 LSP/Linter/Formatter
- 📝 **增强编辑**: 自动括号、智能注释、包围符号操作

## 🚀 快速安装

### 一键安装（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/hjc1702/p-vim.git
cd p-vim

# 2. 运行自动安装脚本
./install-neovim.sh
```

**安装脚本会自动完成：**
- ✅ 检测操作系统（macOS/Linux）
- ✅ 安装 Neovim (>= 0.10.0)
- ✅ 安装依赖工具（ripgrep, fd, node, python3）
- ✅ 安装 Python 工具（black, isort, flake8）
- ✅ 安装 Nerd Font（Maple Mono NF CN）
- ✅ 创建软链接到 ~/.config/nvim
- ✅ 自动安装所有插件和 LSP 服务器

### 支持的系统

| 系统 | 包管理器 | 状态 |
|------|---------|------|
| macOS | Homebrew | ✅ 完全支持 |
| Ubuntu/Debian | apt | ✅ 完全支持 |
| Fedora/RHEL | dnf | ✅ 完全支持 |
| Arch/Manjaro | pacman | ✅ 完全支持 |

### 验证安装

```vim
:checkhealth              " 检查健康状态
:Lazy                     " 查看插件状态
:Mason                    " 查看 LSP 服务器
```

## ⌨️  快捷键完全指南

### Leader 键说明
- Leader: `,` (逗号)
- 按下 `,` 后等待片刻，会自动显示 Which-key 提示面板

### 🎯 最常用快捷键 Top 15

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,p` | 文件搜索 | Telescope 模糊搜索 |
| `\` | 全局搜索 | Live grep 搜索内容 |
| `,n` | 文件树 | 切换 NvimTree |
| `,jd` | 跳转定义 | LSP 跳转到定义 |
| `K` | 显示文档 | LSP Hover 文档 |
| `gcc` | 注释行 | 切换行注释 |
| `s` | 快速跳转 | Flash 跳转 |
| `[b` / `]b` | 切换 Buffer | 上一个/下一个 Buffer |
| `]d` / `[d` | 诊断导航 | 下一个/上一个错误 |
| `,rn` | 重命名 | LSP 重命名符号 |
| `,ca` | 代码操作 | LSP 代码操作 |
| `,hp` | 预览 Git | 预览 Git 改动 |
| `,a` | 格式化 | 格式化当前文件 |
| `<C-h/j/k/l>` | 窗口导航 | 支持 Tmux 集成 |
| `,` (等待) | 快捷键提示 | Which-key 提示 |

### 📋 基础操作

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `kj` | Insert | 退出插入模式 | 替代 Esc，更快捷 |
| `;` | Normal | 进入命令模式 | 替代 `:` |
| `<space>` | Normal | 搜索 | 替代 `/` |
| `,/` | Normal | 清除搜索高亮 | `:nohlsearch` |
| `U` | Normal | 重做 | 替代 Ctrl-r |
| `H` | Normal | 跳到行首 | 替代 `^` |
| `L` | Normal | 跳到行尾 | 替代 `$` |

### 🔍 文件和导航

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,n` | 文件树 | NvimTree 切换 |
| `,p` | 文件搜索 | 搜索项目文件 |
| `,gf` | Git 文件搜索 | 只搜索 Git 文件 |
| `,f` | 最近文件 | 历史文件列表 |
| `\` | 全局搜索 | Live Grep |
| `,b` | Buffer 列表 | 打开的文件 |
| `,fu` | 文档符号 | 函数/类列表 |
| `,fU` | 光标符号 | 搜索光标下符号 |
| `,fd` | 诊断搜索 | Telescope 诊断 |
| `,ft` | TODO 搜索 | 搜索 TODO 注释 |
| `F9` | 代码大纲 | Aerial 大纲 |

### 💡 LSP 功能

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,jd` | 跳转到定义 | Jump to Definition |
| `,gd` | 跳转到声明 | Go to Declaration |
| `K` | 显示文档 | Hover Documentation |
| `gi` | 查看实现 | Go to Implementation |
| `gr` | 查看引用 | Find References |
| `,rn` | 重命名符号 | Rename Symbol |
| `,ca` | 代码操作 | Code Action |
| `,fm` | LSP 格式化 | Format with LSP |
| `[d` / `]d` | 诊断导航 | 上一个/下一个诊断 |
| `,e` | 显示诊断 | 诊断浮窗 |
| `,q` | 诊断列表 | Diagnostic List |

### ✏️  编辑增强

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `gcc` | Normal | 注释行 | Toggle Line Comment |
| `gc` + motion | Normal | 注释 motion | 如 `gcap` 注释段落 |
| `gc` | Visual | 注释选区 | Comment Selection |
| `gcO` | Normal | 上方注释 | Comment Above |
| `gco` | Normal | 下方注释 | Comment Below |
| `gcA` | Normal | 行尾注释 | Comment EOL |
| `cs"'` | Normal | 修改包围 | 双引号改单引号 |
| `ds"` | Normal | 删除包围 | 删除引号 |
| `ys{motion}"` | Normal | 添加包围 | 添加引号 |
| `<` / `>` | Visual | 缩进 | 保持选中 |
| `,<space>` | Normal | 清理空格 | 删除尾部空格 |
| `,a` | Normal | 格式化文件 | Format File |
| `,y` | Visual | 格式化选区 | Format Selection |

### 🔧 Git 集成

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `]c` / `[c` | 改动导航 | 下一个/上一个改动 |
| `,hp` | 预览改动 | Preview Hunk |
| `,hs` | Stage 改动 | Stage Hunk |
| `,hr` | 重置改动 | Reset Hunk |
| `,hS` | Stage 文件 | Stage Buffer |
| `,hu` | 撤销 Stage | Undo Stage |
| `,hR` | 重置文件 | Reset Buffer |
| `,hb` | 显示 Blame | Blame Line |
| `,tb` | 切换 Blame | Toggle Line Blame |
| `,hd` | Diff This | Git Diff |

### 📦 Buffer 管理

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `[b` / `]b` | 切换 Buffer | 上一个/下一个 Buffer |
| `<Left>` / `<Right>` | 切换 Buffer | 与 `[b` / `]b` 相同 |
| `,bp` | Pin Buffer | 固定/取消固定 |
| `,bo` | 关闭其他 | Close Others |
| `,br` | 关闭右侧 | Close Right |
| `,bl` | 关闭左侧 | Close Left |
| `,bP` | 关闭未固定 | Close Unpinned |

### 🪟 窗口管理

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-h>` | 左侧窗口 | 支持 Tmux |
| `<C-j>` | 下侧窗口 | 支持 Tmux |
| `<C-k>` | 上侧窗口 | 支持 Tmux |
| `<C-l>` | 右侧窗口 | 支持 Tmux |
| `,z` | 窗口最大化 | 切换缩放 |
| `,q` | 关闭窗口 | `:q` |
| `,w` | 保存文件 | `:w` |

### 🐛 诊断和 TODO

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,xx` | 所有诊断 | Trouble 诊断 |
| `,xX` | Buffer 诊断 | 当前文件诊断 |
| `,cs` | 符号列表 | Trouble 符号 |
| `,cl` | LSP 定义 | Trouble LSP |
| `]t` / `[t` | TODO 导航 | 下一个/上一个 TODO |
| `,ft` | TODO 列表 | Telescope Todo |
| `,xt` | TODO Trouble | Trouble Todo |

### 💬 补全导航

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `<C-j>` | Insert | 下一个补全 | nvim-cmp |
| `<C-k>` | Insert | 上一个补全 | nvim-cmp |
| `<Tab>` | Insert | 展开/跳转 | 片段跳转 |
| `<S-Tab>` | Insert | 反向跳转 | 片段反向 |
| `<C-Space>` | Insert | 触发补全 | 手动补全 |
| `<CR>` | Insert | 确认补全 | 选中项 |
| `<C-e>` | Insert | 取消补全 | 关闭菜单 |

### 🎨 其他功能

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-n>` | 切换行号 | 相对/绝对 |
| `,zz` | 切换折叠 | Toggle All Folds |
| `,tr` | 切换彩虹括号 | Toggle Rainbow |
| `w!!` | Sudo 保存 | Command 模式 |

## 📁 项目结构

```
p-vim/
├── init.lua                  # 主入口
├── lua/
│   ├── config/              # 基础配置
│   │   ├── options.lua       # 编辑器设置
│   │   ├── keymaps.lua       # 快捷键映射
│   │   ├── functions.lua     # 自定义函数
│   │   ├── autocmds.lua      # 自动命令
│   │   └── lsp-debug.lua     # LSP 调试
│   └── plugins/             # 插件配置（模块化）
│       ├── init.lua          # lazy.nvim 引导
│       ├── ui.lua            # 界面插件
│       ├── navigation.lua    # 导航插件
│       ├── editing.lua       # 编辑增强
│       ├── ide.lua           # LSP/补全
│       └── integration.lua   # 集成插件
├── snippets/                # 代码片段
│   ├── python.lua            # 40+ Python 片段
│   ├── c.lua                 # 20+ C 片段
│   └── all.lua               # 通用片段
├── after/ftplugin/          # 文件类型配置
│   ├── python.lua
│   └── lua.lua
├── docs/                    # 项目文档
├── install-neovim.sh        # 自动安装脚本
└── lazy-lock.json           # 插件版本锁定
```

## 🔧 技术栈

| 组件 | 技术 |
|------|------|
| 编辑器 | Neovim 0.11+ |
| 配置语言 | Lua |
| 插件管理 | lazy.nvim |
| LSP | nvim-lspconfig + Mason |
| 补全 | nvim-cmp |
| 搜索 | Telescope + ripgrep |
| 语法高亮 | Treesitter |
| 片段引擎 | LuaSnip |
| Linting | nvim-lint |
| 格式化 | conform.nvim |

## 📊 性能数据

| 指标 | 优化前 | 优化后 | 提升 |
|------|--------|--------|------|
| 启动时间 | 294ms | 111ms | **62%** ⚡ |
| 插件数量 | 25 个 | 42 个 | +17 |
| 内存使用 | ~50MB | ~50MB | 持平 |

**优化措施**:
- ✅ LuaSnip 延迟加载（InsertEnter）
- ✅ 片段按文件类型懒加载
- ✅ 禁用不需要的内置插件
- ✅ 插件合理配置懒加载策略

## 🎯 支持的语言

| 语言 | LSP | Linting | Formatting | 代码片段 |
|------|-----|---------|-----------|---------|
| Python | ✅ pyright | ✅ flake8 | ✅ black + isort | ✅ 40+ |
| Lua | ✅ lua_ls | - | ✅ stylua | - |
| Go | ✅ gopls | - | ✅ gofmt | - |
| Rust | ✅ rust_analyzer | - | ✅ rustfmt | - |
| JavaScript/TypeScript | ✅ 可配置 | ✅ eslint_d | ✅ prettier | ✅ |
| HTML/CSS | - | - | ✅ prettier | - |
| JSON/YAML | - | - | ✅ prettier | - |
| C/C++ | ✅ 可配置 | - | - | ✅ 20+ |

## 📝 使用技巧

### 快速搜索工作流

```vim
,p          " 搜索项目文件
\           " 全局搜索内容
,fu         " 搜索当前文件符号
s           " Flash 快速跳转
```

### LSP 开发工作流

```vim
,jd         " 跳转到定义
K           " 查看文档
gr          " 查看引用
,rn         " 重命名变量/函数
,ca         " 代码操作（自动修复）
```

### Git 工作流

```vim
]c          " 跳到下一个改动
,hp         " 预览改动内容
,hs         " Stage 当前 hunk
,hb         " 查看 Blame
,hr         " 撤销改动
```

### 调试工作流

```vim
,xx         " 查看所有错误
]d / [d     " 跳转错误
,e          " 浮窗显示错误
,ld         " LSP 调试信息
```

### 代码格式化

```vim
:w          " 保存（不会自动格式化）
,a          " 手动格式化整个文件
,y          " 格式化选中区域 (Visual)
,fm         " 使用 LSP 格式化
```

## 🧩 插件列表（42 个）

### 界面增强
- vim-solarized8 - 主题
- lualine.nvim - 状态栏
- bufferline.nvim - Buffer 标签页
- nvim-web-devicons - 图标支持
- which-key.nvim - 快捷键提示

### 语法和高亮
- nvim-treesitter - 语法解析
- rainbow-delimiters.nvim - 彩虹括号
- indent-blankline.nvim - 缩进线
- todo-comments.nvim - TODO 高亮
- nvim-colorizer.lua - 颜色代码显示

### 导航和搜索
- nvim-tree.lua - 文件树
- telescope.nvim - 模糊搜索
- telescope-fzf-native.nvim - FZF 扩展
- aerial.nvim - 代码大纲
- flash.nvim - 快速跳转
- trouble.nvim - 诊断列表

### 编辑增强
- nvim-autopairs - 自动括号
- nvim-surround - 包围符号操作
- Comment.nvim - 智能注释
- nvim-ts-context-commentstring - 上下文注释
- mini.trailspace - 尾部空格管理

### LSP 和补全
- nvim-lspconfig - LSP 配置
- mason.nvim - LSP 服务器管理
- mason-lspconfig.nvim - Mason 桥接
- nvim-cmp - 补全引擎
- cmp-nvim-lsp - LSP 补全源
- cmp-buffer - Buffer 补全源
- cmp-path - 路径补全源
- cmp-cmdline - 命令行补全源
- LuaSnip - 代码片段引擎
- cmp_luasnip - LuaSnip 补全源
- lspkind.nvim - 补全图标
- friendly-snippets - 预定义片段
- fidget.nvim - LSP 进度显示

### 代码质量
- nvim-lint - Linting
- conform.nvim - 代码格式化

### 集成
- vim-tmux-navigator - Tmux 集成
- gitsigns.nvim - Git 集成
- orgmode - Org-mode 支持

## 📚 文档

- **[CLAUDE.md](./CLAUDE.md)** - 完整配置指南和技术文档
- **[docs/](./docs/)** - 项目技术文档
  - MIGRATION-SUMMARY.md - 从 Vim 到 Neovim 迁移总结
  - REFACTORING-COMPLETE.md - 重构报告
  - LSP-FIX-REPORT.md - LSP 问题修复报告
  - LSP-PERFORMANCE-OPTIMIZATION.md - LSP 性能优化
  - STARTUP-PERFORMANCE-OPTIMIZATION.md - 启动性能优化

## 🛠️ 常用命令

```vim
" 插件管理
:Lazy                     " 插件管理界面
:Lazy sync                " 同步插件
:Lazy update              " 更新所有插件

" LSP 管理
:Mason                    " LSP 服务器管理
:LspInfo                  " 查看 LSP 状态
:LspDebug                 " LSP 调试信息
:LspRestart               " 重启 LSP

" 健康检查
:checkhealth              " 检查健康状态
:checkhealth lazy         " 检查 lazy.nvim
:checkhealth mason        " 检查 Mason
```

## 🔍 故障排除

### LSP 不工作
```vim
:LspInfo                  " 查看 LSP 状态
:LspDebug                 " 查看调试信息
:Mason                    " 检查服务器安装
:LspStart pyright         " 手动启动 LSP
```

### 插件问题
```vim
:Lazy sync                " 同步插件
:Lazy clean               " 清理缓存
:Lazy log                 " 查看日志
```

### 性能问题
```bash
# 启动时间分析
nvim --startuptime startup.log

# 查看插件加载
:Lazy profile
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

MIT License

## 🎉 更新日志

### 2026-02-02 - 性能优化版本

**性能优化**:
- ✅ 启动时间从 294ms 降至 111ms（提升 62%）
- ✅ LuaSnip 延迟加载优化
- ✅ 简化 autocmd，减少不必要事件
- ✅ 优化插件懒加载策略

**新增功能**:
- ✅ bufferline.nvim - Buffer 标签页
- ✅ trouble.nvim - 诊断界面
- ✅ todo-comments.nvim - TODO 高亮和搜索
- ✅ nvim-colorizer.lua - 颜色代码显示
- ✅ which-key.nvim - 快捷键提示
- ✅ rainbow-delimiters.nvim - 彩虹括号
- ✅ gitsigns.nvim - Git 集成
- ✅ indent-blankline.nvim - 缩进线
- ✅ fidget.nvim - LSP 进度显示

**工具改进**:
- ✅ 格式化：yapf → black（现代标准）
- ✅ Mason 自动安装 14+ 工具
- ✅ 禁用自动格式化，改为手动触发
- ✅ 增加 timeout 处理大文件

**Bug 修复**:
- ✅ 修复快捷键冲突
- ✅ 修复 which-key v3 API
- ✅ 修复 Mason 包名错误
- ✅ 修复彩虹括号自动启用
- ✅ 修复 LSP 自动启动问题

### 2025 - 完全重构

- ✅ 从 Vim + Vim-plug 完全迁移到 Neovim + lazy.nvim
- ✅ 移除 YouCompleteMe、vim-go 等旧插件
- ✅ 使用 nvim-lspconfig + Mason 提供 LSP 支持
- ✅ LSP 自动启动机制优化
- ✅ 项目文档整理

---

**主分支**: master（最新 Neovim 配置）

> **注意**: 旧的 Vim 配置已完全迁移到 Neovim，建议所有用户使用 master 分支。
