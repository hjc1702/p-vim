# 项目状态

**日期**: 2026-02-04
**状态**: ✅ 轻量配置稳定可用

## 🎯 当前方向

- 精简为轻量编辑器体验
- 保留语法高亮、搜索、片段、轻量补全
- 移除 LSP / Lint / Format / Mason 相关能力

## ✅ 已完成调整

- 删除 `plugins.ide` 以及 LSP/Lint/Format 体系
- 移除 Mason 与相关 PATH 注入
- 保留并恢复：`nvim-cmp`（无 LSP）、`LuaSnip`
- 修复 `nvim-autopairs` 对 `cmp` 的可选依赖
- 关键文档与安装脚本已对齐当前配置

## 🗂️ 当前结构

```
p-vim/
├── init.lua
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

## ✨ 仍然保留的核心能力

- 语法高亮（Treesitter）
- 模糊搜索（Telescope）
- 文件树（nvim-tree）
- 代码片段（LuaSnip + friendly-snippets）
- 轻量补全（nvim-cmp：buffer/path/cmdline/snippet）
- Git 集成（gitsigns）
- 编辑增强（autopairs/surround/comment/trailspace）

## 🧹 已移除能力

- LSP（nvim-lspconfig / pyright / lua_ls 等）
- Mason 及其工具管理
- Lint / Format（nvim-lint / conform）
- LSP 调试与自动启动机制

