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
  vim.g.auto_relativenumber = false
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

return M
