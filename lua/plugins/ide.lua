-- ==========================================
-- LSP 和补全系统配置
-- 替代 YouCompleteMe
-- ==========================================

return {
  -- ==========================================
  -- fidget.nvim（LSP 进度显示）
  -- ==========================================
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          render_limit = 16,
          -- 优化：加快进度消息消失速度
          done_ttl = 1,
          done_icon = "✓",
        },
      },
      notification = {
        window = {
          winblend = 0,
          border = "none",
        },
      },
    },
  },

  -- ==========================================
  -- Mason（LSP 服务器管理）
  -- ==========================================
  {
    "williamboman/mason.nvim",
    version = "~2.2",  -- 使用 v2.x 版本
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- 自动安装工具（延迟执行，确保注册表已刷新）
      local mr = require("mason-registry")

      -- 需要自动安装的工具列表
      local ensure_installed = {
        -- LSP Servers
        "lua-language-server",  -- lua_ls 的包名
        "pyright",
        "gopls",
        "rust-analyzer",
        "taplo",
        -- Linters
        "flake8",
        "eslint_d",
        -- Formatters
        "stylua",
        "black",
        "isort",
        "prettier",
      }

      local function install_tools()
        for _, tool in ipairs(ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok then
            if not p:is_installed() then
              vim.notify("Installing " .. tool, vim.log.levels.INFO)
              p:install()
            end
          end
        end
      end

      -- 等待注册表刷新后再安装
      if mr.refresh then
        mr.refresh(function()
          install_tools()
        end)
      else
        -- 如果 refresh 不可用，延迟执行
        vim.defer_fn(install_tools, 100)
      end
    end,
  },

  -- ==========================================
  -- Mason-lspconfig（桥接 Mason 和 lspconfig）
  -- ==========================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    lazy = true,
  },

  -- ==========================================
  -- nvim-lspconfig（LSP 配置）
  -- ==========================================
  {
    "neovim/nvim-lspconfig",
    -- 优化：延迟加载，只在真正编辑文件时才启动 LSP
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 先确保 mason-lspconfig 已加载
      local mason_lspconfig = require("mason-lspconfig")

      -- 设置自动安装的服务器
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",       -- Lua
          "pyright",      -- Python
          "gopls",        -- Go
          "rust_analyzer",-- Rust
          "taplo",        -- TOML
          -- Vue: 需要时通过 :Mason 手动安装 vue-language-server
        },
        automatic_installation = true,
      })

      -- LSP 快捷键（替代 YCM 的快捷键）
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- 跳转到定义（,jd）
        vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts)

        -- 跳转到声明（,gd）
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, opts)

        -- Hover 文档（K）
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- 查看实现
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

        -- 查看引用
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- 重命名
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        -- 代码操作
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- 格式化
        vim.keymap.set("n", "<leader>fm", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- 诊断导航
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        -- 显示诊断浮动窗口
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

        -- 诊断列表
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

        -- 签名帮助（使用 <leader>k 避免与窗口导航冲突）
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
      end

      -- LSP 能力配置（用于补全）
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 诊断配置
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- ==========================================
      -- 使用新的 vim.lsp.config API (Neovim 0.11+)
      -- ==========================================

      -- Python LSP 配置（pyright）
      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- 优化：只检查打开的文件，避免扫描整个工作区
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      }

      -- Lua LSP 配置（lua_ls）
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- 优化：只加载必要的 Vim API 文件，大幅减少索引时间
              library = {
                vim.env.VIMRUNTIME .. "/lua",
                vim.fn.stdpath("config") .. "/lua",
              },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- 启用 LSP 服务器
      vim.lsp.enable({ "pyright", "lua_ls" })

      -- Go LSP 配置（gopls）
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

      -- Rust LSP 配置（rust_analyzer）
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json" },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      }

      -- TOML LSP 配置（taplo）
      vim.lsp.config.taplo = {
        cmd = { "taplo", "lsp", "stdio" },
        filetypes = { "toml" },
        root_markers = { "*.toml" },
        capabilities = capabilities,
      }

      -- Vue LSP 配置（volar/vue-language-server，Vue 3 推荐）
      -- 注意：需要通过 :Mason 手动安装 vue-language-server
      -- 安装后会自动检测 .vue 文件并启动
      vim.lsp.config['vue-language-server'] = {
        cmd = { "vue-language-server", "--stdio" },
        filetypes = { "vue" },
        root_markers = { "package.json", "vue.config.js" },
        capabilities = capabilities,
        init_options = {
          typescript = {
            tsdk = "",  -- 如果需要，设置 TypeScript SDK 路径
          },
        },
      }

      -- 启用所有配置的 LSP 服务器
      -- 注意：只有当文件类型匹配时，LSP 才会启动
      vim.lsp.enable({ "pyright", "lua_ls", "gopls", "rust_analyzer", "taplo" })
      -- vue-language-server 需要手动启动或通过 ftplugin 启动

      -- 设置回调和能力
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            on_attach(client, args.buf)
          end
        end,
      })

      -- 注意：LSP 自动启动由 after/ftplugin/*.lua 文件处理
      -- 这样更可靠，避免重复启动
    end,
  },

  -- ==========================================
  -- nvim-cmp（补全引擎，替代 YCM）
  -- ==========================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP 补全源
      "hrsh7th/cmp-buffer",       -- Buffer 补全源
      "hrsh7th/cmp-path",         -- 路径补全源
      "hrsh7th/cmp-cmdline",      -- 命令行补全源
      "L3MON4D3/LuaSnip",         -- 代码片段引擎
      "saadparwaiz1/cmp_luasnip", -- LuaSnip 补全源
      "onsails/lspkind.nvim",     -- 补全图标
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        -- 代码片段引擎
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- 窗口样式
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- 快捷键映射（保持与 YCM 类似的体验）
        mapping = cmp.mapping.preset.insert({
          -- Ctrl-j/k 导航（类似 YCM）
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),

          -- Ctrl-b/f 翻页
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Ctrl-Space 触发补全
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Ctrl-e 取消补全
          ["<C-e>"] = cmp.mapping.abort(),

          -- 回车确认（类似 YCM）
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tab 补全或跳转片段
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift-Tab 反向
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- 补全源配置
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),

        -- 格式化配置（使用 lspkind 显示图标）
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              return vim_item
            end,
          }),
        },

        -- 实验性功能
        experimental = {
          ghost_text = false,
        },
      })

      -- 命令行补全配置
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- ==========================================
  -- 补全源插件
  -- ==========================================
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },

  -- ==========================================
  -- lspkind（补全图标）
  -- ==========================================
  { "onsails/lspkind.nvim", lazy = true },

  -- ==========================================
  -- LuaSnip（代码片段引擎，替代 UltiSnips）
  -- ==========================================
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- 不构建 jsregexp，使用纯 Lua 实现
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local luasnip = require("luasnip")

      -- 基础配置
      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- 加载 friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- 加载自定义片段（从 snippets/ 目录）
      require("luasnip.loaders.from_lua").load({
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

  -- ==========================================
  -- nvim-lint（Linting，替代 ALE linting）
  -- ==========================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Linter 配置（类似 ALE）
      lint.linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint" },
      }

      -- flake8 参数配置（来自 vimrc.bundles 第 168 行）
      lint.linters.flake8.args = {
        "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
        "--no-show-source",
        "--ignore=E402,E501,E722,E731,E225,E203,E702,F811,F405,F403,W391,F401,W503,W504",
      }

      -- 自动 lint
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      -- 手动触发 lint
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting" })
    end,
  },

  -- ==========================================
  -- conform.nvim（代码格式化）
  -- ==========================================
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("conform").setup({
        -- 格式化器配置
        formatters_by_ft = {
          python = { "black", "isort" },  -- black 是现代 Python 项目标准
          lua = { "stylua" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          go = { "gofmt", "goimports" },
          rust = { "rustfmt" },
        },

        -- 格式化选项
        format_on_save = function(bufnr)
          -- 同步格式化，避免保存不完整的内容
          -- 增加 timeout 以处理大文件
          return {
            timeout_ms = 2000,
            lsp_fallback = true,
            async = false,
          }
        end,
      })

      -- Python 格式化快捷键（,a）（来自 vimrc.bundles 第 368 行）
      vim.keymap.set("n", "<leader>a", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format file" })

      -- Visual 模式格式化（,y）
      vim.keymap.set("v", "<leader>y", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format selection" })
    end,
  },
}
