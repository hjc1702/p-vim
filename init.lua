-- ==========================================
-- Neovim 配置主入口
-- 使用 Lua 配置语言 + lazy.nvim 插件管理
-- ==========================================

-- 设置 Leader 键
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 加载基础配置
require("config.options") -- 编辑器基础设置
require("config.keymaps") -- 快捷键映射
require("config.autocmds") -- 自动命令

-- 加载插件系统
require("plugins")
