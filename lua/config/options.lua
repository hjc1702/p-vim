-- ==========================================
-- 编辑器基础配置
-- 从 vimrc 迁移到 Lua
-- ==========================================

local opt = vim.opt
local g = vim.g

-- ==========================================
-- 禁用不需要的远程插件提供者
-- ==========================================

-- 禁用 Node.js provider（如不使用 Node.js 插件）
g.loaded_node_provider = 0

-- 禁用 Perl provider（如不使用 Perl 插件）
g.loaded_perl_provider = 0

-- 禁用 Ruby provider（如不使用 Ruby 插件）
g.loaded_ruby_provider = 0

-- Python provider 保持启用（用于部分插件）
-- g.loaded_python3_provider = 0  -- 如需禁用可取消注释

-- ==========================================
-- 基础设置
-- ==========================================

-- 历史记录容量
opt.history = 2000

-- 文件类型检测（Neovim 0.11+ 默认已启用）

-- 文件修改后自动载入
opt.autoread = true

-- 启动时不显示援助提示
opt.shortmess:append("atI")

-- 备份和交换文件
opt.backup = false
opt.swapfile = false
opt.writebackup = false

-- 忽略的文件
opt.wildignore = "*.swp,*.bak,*.pyc,*.class,.svn"

-- 鼠标设置（禁用）
opt.mouse = ""

-- 选择模式
opt.selection = "inclusive"
opt.selectmode = "mouse,key"

-- 终端标题
opt.title = true

-- 关闭错误提示音
opt.visualbell = false
opt.errorbells = false
opt.timeoutlen = 500

-- Neovim 使用 shada 替代 viminfo
opt.shada = "'100,<50,s10,h"

-- 正则表达式 magic 模式
opt.magic = true

-- Backspace 行为
opt.backspace = "eol,start,indent"
opt.whichwrap:append("<,>,h,l")

-- ==========================================
-- 显示设置
-- ==========================================

-- 显示行列号
opt.ruler = true
opt.showcmd = true
opt.showmode = true

-- 滚动边界
opt.scrolloff = 7

-- 状态栏
opt.laststatus = 2

-- 行号
opt.number = true
opt.relativenumber = true

-- 不自动换行
opt.wrap = false

-- 括号匹配
opt.showmatch = true
opt.matchtime = 2

-- GUI 字体设置（仅对 GUI 版本生效，如 Neovide）
-- 终端版本需要在终端设置中修改字体
opt.guifont = "Maple Mono NF CN:h14"

-- ==========================================
-- 搜索设置
-- ==========================================

-- 高亮搜索结果
opt.hlsearch = true
-- 增量搜索
opt.incsearch = true
-- 忽略大小写
opt.ignorecase = true
-- 智能大小写
opt.smartcase = true

-- ==========================================
-- 代码折叠
-- ==========================================

opt.foldenable = true
opt.foldmethod = "indent"
opt.foldlevel = 99

-- ==========================================
-- 缩进设置
-- ==========================================

opt.smartindent = true
opt.autoindent = true

-- Tab 设置
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smarttab = true
opt.expandtab = true
opt.shiftround = true

-- ==========================================
-- 其他设置
-- ==========================================

opt.hidden = true
opt.wildmode = "list:longest"
opt.wildmenu = true

-- 数字格式（十进制）
opt.nrformats = ""

-- 防止 tmux 下背景色异常（Neovim 不需要此设置）
-- Neovim 自动处理终端颜色

-- ==========================================
-- 文件编码
-- ==========================================

-- Neovim 默认使用 UTF-8，encoding 选项为只读
opt.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"
opt.helplang = "cn"

-- ==========================================
-- 语法高亮
-- ==========================================

-- Neovim 默认已启用语法高亮，无需手动开启

-- 注释斜体（现代终端已原生支持，无需设置转义序列）
vim.cmd([[
  highlight Comment cterm=italic gui=italic
]])

-- ==========================================
-- 补全设置
-- ==========================================

-- 补全选项（不显示预览窗口）
opt.completeopt = "menu,menuone,noselect"

-- 补全菜单高度
opt.pumheight = 15
