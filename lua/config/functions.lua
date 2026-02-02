-- ==========================================
-- 自定义函数
-- ==========================================

local M = {}

-- ==========================================
-- 代码折叠切换
-- ==========================================
M.toggle_fold = function()
  if vim.g.fold_method == nil then
    vim.g.fold_method = 0
  end

  if vim.g.fold_method == 0 then
    vim.cmd("normal! zM")  -- 折叠所有
    vim.g.fold_method = 1
  else
    vim.cmd("normal! zR")  -- 展开所有
    vim.g.fold_method = 0
  end
end

-- ==========================================
-- 行号模式切换（相对/绝对）
-- ==========================================
M.number_toggle = function()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
    vim.opt.number = true
  else
    vim.opt.relativenumber = true
  end
end

-- ==========================================
-- 窗口缩放切换
-- ==========================================
M.zoom_toggle = function()
  if vim.t.zoomed == nil then
    vim.t.zoomed = 0
  end

  if vim.t.zoomed == 1 then
    vim.cmd(vim.t.zoom_winrestcmd)
    vim.t.zoomed = 0
  else
    vim.t.zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd("resize")
    vim.cmd("vertical resize")
    vim.t.zoomed = 1
  end
end

-- ==========================================
-- 清理尾部空格
-- ==========================================
M.strip_trailing_whitespaces = function()
  local save_cursor = vim.fn.getpos(".")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
end

-- ==========================================
-- 自动文件头插入
-- ==========================================
M.auto_set_file_head = function()
  local filetype = vim.bo.filetype

  if filetype == 'sh' or filetype == 'bash' then
    vim.fn.setline(1, "#!/bin/bash")
    vim.cmd("normal! G")
    vim.cmd("normal! o")
    vim.cmd("normal! o")
  elseif filetype == 'python' then
    vim.fn.setline(1, "# -*- coding: utf-8 -*-")
    vim.cmd("normal! G")
    vim.cmd("normal! o")
    vim.cmd("normal! o")
  end
end

-- ==========================================
-- Python LSP 重启（虚拟环境切换后使用）
-- ==========================================
M.restart_python_lsp = function()
  local clients = vim.lsp.get_clients({ name = "pyright" })

  if #clients == 0 then
    vim.notify("Python LSP 未运行", vim.log.levels.WARN)
    return
  end

  -- 停止所有 Python LSP 客户端
  for _, client in ipairs(clients) do
    client.stop()
  end

  vim.notify("正在重启 Python LSP...", vim.log.levels.INFO)

  -- 延迟重启
  vim.defer_fn(function()
    vim.cmd("LspStart pyright")
    vim.notify("Python LSP 已重启", vim.log.levels.INFO)
  end, 500)
end

-- 创建用户命令
vim.api.nvim_create_user_command("RestartPythonLsp", M.restart_python_lsp, {
  desc = "重启 Python LSP（虚拟环境切换后使用）"
})

-- 快捷键 ,lr (LSP Restart)
vim.keymap.set("n", "<leader>lr", M.restart_python_lsp, {
  desc = "重启 Python LSP",
  noremap = true,
  silent = true,
})

return M
