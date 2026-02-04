-- ==========================================
-- 快捷键映射配置
-- ==========================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==========================================
-- 基础映射
-- ==========================================

-- kj 替换 Esc
keymap('i', 'kj', '<Esc>', { noremap = true })

-- ; 映射到 : (快速进入命令行)
keymap('n', ';', ':', { noremap = true })

-- ==========================================
-- 禁用方向键（强制使用 hjkl）
-- ==========================================

keymap('', '<Left>', '<Nop>', opts)
keymap('', '<Right>', '<Nop>', opts)
keymap('', '<Up>', '<Nop>', opts)
keymap('', '<Down>', '<Nop>', opts)

-- 但在某些模式下方向键有特殊用途
keymap('n', '<Left>', ':bp<CR>', opts)  -- 上一个 buffer
keymap('n', '<Right>', ':bn<CR>', opts) -- 下一个 buffer

-- ==========================================
-- 长行移动（物理行 vs 显示行）
-- ==========================================

keymap('n', 'k', 'gk', { noremap = true })
keymap('n', 'gk', 'k', { noremap = true })
keymap('n', 'j', 'gj', { noremap = true })
keymap('n', 'gj', 'j', { noremap = true })

-- ==========================================
-- 窗口导航
-- ==========================================

-- 注意：<C-h/j/k/l> 窗口导航由 vim-tmux-navigator 插件提供
-- 见 lua/plugins/editing.lua

-- 窗口缩放
keymap('n', '<Leader>z', function() require('config.functions').zoom_toggle() end,
  { noremap = true, silent = true, desc = "Toggle window zoom" })

-- ==========================================
-- 行首行尾快速跳转
-- ==========================================

keymap('n', 'H', '^', { noremap = true })
keymap('n', 'L', '$', { noremap = true })

-- ==========================================
-- 搜索相关
-- ==========================================

-- Space 映射到 / (搜索)
keymap('n', '<space>', '/', { noremap = true })

-- 使用正则表达式搜索
keymap('n', '/', '/\\v', { noremap = true })
keymap('v', '/', '/\\v', { noremap = true })

-- 搜索结果居中显示
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)
keymap('n', '*', '*zz', opts)
keymap('n', '#', '#zz', opts)
keymap('n', 'g*', 'g*zz', opts)

-- 去掉搜索高亮
keymap('n', '<leader>/', ':nohls<CR>', opts)

-- ==========================================
-- 选择和编辑
-- ==========================================

-- 调整缩进后自动选中
keymap('v', '<', '<gv', { noremap = true })
keymap('v', '>', '>gv', { noremap = true })

-- Y 复制到行尾（与 D、C 保持一致）
keymap('n', 'Y', 'y$', { noremap = true })

-- 全选
keymap('n', '<Leader>sa', 'ggVG', opts)

-- 选中最后一次插入的内容
keymap('n', 'gv', '`[v`]', { noremap = true })

-- 选中代码块
keymap('n', '<leader>V', 'V`}', { noremap = true })

-- ==========================================
-- 文件操作
-- ==========================================

-- w!! 使用 sudo 保存文件
keymap('c', 'w!!', 'w !sudo tee >/dev/null %', { noremap = true })

-- 快速关闭当前窗口
keymap('n', '<leader>q', ':q<CR>', opts)

-- 快速保存当前文件
keymap('n', '<leader>w', ':w<CR>', opts)

-- ==========================================
-- 系统剪贴板
-- ==========================================

-- 从系统剪贴板粘贴
keymap('n', '<leader>v', '"+gp', { noremap = true })

-- 复制到系统剪贴板
keymap('v', '<leader>c', '"+y', { noremap = true })

-- ==========================================
-- 滚动
-- ==========================================

-- 加速滚动
keymap('n', '<C-e>', '2<C-e>', opts)
keymap('n', '<C-y>', '2<C-y>', opts)

-- ==========================================
-- 撤销/重做
-- ==========================================

-- U 映射到重做（更符合直觉）
keymap('n', 'U', '<C-r>', { noremap = true })

-- ==========================================
-- 自定义函数快捷键
-- ==========================================

-- 代码折叠切换
keymap('n', '<leader>zz', function() require('config.functions').toggle_fold() end,
  { noremap = true, desc = "Toggle fold all" })

-- 行号模式切换
keymap('n', '<C-n>', function() require('config.functions').number_toggle() end,
  { noremap = true, desc = "Toggle relative number" })

-- 切换彩虹括号
keymap('n', '<leader>tr', function()
  local ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')
  if ok then
    rainbow_delimiters.toggle(0)
  end
end, { noremap = true, desc = "Toggle rainbow delimiters" })

-- 注释快捷键（兼容旧习惯）
keymap('n', '<leader>c<space>', 'gcc', { remap = true, desc = "Comment toggle line" })
keymap('x', '<leader>c<space>', 'gc', { remap = true, desc = "Comment toggle (visual)" })

-- 说明：插件相关的快捷键在各自的插件配置文件中定义
-- 例如：
-- - <leader>n : NvimTree toggle (在 plugins/navigation.lua)
-- - <leader>p : Telescope find_files (在 plugins/navigation.lua)
-- - gcc : Comment toggle (在 plugins/editing.lua)
