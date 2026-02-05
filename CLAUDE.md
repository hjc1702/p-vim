# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个现代化的 Neovim 编辑器配置，使用 Lua + lazy.nvim，追求轻量、快速、稳定。

**核心设计理念：**
- 已移除 LSP / Lint / Format 功能，避免后台检查和提示干扰
- 仅保留语法高亮与补全（buffer/path/snippet）
- 使用懒加载策略优化启动速度
- 模块化插件配置，按功能分类管理

## 常用命令

### 安装和初始化

```bash
# 一键安装脚本（会自动安装 Neovim、依赖工具、创建软链接）
./install-neovim.sh
```

### Neovim 内部命令

```vim
:checkhealth              " 检查健康状态
:Lazy                     " 查看和管理插件状态
:Lazy sync                " 同步插件（安装、更新、清理）
:Lazy update              " 更新所有插件
:Lazy clean               " 清理未使用的插件
```

### 测试配置修改

修改配置文件后：
1. 保存文件后使用 `:source %` 或重启 Neovim
2. 如果修改了插件配置，运行 `:Lazy reload <plugin-name>`
3. 使用 `:checkhealth` 检查配置问题

## 代码架构

### 目录结构

```
p-vim/
├── init.lua                    # 主入口文件
├── install-neovim.sh          # 自动安装脚本
├── lazy-lock.json             # 插件版本锁定文件
├── lua/
│   ├── config/                # 基础配置
│   │   ├── options.lua        # 编辑器选项（缩进、显示、搜索等）
│   │   ├── keymaps.lua        # 全局快捷键映射
│   │   ├── functions.lua      # 自定义函数（折叠、行号切换等）
│   │   └── autocmds.lua       # 自动命令（文件类型配置、事件处理）
│   └── plugins/               # 插件配置（模块化）
│       ├── init.lua           # lazy.nvim 主配置
│       ├── ui.lua             # 界面插件（主题、状态栏、高亮）
│       ├── navigation.lua     # 导航插件（文件树、搜索、跳转）
│       ├── editing.lua        # 编辑增强（括号、注释、包围符号）
│       ├── cmp.lua            # 补全配置（无 LSP）
│       ├── snippets.lua       # 代码片段配置
│       └── integration.lua    # 集成插件（tmux、Git）
└── snippets/                  # 自定义代码片段
    ├── all.lua
    ├── c.lua
    └── python.lua
```

### 加载流程

1. **init.lua**：设置 Leader 键 (`,`)，加载基础配置和插件系统
2. **config/options.lua**：配置编辑器选项（行号、缩进、搜索、折叠等）
3. **config/keymaps.lua**：设置全局快捷键（不包括插件专属快捷键）
4. **config/autocmds.lua**：配置自动命令（文件类型、事件处理）
5. **plugins/init.lua**：初始化 lazy.nvim 并导入各模块的插件配置

### 插件组织原则

插件配置按功能分类到不同文件：

- **ui.lua**：界面相关（vim-solarized8、lualine、bufferline、nvim-treesitter、rainbow-delimiters、indent-blankline、todo-comments、nvim-colorizer、which-key）
- **navigation.lua**：导航相关（nvim-tree、telescope、aerial、flash、trouble、gitsigns）
- **editing.lua**：编辑增强（nvim-autopairs、nvim-surround、Comment.nvim、mini.trailspace、vim-tmux-navigator）
- **cmp.lua**：补全系统（nvim-cmp + buffer/path/cmdline 源，无 LSP）
- **snippets.lua**：代码片段（LuaSnip + friendly-snippets）
- **integration.lua**：外部工具集成（暂时为空，可扩展）

### 懒加载策略

所有插件使用 lazy.nvim 的懒加载机制：

- `lazy = false, priority = 1000`：主题插件立即加载
- `event = "VeryLazy"`：大部分界面插件延迟加载
- `event = "InsertEnter"`：补全和括号插件在进入插入模式时加载
- `event = { "BufReadPost", "BufNewFile" }`：高亮和编辑增强插件在打开文件时加载
- `keys = {...}`：导航和工具插件在使用快捷键时加载
- `cmd = {...}`：部分插件在执行命令时加载

### 快捷键配置约定

- **全局快捷键**：定义在 `config/keymaps.lua`（如 `kj` -> ESC、`;` -> `:`）
- **插件专属快捷键**：定义在各自的插件配置文件中（如 `<leader>n` 在 navigation.lua）
- **Leader 键**：`,`（逗号）
- **快捷键提示**：按下 Leader 键等待片刻会显示 which-key 提示面板
- **完整快捷键文档**：查看 [KEYMAPS.md](KEYMAPS.md) 获取所有快捷键的详细说明

### 补全系统设计

**重要**：本配置已移除 LSP，补全源仅包括：
- `cmp-buffer`：从打开的 buffer 补全
- `cmp-path`：路径补全
- `cmp-cmdline`：命令行补全
- `cmp_luasnip`：代码片段补全

补全映射：
- `<C-j>` / `<C-k>`：选择下一个/上一个补全项
- `<Tab>` / `<S-Tab>`：选择补全项或跳转 snippet 占位符
- `<CR>`：确认补全

### 自定义函数

位于 `lua/config/functions.lua`：

- `toggle_fold()`：折叠/展开所有代码
- `number_toggle()`：切换相对/绝对行号
- `zoom_toggle()`：窗口最大化/还原
- `strip_trailing_whitespaces()`：清理尾部空格
- `auto_set_file_head()`：自动插入文件头（bash、python）

### 自动命令规则

位于 `lua/config/autocmds.lua`：

- **行号管理**：插入模式使用绝对行号，普通模式使用相对行号
- **文件类型缩进**：Python (4空格)、Ruby/JS/HTML/CSS/XML (2空格)
- **保存时清理**：特定文件类型保存时自动清理尾部空格
- **自动跳转**：打开文件时跳转到上次编辑位置
- **新建文件**：自动插入文件头（.sh, .py）

## 修改配置指南

### 添加新插件

1. 在 `lua/plugins/` 对应的分类文件中添加插件配置
2. 使用 lazy.nvim 的配置格式：

```lua
{
  "作者/插件名",
  dependencies = { "依赖插件" },
  event = "VeryLazy",  -- 或其他懒加载条件
  keys = {
    { "<leader>x", "<cmd>Command<cr>", desc = "描述" },
  },
  config = function()
    require("插件名").setup({
      -- 配置选项
    })
  end,
}
```

3. 重启 Neovim 或运行 `:Lazy sync`

### 修改快捷键

- **全局快捷键**：编辑 `lua/config/keymaps.lua`
- **插件快捷键**：编辑对应的插件配置文件中的 `keys` 字段

### 修改主题颜色

1. 主题在 `lua/plugins/ui.lua` 中配置
2. 当前使用 Solarized8 dark 主题
3. 自定义高亮配置在同文件的 `vim.cmd([[...]])` 部分

### 添加自定义代码片段

在 `snippets/` 目录下创建或编辑对应语言的文件：

```lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("trigger", {
    t("代码模板"),
    i(1, "占位符"),
  }),
}
```

## 重要注意事项

1. **无 LSP 设计**：不要添加任何 LSP 相关插件（如 nvim-lspconfig、mason.nvim），这是有意为之的设计决策
2. **禁用的内置插件**：netrw、gzip、matchit、tar、zip 等已在 `plugins/init.lua` 中禁用
3. **Provider 配置**：Node.js、Perl、Ruby provider 已禁用，仅保留 Python3
4. **性能优化**：所有插件配置都包含错误保护（pcall），防止未安装时报错
5. **兼容性**：配置要求 Neovim >= 0.10.0
6. **中文环境**：帮助语言设置为中文（`helplang = "cn"`）

## 调试问题

1. 使用 `:checkhealth` 检查配置问题
2. 使用 `:Lazy log` 查看插件加载日志
3. 使用 `:messages` 查看错误消息
4. 检查 `~/.local/share/nvim/` 和 `~/.cache/nvim/` 目录
5. 临时禁用插件：在插件配置中添加 `enabled = false`

### 常见问题

**Q: 在新电脑上安装后提示 "nvim-treesitter not installed yet"**
- **原因**：首次安装时，treesitter 配置被触发但插件还未完成安装
- **解决**：已在配置中添加静默处理，不会影响使用
- **确认**：运行 `./install-neovim.sh` 会自动完成 treesitter 解析器安装

**Q: 每次 Lazy sync 都修改 lazy-lock.json**
- **原因**：treesitter 的 `auto_install` 会自动安装新解析器
- **解决**：已禁用 `auto_install`，解析器由安装脚本统一安装
- **手动管理**：需要新语言支持时，运行 `:TSInstall <language>`

**Q: lazy-lock.json 是否应该提交到 Git**
- **答案**：是的，应该提交到版本控制
- **用途**：锁定插件版本，确保多环境一致性
- **更新**：主动更新插件后（`:Lazy update`），提交新的 lockfile

