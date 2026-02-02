# p-vim - Modern Neovim Configuration

现代化的 Neovim 编辑器配置，使用 Lua + lazy.nvim，提供完整的 IDE 体验。

## ✨ 特性

- ⚡ **快速启动**: ~228ms 启动时间（优化后 45% 提升）
- 🎨 **现代 UI**: Solarized8 主题 + Lualine + Bufferline 标签页
- 🔍 **强大搜索**: Telescope 模糊搜索 + Trouble 诊断界面
- 💡 **智能补全**: LSP 原生支持 + nvim-cmp + 代码片段
- 🌳 **语法高亮**: Treesitter + 彩虹括号
- 📦 **插件管理**: lazy.nvim 懒加载（43 个插件）
- ⌨️  **丰富快捷键**: 95+ 个自定义快捷键 + Which-key 提示
- 🎯 **代码片段**: LuaSnip 片段引擎（40+ Python 片段）
- 🔧 **Git 集成**: Gitsigns diff/blame/stage
- 📝 **TODO 管理**: 自动高亮 TODO/FIXME/HACK
- 🎨 **颜色显示**: 自动显示 #RGB 颜色代码
- 🛠️ **自动化**: Mason 自动管理 LSP/Linter/Formatter

## 🚀 快速安装

### 一键安装（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/hjc1702/p-vim.git
cd p-vim

# 2. 运行自动安装脚本
./install-neovim.sh
```

**脚本会自动完成：**
- ✅ 检测操作系统（macOS/Linux）
- ✅ 安装 Neovim (>= 0.10.0)
- ✅ 安装依赖工具（ripgrep, fd, node, python3）
- ✅ 安装 Python 工具（black, isort, flake8）
- ✅ 安装 Nerd Font（可选，用于图标）
- ✅ 创建软链接到 ~/.config/nvim
- ✅ 自动安装所有 Neovim 插件
- ✅ Mason 自动安装 LSP 服务器

### 支持的系统

- **macOS** - 使用 Homebrew
- **Ubuntu/Debian** - 使用 apt
- **Fedora/RHEL** - 使用 dnf
- **Arch/Manjaro** - 使用 pacman

### 手动安装

如果你想手动控制安装过程：

```bash
# 1. 安装 Neovim
brew install neovim  # macOS
# 或
sudo apt install neovim  # Ubuntu/Debian

# 2. 安装依赖
brew install ripgrep fd node python3  # macOS
# 或
sudo apt install ripgrep fd-find nodejs python3 python3-pip  # Ubuntu

# 3. 安装 Python 工具
pip3 install --user flake8 black isort

# 4. 安装 Nerd Font
brew install --cask font-maple-mono-nf-cn  # macOS

# 5. 克隆配置并创建软链接
git clone https://github.com/hjc1702/p-vim.git ~/.config/nvim

# 6. 启动 Neovim，lazy.nvim 会自动安装插件
nvim
```

### 验证安装

```vim
:checkhealth              " 检查健康状态
:Lazy                     " 查看插件状态
:Mason                    " 查看 LSP 服务器
```

## ⌨️  快捷键完全指南

### 基础操作

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `kj` | Insert | 退出插入模式 | 替代 Esc，更快捷 |
| `;` | Normal | 进入命令模式 | 替代 `:` |
| `<space>` | Normal | 搜索 | 替代 `/` |
| `,/` | Normal | 清除搜索高亮 | `:nohlsearch` |
| `U` | Normal | 重做 | 替代 Ctrl-r |
| `H` | Normal | 跳到行首 | 替代 `^` |
| `L` | Normal | 跳到行尾 | 替代 `$` |

### LSP 功能

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
| `[d` | 上一个诊断 | Previous Diagnostic |
| `]d` | 下一个诊断 | Next Diagnostic |
| `,e` | 显示诊断 | Show Diagnostic Float |
| `,q` | 诊断列表 | Diagnostic List |
| `,k` | 签名帮助 | Signature Help |
| `<C-s>` | 签名帮助 | Insert 模式签名 |
| `,ld` | LSP 调试信息 | Debug LSP |
| `,lr` | 重启 Python LSP | Restart Python LSP |

### 文件和导航

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
| `,fh` | 命令历史 | Command History |
| `,fs` | 搜索历史 | Search History |
| `,fk` | 快捷键列表 | Keymaps |
| `,ft` | TODO 搜索 | 搜索 TODO 注释 |
| `F9` | 代码大纲 | Aerial 大纲 |

### Buffer 管理

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `[b` | 上一个 Buffer | Previous Buffer |
| `]b` | 下一个 Buffer | Next Buffer |
| `<Left>` | 上一个 Buffer | 与 `[b` 相同 |
| `<Right>` | 下一个 Buffer | 与 `]b` 相同 |
| `,bp` | Pin Buffer | 固定/取消固定 |
| `,bo` | 关闭其他 | Close Others |
| `,br` | 关闭右侧 | Close Right |
| `,bl` | 关闭左侧 | Close Left |
| `,bP` | 关闭未固定 | Close Unpinned |

### 窗口管理

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-h>` | 左侧窗口 | 支持 Tmux |
| `<C-j>` | 下侧窗口 | 支持 Tmux |
| `<C-k>` | 上侧窗口 | 支持 Tmux |
| `<C-l>` | 右侧窗口 | 支持 Tmux |
| `,z` | 窗口最大化 | 切换缩放 |
| `,q` | 关闭窗口 | `:q` |
| `,w` | 保存文件 | `:w` |

### 编辑增强

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `gcc` | Normal | 注释行 | Toggle Line Comment |
| `gc` + motion | Normal | 注释 motion | 如 `gcap` 注释段落 |
| `gc` | Visual | 注释选区 | Comment Selection |
| `,c<space>` | Normal | 注释行 | 兼容旧习惯 |
| `,c<space>` | Visual | 注释选区 | 兼容旧习惯 |
| `gcO` | Normal | 上方注释 | Comment Above |
| `gco` | Normal | 下方注释 | Comment Below |
| `gcA` | Normal | 行尾注释 | Comment EOL |
| `cs"'` | Normal | 修改包围 | 双引号改单引号 |
| `ds"` | Normal | 删除包围 | 删除引号 |
| `ys{motion}"` | Normal | 添加包围 | 添加引号 |
| `<` | Visual | 减少缩进 | 保持选中 |
| `>` | Visual | 增加缩进 | 保持选中 |
| `Y` | Normal | 复制到行尾 | 与 D、C 一致 |
| `,<space>` | Normal | 清理空格 | 删除尾部空格 |
| `,a` | Normal | 格式化文件 | Format File |
| `,y` | Visual | 格式化选区 | Format Selection |

### Git 集成

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `]c` | 下一个改动 | Next Git Hunk |
| `[c` | 上一个改动 | Previous Git Hunk |
| `,hp` | 预览改动 | Preview Hunk |
| `,hs` | Stage 改动 | Stage Hunk |
| `,hr` | 重置改动 | Reset Hunk |
| `,hS` | Stage 文件 | Stage Buffer |
| `,hu` | 撤销 Stage | Undo Stage |
| `,hR` | 重置文件 | Reset Buffer |
| `,hb` | 显示 Blame | Blame Line |
| `,tb` | 切换 Blame | Toggle Line Blame |
| `,hd` | Diff This | Git Diff |
| `,hD` | Diff This ~ | Git Diff ~ |
| `,td` | 切换删除 | Toggle Deleted |
| `ih` | 选择 Hunk | Text Object |

### 快速跳转

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `s` | Normal/Visual | 快速跳转 | Flash Jump |
| `S` | Normal/Visual | 选择节点 | Treesitter Select |
| `<C-s>` | Command | 搜索 Flash | 命令行搜索 |

### 诊断和 TODO

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,xx` | 所有诊断 | Trouble 诊断 |
| `,xX` | Buffer 诊断 | 当前文件诊断 |
| `,cs` | 符号列表 | Trouble 符号 |
| `,cl` | LSP 定义 | Trouble LSP |
| `,xL` | Location List | Trouble Loclist |
| `,xQ` | Quickfix | Trouble Quickfix |
| `]t` | 下一个 TODO | Next Todo |
| `[t` | 上一个 TODO | Previous Todo |
| `,ft` | TODO 列表 | Telescope Todo |
| `,xt` | TODO Trouble | Trouble Todo |

### 搜索相关

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `n` | 下一个匹配 | 搜索结果居中 |
| `N` | 上一个匹配 | 搜索结果居中 |
| `*` | 搜索光标词 | 向下搜索 |
| `#` | 搜索光标词 | 向上搜索 |
| `g*` | 部分匹配 | 向下搜索 |

### 选择和复制

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,sa` | 全选 | ggVG |
| `gv` | 选择上次插入 | Select Last Insert |
| `,V` | 选择代码块 | V`} |
| `,v` | 系统粘贴 | "+gp |
| `,c` | 系统复制 | "+y (Visual) |

### 行号和折叠

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<C-n>` | 切换行号 | 相对/绝对 |
| `,zz` | 切换折叠 | Toggle All Folds |
| `za` | 切换当前折叠 | 原生 Vim |
| `zM` | 关闭所有折叠 | 原生 Vim |
| `zR` | 打开所有折叠 | 原生 Vim |

### 特殊功能

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,` (等待) | 快捷键提示 | Which-key 面板 |
| `,tr` | 切换彩虹括号 | Toggle Rainbow |
| `w!!` | Sudo 保存 | Command 模式 |

### 补全导航

| 快捷键 | 模式 | 功能 | 说明 |
|--------|------|------|------|
| `<C-j>` | Insert | 下一个补全 | nvim-cmp |
| `<C-k>` | Insert | 上一个补全 | nvim-cmp |
| `<Tab>` | Insert | 展开/跳转 | 片段跳转 |
| `<S-Tab>` | Insert | 反向跳转 | 片段反向 |
| `<C-Space>` | Insert | 触发补全 | 手动补全 |
| `<CR>` | Insert | 确认补全 | 选中项 |
| `<C-e>` | Insert | 取消补全 | 关闭菜单 |
| `<C-b>` | Insert | 文档上翻 | 补全文档 |
| `<C-f>` | Insert | 文档下翻 | 补全文档 |

---

## 📝 使用技巧

### 搜索和导航工作流

```vim
" 1. 搜索项目文件
,p          " 模糊搜索文件名

" 2. 全局搜索内容
\           " Live grep 搜索内容

" 3. 搜索当前文件符号
,fu         " 函数/类列表

" 4. 快速跳转
s           " Flash 快速跳转到任意位置
```

### LSP 开发工作流

```vim
" 1. 跳转到定义
,jd         " 查看函数定义

" 2. 查看文档
K           " Hover 显示文档

" 3. 查看引用
gr          " 所有引用位置

" 4. 重命名
,rn         " 重命名变量/函数

" 5. 代码操作
,ca         " 自动修复/导入
```

### Git 工作流

```vim
" 1. 查看改动
]c          " 跳到下一个改动
,hp         " 预览改动内容

" 2. Stage 改动
,hs         " Stage 当前 hunk

" 3. 查看 Blame
,hb         " 查看是谁改的

" 4. 重置改动
,hr         " 撤销当前改动
```

### 调试工作流

```vim
" 1. 查看所有错误
,xx         " Trouble 诊断列表

" 2. 跳转错误
]d          " 下一个错误
[d          " 上一个错误

" 3. 查看错误详情
,e          " 浮窗显示错误

" 4. LSP 调试
,ld         " LSP 调试信息
```

### 格式化和 Linting

```vim
" 自动格式化（保存时）
:w          " 保存时自动格式化

" 手动格式化
,a          " 格式化整个文件
,y          " 格式化选中区域 (Visual)

" LSP 格式化
,fm         " 使用 LSP 格式化

" 手动 Lint
,l          " 触发 linting
```

---

## 🎯 高级用法

### 代码片段

Python 文件中输入触发词后按 `<Tab>`:

```python
main<Tab>   # if __name__ == '__main__'
def<Tab>    # 函数定义模板
class<Tab>  # 类定义模板
for<Tab>    # for 循环模板
```

### Treesitter 选择

```vim
<CR>        " 开始选择
<CR>        " 扩大选择（智能识别节点）
<S-Tab>     " 缩小选择
```

### Telescope 高级搜索

```vim
" 在 Telescope 中：
<C-j>       " 下一个结果
<C-k>       " 上一个结果
<C-n>       " 历史记录下一个
<C-p>       " 历史记录上一个
<Esc>       " 关闭
```

### Buffer 标签页操作

```vim
" 鼠标操作（Bufferline）：
左键         " 切换到 buffer
中键         " 删除 buffer
右键         " 菜单

" 键盘操作：
[b/]b       " 切换 buffer
,bo         " 只保留当前
,bp         " 固定 buffer（不会被 ,bo 关闭）
```

---

## 🔍 快速参考

### 记忆技巧

- `,j` 系列 - **跳转** (jump)
- `,f` 系列 - **查找** (find)
- `,h` 系列 - **Git hunk** 操作
- `,b` 系列 - **Buffer** 操作
- `,x` 系列 - **诊断** (diagnostics)
- `,t` 系列 - **切换** (toggle)

### 最常用快捷键 Top 20

1. `,p` - 文件搜索
2. `\` - 全局搜索
3. `,jd` - 跳转定义
4. `K` - 显示文档
5. `gcc` - 注释行
6. `,c<space>` - 注释（Visual）
7. `[b` / `]b` - 切换 Buffer
8. `,n` - 文件树
9. `s` - 快速跳转
10. `]d` / `[d` - 诊断导航
11. `,xx` - 诊断列表
12. `,rn` - 重命名
13. `]c` / `[c` - Git 改动
14. `,hp` - 预览 Git
15. `,a` - 格式化
16. `,b` - Buffer 列表
17. `<C-h/j/k/l>` - 窗口导航
18. `,` - Which-key 提示
19. `,fu` - 符号搜索
20. `gr` - 查看引用

完整配置详见 [CLAUDE.md](./CLAUDE.md)。

## ⌨️  核心快捷键

### LSP 功能
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,jd` | 跳转定义 | Jump to Definition |
| `,gd` | 跳转声明 | Go to Declaration |
| `K` | 显示文档 | Hover Documentation |
| `gr` | 查看引用 | References |
| `,rn` | 重命名 | Rename |
| `,ca` | 代码操作 | Code Action |
| `[d` / `]d` | 上/下一个诊断 | Navigate Diagnostics |
| `,e` | 诊断浮窗 | Diagnostic Float |

### 文件导航
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `,n` | 文件树 | nvim-tree |
| `,p` | 文件搜索 | Telescope find_files |
| `,gf` | Git 文件 | Telescope git_files |
| `\` | 全局搜索 | Live grep |
| `,b` | Buffer 列表 | Telescope buffers |
| `[b` / `]b` | 切换 Buffer | Buffer navigation |

### Git 集成
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `]c` / `[c` | 下/上一个改动 | Next/Prev hunk |
| `,hp` | 预览改动 | Preview hunk |
| `,hs` | Stage 改动 | Stage hunk |
| `,hr` | 重置改动 | Reset hunk |
| `,hb` | Blame 行 | Blame line |

### 快速跳转
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `s` | 快速跳转 | Flash jump |
| `S` | 选择节点 | Treesitter select |
| `,xx` | 诊断列表 | Trouble diagnostics |
| `,ft` | TODO 搜索 | Find todos |
| `]t` / `[t` | TODO 跳转 | Next/Prev todo |

### 其他
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `kj` | 退出插入 | 替代 Esc |
| `;` | 命令行 | 替代 `:` |
| `,` (等待) | 快捷键提示 | Which-key |
| `gcc` | 注释行 | Comment |
| `,a` | 格式化 | Format file |
| `,tr` | 彩虹括号 | Toggle rainbow |

完整快捷键列表请查看 [CLAUDE.md](./CLAUDE.md)。

## 📁 项目结构

```
p-vim/
├── init.lua                # 主入口
├── lua/
│   ├── config/            # 基础配置
│   │   ├── options.lua     # 编辑器设置
│   │   ├── keymaps.lua     # 快捷键映射
│   │   ├── functions.lua   # 自定义函数
│   │   ├── autocmds.lua    # 自动命令
│   │   └── lsp-debug.lua   # LSP 调试
│   └── plugins/           # 插件配置（模块化）
│       ├── init.lua        # lazy.nvim 引导
│       ├── ui.lua          # 界面插件
│       ├── navigation.lua  # 导航插件
│       ├── editing.lua     # 编辑增强
│       ├── ide.lua         # LSP/补全
│       └── integration.lua # 集成插件
├── snippets/              # 代码片段
│   ├── python.lua          # 40+ Python 片段
│   ├── c.lua               # 20+ C 片段
│   └── all.lua             # 通用片段
├── after/ftplugin/        # 文件类型配置
│   ├── python.lua
│   └── lua.lua
├── docs/                  # 项目文档
├── install-neovim.sh      # 自动安装脚本
└── lazy-lock.json         # 插件版本锁定
```

## 📚 文档

- **[CLAUDE.md](./CLAUDE.md)** - 完整使用文档和配置指南
- **[docs/MIGRATION-SUMMARY.md](./docs/MIGRATION-SUMMARY.md)** - 迁移总结
- **[docs/REFACTORING-COMPLETE.md](./docs/REFACTORING-COMPLETE.md)** - 重构报告
- **[docs/LSP-FIX-REPORT.md](./docs/LSP-FIX-REPORT.md)** - LSP 问题修复

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
| 启动时间 | 413ms | 228ms | **45%** |
| 插件数量 | 37 个 | 43 个 | +6 |
| 快捷键 | 73 个 | 95 个 | +22 |
| LSP 支持 | Python/Lua | Python/Lua/Go/Rust/TOML/Vue | +4 |
| 自动工具 | 0 | 14 个 | 全新 |

## 🎯 支持的语言

| 语言 | LSP | Linting | Formatting | 代码片段 |
|------|-----|---------|------------|---------|
| Python | ✅ pyright | ✅ flake8 | ✅ black + isort | ✅ 40+ |
| Lua | ✅ lua_ls | - | ✅ stylua | - |
| Go | ✅ gopls | - | ✅ gofmt | - |
| Rust | ✅ rust_analyzer | - | ✅ rustfmt | - |
| JavaScript/TypeScript | ✅ (可配置) | ✅ eslint_d | ✅ prettier | ✅ |
| HTML/CSS | - | - | ✅ prettier | - |
| JSON/YAML | - | - | ✅ prettier | - |
| C/C++ | ✅ (可配置) | - | - | ✅ 20+ |

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

MIT License

---

## 🎉 近期更新

### 2026-02-02 - 完整优化版本

**性能优化**:
- ✅ 启动时间从 413ms 降至 228ms（提升 45%）
- ✅ 简化 autocmd，减少不必要的事件
- ✅ 优化插件懒加载策略

**新增功能**:
- ✅ Trouble.nvim - 更好的诊断界面
- ✅ todo-comments - TODO 高亮和搜索
- ✅ nvim-colorizer - 颜色代码显示
- ✅ which-key - 快捷键提示面板
- ✅ bufferline - Buffer 标签页
- ✅ rainbow-delimiters - 彩虹括号
- ✅ gitsigns - Git 集成
- ✅ indent-blankline - 缩进线
- ✅ fidget.nvim - LSP 进度显示

**工具改进**:
- ✅ Python 格式化：yapf → black（现代标准）
- ✅ Mason 自动安装 14+ 工具
- ✅ 统一工具管理
- ✅ 增加 timeout 处理大文件

**Bug 修复**:
- ✅ 修复快捷键冲突
- ✅ 修复 which-key v3 API
- ✅ 修复 Mason 包名错误
- ✅ 修复彩虹括号自动启用

### 2025 - 完全重构

- ✅ 从 Vim + Vim-plug 完全迁移到 Neovim + lazy.nvim
- ✅ 移除 YouCompleteMe、vim-go 等旧插件
- ✅ 使用 nvim-lspconfig + Mason 提供 LSP 支持
- ✅ LSP 自动启动机制优化
- ✅ 项目文档整理

---

**注意**:
- 主分支（master）包含旧的 Vim 配置
- 当前分支（feature/new）是完全重构的 Neovim 配置
- 建议新用户直接使用 feature/new 分支
