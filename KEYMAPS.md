# Neovim 配置快捷键速查表

> Leader 键: `,` (逗号)
>
> 按下 `,` 后等待片刻，会显示 which-key 提示面板

## 📑 目录

- [基础操作](#基础操作)
- [窗口和导航](#窗口和导航)
- [文件和搜索](#文件和搜索)
- [编辑增强](#编辑增强)
- [Git 操作](#git-操作)
- [补全和代码片段](#补全和代码片段)
- [UI 切换](#ui-切换)
- [调试和工具](#调试和工具)

---

## 基础操作

### 模式切换

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `kj` | Insert | 退出插入模式（替代 Esc） |
| `;` | Normal | 进入命令行模式（映射到 :） |

### 移动和跳转

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `k` / `j` | Normal | 按显示行移动（自动换行） |
| `gk` / `gj` | Normal | 按物理行移动 |
| `H` | Normal | 跳转到行首（^） |
| `L` | Normal | 跳转到行尾（$） |
| `<Left>` | Normal | 上一个 buffer |
| `<Right>` | Normal | 下一个 buffer |
| `<C-e>` | Normal | 向下快速滚动（2x） |
| `<C-y>` | Normal | 向上快速滚动（2x） |
| `gs` | Normal/Visual | Flash 快速跳转到任意位置 ⚡ |
| `gS` | Normal/Visual | Flash 选择 Treesitter 节点 |

### 撤销重做

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `u` | Normal | 撤销 |
| `U` | Normal | 重做（映射到 Ctrl-r） |

### 搜索

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<space>` | Normal | 开始搜索（映射到 /） |
| `/` | Normal/Visual | 正则表达式搜索 |
| `n` | Normal | 下一个搜索结果（居中显示） |
| `N` | Normal | 上一个搜索结果（居中显示） |
| `*` | Normal | 向前搜索当前单词（居中） |
| `#` | Normal | 向后搜索当前单词（居中） |
| `g*` | Normal | 部分匹配搜索（居中） |
| `<leader>/` | Normal | 清除搜索高亮 |

---

## 窗口和导航

### 窗口导航（支持 Tmux）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<C-h>` | Normal | 向左导航（Tmux 集成） |
| `<C-j>` | Normal | 向下导航（Tmux 集成） |
| `<C-k>` | Normal | 向上导航（Tmux 集成） |
| `<C-l>` | Normal | 向右导航（Tmux 集成） |
| `<C-\>` | Normal | 切换到上一个窗口 |

### 窗口管理

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>z` | Normal | 最大化/还原当前窗口 |
| `<leader>q` | Normal | 关闭当前窗口 |

### 代码结构导航

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<F9>` | Normal | 切换代码大纲侧边栏（Aerial） |
| `{` | Normal | 上一个符号（在 Aerial 内） |
| `}` | Normal | 下一个符号（在 Aerial 内） |

---

## 文件和搜索

### 文件管理

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>n` | Normal | 切换文件树（NvimTree） 📁 |
| `<leader>w` | Normal | 保存当前文件 |
| `w!!` | Command | 使用 sudo 保存文件 |

### 文件搜索（Telescope）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>p` | Normal | 查找文件 🔍 |
| `<leader>gf` | Normal | Git 文件搜索 |
| `<leader>f` | Normal | 最近打开的文件 (MRU) |
| `<leader>fb` | Normal | Buffer 列表 |
| `<leader>fh` | Normal | 命令历史 |
| `<leader>fs` | Normal | 搜索历史 |
| `<leader>fk` | Normal | 快捷键列表 |

### 符号和函数导航

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>fu` | Normal | 文档符号导航（Treesitter） |
| `<leader>fU` | Normal | 搜索光标下单词的符号 |

### 内容搜索

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `\` | Normal | 全局搜索内容（Live grep） 🔎 |

---

## 编辑增强

### 选择和复制

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<` | Visual | 减少缩进并保持选中 |
| `>` | Visual | 增加缩进并保持选中 |
| `Y` | Normal | 复制到行尾（与 D、C 一致） |
| `<leader>sa` | Normal | 全选（ggVG） |
| `gv` | Normal | 重新选中最后插入的内容 |
| `<leader>V` | Normal | 选中代码块 |

### Treesitter 智能选择

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<CR>` | Normal/Visual | 初始化/增量选择节点 |
| `<TAB>` | Visual | 扩展选择范围 |
| `<S-TAB>` | Visual | 减少选择范围 |

### 剪贴板操作

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>v` | Normal | 从系统剪贴板粘贴 |
| `<leader>c` | Visual | 复制到系统剪贴板 |

### 注释（Comment.nvim）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `gcc` | Normal | 切换当前行注释 💬 |
| `gc` | Normal/Visual | 行注释操作符/切换注释 |
| `gbc` | Normal | 切换当前块注释 |
| `gb` | Normal/Visual | 块注释操作符/切换注释 |
| `gcO` | Normal | 在上方添加注释 |
| `gco` | Normal | 在下方添加注释 |
| `gcA` | Normal | 在行尾添加注释 |
| `<leader>c<space>` | Normal/Visual | 切换注释（兼容旧习惯） |

### 包围符号（nvim-surround）

| 按键 | 模式 | 功能描述 | 示例 |
|------|------|---------|------|
| `ys{motion}{char}` | Normal | 添加包围符号 | `ysiw"` - 给单词加引号 |
| `yss{char}` | Normal | 整行添加包围符号 | `yss)` - 给整行加括号 |
| `S{char}` | Visual | 添加包围符号 | 选中后 `S"` - 加引号 |
| `ds{char}` | Normal | 删除包围符号 | `ds"` - 删除引号 |
| `cs{old}{new}` | Normal | 修改包围符号 | `cs"'` - 双引号改单引号 |
| `<C-g>s` | Insert | 插入模式添加包围符号 | |

### 其他编辑

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<M-e>` | Insert | 快速包裹（Fast wrap） |
| `<leader><space>` | Normal | 清除尾部空格 |

---

## Git 操作

### Hunk 导航

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `]c` | Normal | 下一个 Git hunk |
| `[c` | Normal | 上一个 Git hunk |

### Hunk 操作

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>hs` | Normal/Visual | 暂存 hunk (stage) |
| `<leader>hr` | Normal/Visual | 重置 hunk (reset) |
| `<leader>hS` | Normal | 暂存整个 buffer |
| `<leader>hu` | Normal | 撤销暂存 hunk (undo) |
| `<leader>hR` | Normal | 重置整个 buffer |
| `<leader>hp` | Normal | 预览 hunk 🔍 |
| `<leader>hb` | Normal | 显示行 blame |
| `<leader>hd` | Normal | Diff 当前文件 |
| `<leader>hD` | Normal | Diff 对比 HEAD~ |

### Git 文本对象

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `ih` | Operator/Visual | 选择 hunk 文本对象 |

### Git 切换

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>tb` | Normal | 切换行 blame 显示 |
| `<leader>td` | Normal | 切换已删除行显示 |

---

## 补全和代码片段

### 补全菜单（nvim-cmp）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<C-j>` | Insert | 选择下一项 ⬇️ |
| `<C-k>` | Insert | 选择上一项 ⬆️ |
| `<C-b>` | Insert | 文档向上滚动 |
| `<C-f>` | Insert | 文档向下滚动 |
| `<C-Space>` | Insert | 触发补全 |
| `<C-e>` | Insert | 取消补全 |
| `<CR>` | Insert | 确认选择 |

### 代码片段（LuaSnip）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<Tab>` | Insert/Select | 展开/跳转到下一个占位符 |
| `<S-Tab>` | Insert/Select | 跳转到上一个占位符 |

### Telescope 内导航

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<C-j>` | Insert | 下一个选项 |
| `<C-k>` | Insert | 上一个选项 |
| `<C-n>` | Insert | 下一条历史 |
| `<C-p>` | Insert | 上一条历史 |
| `<Esc>` / `q` | Insert/Normal | 关闭 Telescope |

---

## UI 切换

### Buffer 管理（BufferLine）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `[b` | Normal | 上一个 buffer ⬅️ |
| `]b` | Normal | 下一个 buffer ➡️ |
| `<leader>bp` | Normal | 固定/取消固定 buffer |
| `<leader>bP` | Normal | 删除所有未固定的 buffers |
| `<leader>bo` | Normal | 删除其他 buffers |
| `<leader>br` | Normal | 删除右侧所有 buffers |
| `<leader>bl` | Normal | 删除左侧所有 buffers |

### 显示切换

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>zz` | Normal | 切换代码折叠（全部折叠/展开） |
| `<C-n>` | Normal | 切换相对/绝对行号 |
| `<leader>tr` | Normal | 切换彩虹括号 🌈 |

### TODO 注释

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `]t` | Normal | 下一个 TODO 注释 |
| `[t` | Normal | 上一个 TODO 注释 |
| `<leader>ft` | Normal | TODO 列表（Telescope） |
| `<leader>xt` | Normal | TODO 列表（Trouble） |

---

## 调试和工具

### 诊断（Trouble）

| 按键 | 模式 | 功能描述 |
|------|------|---------|
| `<leader>xx` | Normal | 切换诊断列表 |
| `<leader>xX` | Normal | 当前 buffer 诊断 |
| `<leader>xL` | Normal | Location List |
| `<leader>xQ` | Normal | Quickfix List |
| `<leader>fd` | Normal | 诊断列表（Telescope） |

---

## 快捷键分组说明

### Leader 键分组

- `<leader>f*` - 查找相关（find）
- `<leader>g*` - Git 相关
- `<leader>h*` - Git hunk 操作
- `<leader>b*` - Buffer 操作
- `<leader>x*` - 诊断和 Trouble
- `<leader>t*` - 切换功能（toggle）
- `<leader>c*` - 代码操作（注释等）
- `<leader>s*` - 选择相关
- `<leader>w/q` - 保存/退出

### 跳转键模式

- `[*` / `]*` - 上一个/下一个（通用模式）
- `[b` / `]b` - Buffer
- `[c` / `]c` - Git hunk
- `[t` / `]t` - TODO 注释

### 文本对象

- `ih` - Git hunk 文本对象

---

## 💡 使用技巧

1. **快捷键提示**: 按下 Leader 键 (`,`) 后等待，会自动显示 which-key 提示面板
2. **Telescope 预览**: 在 Telescope 中使用 `<C-j/k>` 导航，按 `<CR>` 打开文件
3. **Flash 跳转**: `gs` 后输入目标位置的字符标签即可快速跳转
4. **注释技巧**:
   - `gcc` 快速注释单行
   - `gc` + motion (如 `gcap` 注释段落)
   - Visual 模式选中后 `gc` 注释选区
5. **包围符号**:
   - `ysiw"` - 给当前单词加双引号
   - `cs"'` - 双引号改单引号
   - `ds"` - 删除引号
6. **Git 操作**:
   - `]c` / `[c` 快速浏览改动
   - `<leader>hp` 预览改动
   - `<leader>hs` 暂存改动

---

## 📚 相关文档

- 完整配置说明: [CLAUDE.md](CLAUDE.md)
- 项目说明: [README.md](README.md)
- Neovim 帮助: `:help` 或 `:Telescope help_tags`

---

**总计**: 约 150+ 个快捷键映射

**最后更新**: 2025-01
