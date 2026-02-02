-- ==========================================
-- 自动命令配置
-- ==========================================

-- ==========================================
-- 相对行号管理（根据模式切换）
-- ==========================================

-- 插入模式下使用绝对行号（方便查看当前位置）
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = false
    vim.opt.number = true
  end,
})

-- 退出插入模式使用相对行号
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- ==========================================
-- 文件类型特定配置
-- ==========================================

-- Python 文件配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
  end,
})

-- Ruby, JavaScript, HTML, CSS, XML 文件配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "javascript", "html", "css", "xml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
  end,
})

-- Markdown 文件类型
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.md", "*.mkd", "*.markdown" },
  callback = function()
    vim.bo.filetype = "markdown.mkd"
  end,
})

-- Vue 文件配置
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.vue",
  callback = function()
    vim.bo.filetype = "vue.html.javascript"
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
  end,
})

-- HTML part 文件
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.part",
  callback = function()
    vim.bo.filetype = "html"
  end,
})

-- PHP 文件：禁用 <> 括号匹配
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.php",
  callback = function()
    vim.opt_local.matchpairs:remove("<:>")
  end,
})

-- ==========================================
-- 保存时清理尾部空格
-- ==========================================

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.java", "*.php", "*.js", "*.py", "*.rs", "*.xml", "*.yml", "*.perl" },
  callback = function()
    require("config.functions").strip_trailing_whitespaces()
  end,
})

-- ==========================================
-- 新建文件自动插入文件头
-- ==========================================

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.sh", "*.py" },
  callback = function()
    require("config.functions").auto_set_file_head()
  end,
})

-- ==========================================
-- Python 文件特殊处理
-- ==========================================

-- Python 文件中 # 号注释不回到行首
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.py",
  callback = function()
    vim.keymap.set('i', '#', 'X<c-h>#', { buffer = true, noremap = true })
  end,
})

-- ==========================================
-- 自动跳转到上次编辑位置
-- ==========================================

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- ==========================================
-- 高亮关键字（TODO, FIXME 等）
-- ==========================================

vim.api.nvim_create_autocmd("Syntax", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("Todo", [[\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)]])
    vim.fn.matchadd("Debug", [[\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)]])
  end,
})

-- ==========================================
-- Quickfix 窗口配置
-- ==========================================

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "quickfix",
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>', { buffer = true, noremap = true })
    vim.keymap.set('n', 'v', '<C-w><Enter><C-w>L', { buffer = true, noremap = true })
    vim.keymap.set('n', 's', '<C-w><Enter><C-w>K', { buffer = true, noremap = true })
  end,
})

-- ==========================================
-- 命令行窗口配置
-- ==========================================

vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.keymap.set('n', '<CR>', '<CR>', { buffer = true, noremap = true })
  end,
})
