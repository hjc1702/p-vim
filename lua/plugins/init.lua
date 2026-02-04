-- ==========================================
-- Lazy.nvim 插件管理器配置
-- ==========================================

-- 自动安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 加载所有插件配置
require("lazy").setup({
  -- 从各个模块加载插件
  { import = "plugins.ui" },           -- 界面插件（主题、状态栏、高亮）
  { import = "plugins.navigation" },   -- 导航插件（文件树、搜索、跳转）
  { import = "plugins.editing" },      -- 编辑增强插件
  { import = "plugins.cmp" },          -- 补全
  { import = "plugins.snippets" },     -- 代码片段
  { import = "plugins.integration" },  -- 集成插件（tmux、orgmode）
}, {
  -- lazy.nvim 配置选项
  ui = {
    -- 使用 Nerd Font 图标
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },

  -- 性能优化
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- 禁用不需要的内置插件
      disabled_plugins = {
        "gzip",
        "matchit",
        -- "matchparen",  -- 保留括号匹配，与 showmatch 配合使用
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- 不自动检查更新
  checker = {
    enabled = false,
    notify = false,
  },

  -- 不显示变更通知
  change_detection = {
    enabled = true,
    notify = false,
  },

  -- 禁用 luarocks 支持（当前配置不需要）
  rocks = {
    enabled = false,
  },
})
