-- ==========================================
-- 导航插件配置
-- ==========================================

return {
  -- ==========================================
  -- nvim-tree（文件树，替代 NERDTree）
  -- ==========================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    },
    config = function()
      -- 禁用 netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- 视图配置
        view = {
          width = 30,
          side = "left",
        },

        -- 渲染配置
        renderer = {
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "name",
          root_folder_label = ":~:s?$?/..?",
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },

        -- 过滤配置（类似 NERDTree 的 ignore）
        filters = {
          dotfiles = false,
          custom = {
            "^\\.git$",
            "^\\.svn$",
            "^\\.hg$",
            "\\.pyc$",
            "\\.pyo$",
            "\\.o$",
            "\\.so$",
            "\\.egg$",
          },
        },

        -- 文件操作配置
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
            },
          },
        },

        -- Git 集成
        git = {
          enable = true,
          ignore = false,
        },

        -- 自动关闭（类似 NERDTree 的行为）
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })

      -- 当只剩 nvim-tree 窗口时自动关闭（类似 NERDTree）
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and
              require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd "quit"
          end
        end
      })
    end,
  },

  -- ==========================================
  -- Telescope（模糊搜索，替代 CtrlP + CtrlSF）
  -- ==========================================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    cmd = "Telescope",
    keys = {
      -- 文件搜索（替代 CtrlP）
      { "<leader>p", "<cmd>Telescope find_files<CR>", desc = "Find files" },

      -- Git 文件搜索（只搜索 Git 跟踪的文件）
      { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git files" },

      -- 最近文件（替代 CtrlP MRU）
      { "<leader>f", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },

      -- 函数/符号导航（替代 CtrlP-Funky）
      { "<leader>fu", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },

      -- 光标下单词的函数导航
      {
        "<leader>fU",
        function()
          require("telescope.builtin").lsp_document_symbols({
            default_text = vim.fn.expand("<cword>")
          })
        end,
        desc = "Symbols under cursor"
      },

      -- 全局搜索（替代 CtrlSF）
      { "\\", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },

      -- Buffer 列表
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },

      -- 诊断列表
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },

      -- 命令历史
      { "<leader>fh", "<cmd>Telescope command_history<CR>", desc = "Command history" },

      -- 搜索历史
      { "<leader>fs", "<cmd>Telescope search_history<CR>", desc = "Search history" },

      -- 快捷键列表
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- 布局配置
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
              preview_width = 0.55,
              results_width = 0.8,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- 快捷键映射（使用 Ctrl-j/k 导航）
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,
            },
          },

          -- 文件忽略配置（类似 CtrlP）
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "%.pyc",
            "%.class",
            "%.o",
            "%.so",
            "%.dll",
            "%.zip",
            "%.tar",
            "%.tar.gz",
          },

          -- 排序策略
          sorting_strategy = "ascending",

          -- 其他配置
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
        },

        pickers = {
          -- 文件搜索配置
          find_files = {
            hidden = false,
            follow = true,
          },

          -- 最近文件配置
          oldfiles = {
            cwd_only = false,
          },

          -- Live grep 配置
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- 加载 fzf 扩展
      telescope.load_extension("fzf")
    end,
  },

  -- ==========================================
  -- Aerial（代码结构导航，替代 Tagbar）
  -- ==========================================
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<F9>", "<cmd>AerialToggle!<CR>", desc = "Toggle code outline" },
    },
    config = function()
      require("aerial").setup({
        -- 布局配置
        layout = {
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 20,
          default_direction = "prefer_right",
          placement = "edge",
        },

        -- 显示配置
        show_guides = true,
        guides = {
          mid_item = "├─",
          last_item = "└─",
          nested_top = "│ ",
          whitespace = "  ",
        },

        -- 自动聚焦
        autojump = false,
        focus_on_toggle = true,

        -- 高亮配置
        highlight_on_hover = true,
        highlight_on_jump = 300,

        -- 过滤配置
        filter_kind = false,

        -- 图标配置
        icons = {},

        -- 自动打开配置
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
    end,
  },

  -- ==========================================
  -- Flash（快速跳转，替代 EasyMotion）
  -- ==========================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      -- 快速跳转（简化为单一快捷键）
      {
        "s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash jump"
      },

      -- 快速选择 Treesitter 节点
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },

      -- 搜索模式下的 Flash（可选）
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
    config = function()
      require("flash").setup({
        labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ;",
        search = {
          multi_window = true,
          forward = true,
          wrap = true,
          mode = "exact",
          incremental = false,
        },
        jump = {
          jumplist = true,
          pos = "start",
          history = false,
          register = false,
          nohlsearch = true,
          autojump = false,
        },
        label = {
          uppercase = true,
          rainbow = {
            enabled = false,
          },
        },
        modes = {
          search = {
            enabled = false,
          },
          char = {
            enabled = false,
          },
        },
      })
    end,
  },

  -- ==========================================
  -- trouble.nvim（更好的诊断列表）
  -- ==========================================
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {
      use_diagnostic_signs = true,
    },
  },

  -- ==========================================
  -- gitsigns（Git 集成）
  -- ==========================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 1000,
          ignore_whitespace = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "Diff this ~" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },
}
