-- ==========================================
-- 代码片段配置（LuaSnip）
-- ==========================================

return {
  -- ==========================================
  -- LuaSnip（代码片段引擎）
  -- ==========================================
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
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

      -- 延迟加载友好片段（按文件类型）
      require("luasnip.loaders.from_vscode").lazy_load()

      -- 延迟加载自定义片段（从 snippets/ 目录）
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/snippets",
      })

      -- 快捷键配置
      vim.keymap.set({ "i", "s" }, "<leader>us", function()
        require("luasnip.loaders").edit_snippet_files()
      end, { desc = "Edit snippets" })
    end,
  },

  -- ==========================================
  -- friendly-snippets（常用代码片段集合）
  -- ==========================================
  { "rafamadriz/friendly-snippets", lazy = true },
}
