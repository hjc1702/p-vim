# p-vim - Modern Neovim Configuration

现代化的 Neovim 编辑器配置，使用 Lua + lazy.nvim，追求**轻量、快速、稳定**。

> 说明：本配置已移除 LSP / Lint / Format，仅保留语法高亮与补全（buffer/path/snippet）。

## ✨ 核心特性

- ⚡ **极速启动**: 轻量懒加载
- 🎨 **现代界面**: Solarized8 主题 + Lualine 状态栏 + Bufferline 标签页
- 🔍 **强大搜索**: Telescope 模糊搜索
- ✂️ **代码片段**: LuaSnip + friendly-snippets
- ✨ **轻量补全**: nvim-cmp（buffer/path/cmdline/snippets）
- 🌳 **语法高亮**: Treesitter + 彩虹括号
- 📦 **插件管理**: lazy.nvim
- 🔧 **Git 集成**: Gitsigns 提供 diff/blame/stage 功能
- 🛠️ **编辑增强**: 自动括号、智能注释、包围符号操作

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
- ✅ 安装 Nerd Font（Maple Mono NF CN，可选）
- ✅ 创建软链接到 `~/.config/nvim`
- ✅ 自动安装所有插件

### 验证安装

```vim
:checkhealth              " 检查健康状态
:Lazy                     " 查看插件状态
```

## ⌨️  常用快捷键

> 📖 **完整快捷键文档**: 查看 [KEYMAPS.md](KEYMAPS.md) 获取所有 150+ 个快捷键的详细说明

### Leader 键说明
- Leader: `,` (逗号)
- 按下 `,` 后等待片刻，会自动显示 Which-key 提示面板

### 🎯 最常用快捷键

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,p` | 文件搜索 | Telescope 模糊搜索 |
| `\` | 全局搜索 | Live grep 搜索内容 |
| `,n` | 文件树 | 切换 NvimTree |
| `gcc` | 注释行 | 切换行注释 |
| `gs` | 快速跳转 | Flash 跳转 |
| `[b` / `]b` | 切换 Buffer | 上一个/下一个 Buffer |
| `,hp` | 预览 Git | 预览 Git 改动 |
| `<C-h/j/k/l>` | 窗口导航 | 支持 Tmux 集成 |
| `,` (等待) | 快捷键提示 | Which-key 提示 |

### 🔍 文件和导航

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,n` | 文件树 | NvimTree 切换 |
| `,p` | 文件搜索 | 搜索项目文件 |
| `,gf` | Git 文件搜索 | 只搜索 Git 文件 |
| `,f` | 最近文件 | 历史文件列表 |
| `\` | 全局搜索 | Live Grep |
| `,fb` | Buffer 列表 | 打开的文件 |
| `,fu` | 文档符号 | Treesitter 符号 |
| `,fU` | 光标符号 | 搜索光标下符号 |
| `F9` | 代码大纲 | Aerial 大纲 |

### ✏️  编辑增强

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `gcc` | Normal | 注释行 | Toggle Line Comment |
| `gc` + motion | Normal | 注释 motion | 如 `gcap` 注释段落 |
| `gc` | Visual | 注释选区 | Comment Selection |
| `cs"'` | Normal | 修改包围 | 双引号改单引号 |
| `ds"` | Normal | 删除包围 | 删除引号 |
| `ys{motion}"` | Normal | 添加包围 | 添加引号 |
| `<` / `>` | Visual | 缩进 | 保持选中 |
| `,<space>` | Normal | 清理空格 | 删除尾部空格 |

### 💬 补全导航

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `<C-j>` | Insert | 下一个补全 | nvim-cmp |
| `<C-k>` | Insert | 上一个补全 | nvim-cmp |
| `<Tab>` | Insert | 选择/跳转 | nvim-cmp / LuaSnip |
| `<S-Tab>` | Insert | 反向跳转 | nvim-cmp / LuaSnip |

## 🗂️ 项目结构

```
p-vim/
├── README.md
├── init.lua
├── install-neovim.sh
├── lazy-lock.json
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── functions.lua
│   │   └── autocmds.lua
│   └── plugins/
│       ├── init.lua
│       ├── ui.lua
│       ├── navigation.lua
│       ├── editing.lua
│       ├── cmp.lua
│       ├── snippets.lua
│       └── integration.lua
├── snippets/
└── docs/
```

## 🧩 插件一览（精简版）

- 界面：`vim-solarized8`, `lualine`, `bufferline`, `nvim-web-devicons`
- 搜索：`telescope`, `telescope-fzf-native`
- 导航：`nvim-tree`, `aerial`, `flash`
- 高亮：`nvim-treesitter`, `rainbow-delimiters`, `indent-blankline`
- 编辑：`nvim-autopairs`, `nvim-surround`, `Comment.nvim`, `mini.trailspace`
- 补全：`nvim-cmp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline`, `lspkind`
- 片段：`LuaSnip`, `friendly-snippets`
- Git：`gitsigns`

## 说明

- 当前版本已移除 LSP / Lint / Format，避免后台检查与提示干扰。
- 如果你之后需要完整 IDE 能力，可以再按需加回。
