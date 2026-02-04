-- ==========================================
-- 编辑增强插件配置
-- ==========================================

return {
  -- ==========================================
  -- nvim-autopairs（括号自动补全，替代 delimitMate）
  -- ==========================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = true, -- 使用 treesitter
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- 与 nvim-cmp 集成（若未安装则跳过）
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- ==========================================
  -- nvim-surround（包围符号操作，替代 vim-surround）
  -- ==========================================
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- 配置参数
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
        surrounds = {
          -- 自定义包围符号
          ["("] = { add = { "(", ")" } },
          [")"] = { add = { "( ", " )" } },
          ["{"] = { add = { "{", "}" } },
          ["}"] = { add = { "{ ", " }" } },
          ["["] = { add = { "[", "]" } },
          ["]"] = { add = { "[ ", " ]" } },
          ["<"] = { add = { "<", ">" } },
          [">"] = { add = { "< ", " >" } },
        },
      })
    end,
  },

  -- ==========================================
  -- Comment.nvim（注释，替代 nerdcommenter）
  -- ==========================================
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup({
        -- 基础配置
        padding = true,
        sticky = true,
        ignore = nil,

        -- LHS 映射配置
        toggler = {
          line = "gcc",  -- 行注释切换
          block = "gbc", -- 块注释切换
        },

        -- 操作模式映射
        opleader = {
          line = "gc",
          block = "gb",
        },

        -- 额外映射
        extra = {
          above = "gcO", -- 在上方添加注释
          below = "gco", -- 在下方添加注释
          eol = "gcA",   -- 在行尾添加注释
        },

        -- 映射配置
        mappings = {
          basic = true,
          extra = true,
        },

        -- Pre-hook 和 Post-hook（用于 Treesitter 集成）
        pre_hook = function(ctx)
          -- 懒加载，避免加载顺序问题
          local U = require("Comment.utils")
          local ts_utils = require("ts_context_commentstring.utils")
          local ts_internal = require("ts_context_commentstring.internal")

          -- 计算注释字符串
          local location = nil
          if ctx.ctype == U.ctype.blockwise then
            location = ts_utils.get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = ts_utils.get_visual_start_location()
          end

          return ts_internal.calculate_commentstring({
            key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
            location = location,
          })
        end,
        post_hook = nil,
      })
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  -- ==========================================
  -- nvim-ts-context-commentstring（上下文感知注释）
  -- ==========================================
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },

  -- ==========================================
  -- mini.trailspace（尾部空格，替代 vim-trailing-whitespace）
  -- ==========================================
  {
    "echasnovski/mini.trailspace",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader><space>",
        "<cmd>lua MiniTrailspace.trim()<CR>",
        desc = "Trim trailing whitespace"
      },
    },
    config = function()
      require("mini.trailspace").setup({
        -- 只在特定文件类型中高亮尾部空格
        only_in_normal_buffers = true,
      })

      -- 高亮配置（使用红色背景）
      vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "#592929" })
    end,
  },

  -- ==========================================
  -- vim-tmux-navigator（Tmux 集成）
  -- ==========================================
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
    },
  },
}
