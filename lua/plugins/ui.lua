-- ==========================================
-- 界面和主题插件配置
-- ==========================================

return {
  -- ==========================================
  -- Solarized8 主题
  -- ==========================================
  {
    "lifepillar/vim-solarized8",
    lazy = false,    -- 立即加载
    priority = 1000, -- 最高优先级
    config = function()
      -- 主题设置
      vim.o.background = "dark"
      vim.o.termguicolors = true
      vim.cmd("colorscheme solarized8")

      -- 自定义高亮设置（来自 vimrc 第 29-41 行）
      vim.cmd([[
        " 标记列背景与行号一致
        hi! link SignColumn LineNr
        hi! link ShowMarksHLl DiffAdd
        hi! link ShowMarksHLu DiffChange

        " 拼写检查高亮（使用下划线而非红色背景）
        highlight clear SpellBad
        highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
        highlight clear SpellCap
        highlight SpellCap term=underline cterm=underline
        highlight clear SpellRare
        highlight SpellRare term=underline cterm=underline
        highlight clear SpellLocal
        highlight SpellLocal term=underline cterm=underline
      ]])
    end,
  },

  -- ==========================================
  -- bufferline（Buffer 标签页）
  -- ==========================================
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
      },
    },
  },

  -- ==========================================
  -- Lualine 状态栏（替代 vim-airline）
  -- ==========================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "solarized_dark",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              file_status = true,
              path = 1, -- 相对路径
            }
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { "nvim-tree", "quickfix" },
      })
    end,
  },

  -- ==========================================
  -- nvim-web-devicons（图标支持）
  -- ==========================================
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- ==========================================
  -- Treesitter（语法高亮，替代 vim-polyglot）
  -- ==========================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- 添加错误保护，防止插件未安装时报错
      local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter not installed yet, skipping configuration", vim.log.levels.WARN)
        return
      end

      treesitter_configs.setup({
        -- 安装的语言解析器（精简为常用语言，其他可按需 :TSInstall）
        ensure_installed = {
          "lua",       -- Neovim 配置
          "vim",       -- Vim 配置
          "vimdoc",    -- Vim 文档
          "python",    -- Python
          "javascript",-- JavaScript
          "bash",      -- Shell 脚本
          "markdown",  -- Markdown
          "markdown_inline",
          "json",      -- JSON 配置
          "yaml",      -- YAML 配置
        },

        -- 自动安装缺失的解析器
        auto_install = true,

        -- 语法高亮
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- 缩进
        indent = {
          enable = true,
        },

        -- 增量选择
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
          },
        },
      })
    end,
  },

  -- ==========================================
  -- rainbow-delimiters（彩虹括号，现代版本）
  -- ==========================================
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- 添加错误保护，防止插件未安装时报错
      local ok, rainbow_delimiters = pcall(require, "rainbow-delimiters")
      if not ok then
        vim.notify("rainbow-delimiters not installed yet, skipping configuration", vim.log.levels.WARN)
        return
      end

      -- 设置彩虹括号颜色（Solarized Dark 主题适配）
      vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#dc322f" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#b58900" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#268bd2" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#cb4b16" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#859900" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#6c71c4" })
      vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#2aa198" })

      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },

  -- ==========================================
  -- indent-blankline（缩进线显示）
  -- ==========================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "notify",
          "NvimTree",
          "Trouble",
          "trouble",
        },
        buftypes = {
          "terminal",
          "nofile",
        },
      },
    },
  },

  -- ==========================================
  -- todo-comments（TODO/FIXME 高亮和搜索）
  -- ==========================================
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },

  -- ==========================================
  -- nvim-colorizer（颜色代码高亮）
  -- ==========================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
      },
      buftypes = {},
    },
  },

  -- ==========================================
  -- which-key（快捷键提示）
  -- ==========================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 500,
      icons = {
        mappings = true,
        keys = {},
      },
      spec = {
        { "<leader>f", group = "find/file" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunk" },
        { "<leader>t", group = "toggle" },
        { "<leader>x", group = "trouble/diagnostics" },
        { "<leader>c", group = "code" },
        { "<leader>s", group = "search/select" },
        { "<leader>b", group = "buffer" },
      },
    },
  },
}
