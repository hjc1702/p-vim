-- ==========================================
-- 集成插件配置
-- ==========================================

return {
  -- ==========================================
  -- orgmode（Org-mode 支持，Lua 版本）
  -- ==========================================
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    -- 只在打开 .org 文件时加载，避免影响启动速度
    ft = { "org" },
    config = function()
      -- orgmode 配置
      require("orgmode").setup({
        org_agenda_files = "~/org/**/*",
        org_default_notes_file = "~/org/notes.org",

        -- 快捷键配置
        mappings = {
          -- 全局快捷键
          global = {
            org_agenda = "gA",
            org_capture = "gC",
          },
          -- Org 文件内快捷键
          org = {
            org_timestamp_up = "+",
            org_timestamp_down = "-",
            org_change_date = "cid",
            org_todo = "cit",
            org_toggle_checkbox = "<C-space>",
            org_open_at_point = "<CR>",
            org_cycle = "<TAB>",
            org_global_cycle = "<S-TAB>",
            org_archive_subtree = "<leader>o$",
            org_set_tags_command = "<leader>ot",
            org_toggle_archive_tag = "<leader>oA",
            org_do_promote = "<<",
            org_do_demote = ">>",
            org_promote_subtree = "<s",
            org_demote_subtree = ">s",
            org_meta_return = "<leader><CR>",
            org_insert_heading_respect_content = "<leader>oh",
            org_insert_todo_heading = "<leader>oT",
            org_move_subtree_up = "<leader>oK",
            org_move_subtree_down = "<leader>oJ",
            org_export = "<leader>oe",
            org_next_visible_heading = "}",
            org_previous_visible_heading = "{",
            org_forward_heading_same_level = "]]",
            org_backward_heading_same_level = "[[",
            outline_up_heading = "g{",
          },
        },

        -- 其他配置
        org_startup_indented = true,
        org_adapt_indentation = true,
        org_hide_leading_stars = true,
        org_startup_folded = "showeverything",
        org_ellipsis = " ▼",

        -- 时间格式
        org_time_stamp_custom_formats = {
          active = "<%Y-%m-%d %a>",
          inactive = "[%Y-%m-%d %a]",
        },

        -- 高亮配置
        org_highlight_latex_and_related = "entities",

        -- Agenda 视图配置
        org_agenda_templates = {
          T = {
            description = "Todo",
            template = "* TODO %?\n  %u",
          },
          n = {
            description = "Note",
            template = "* %?\n  %u",
          },
        },
      })
    end,
  },
}
