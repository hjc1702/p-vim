# LSP 问题排查和解决报告

**日期**: 2026-02-02
**问题**: `,jd` 快捷键不生效，LSP 无法启动

## 🔍 问题排查过程

### 问题 1: capabilities 未传递
**现象**: LSP 配置存在但未启动
**原因**: vim.lsp.config 中缺少 capabilities 配置
**解决**: 在 pyright 和 lua_ls 配置中添加 `capabilities = capabilities`

### 问题 2: pyright-langserver 命令找不到
**现象**: Exit code 127 - command not found
**原因**: Neovim 的 PATH 环境变量中没有包含 Mason 的 bin 目录
**解决**: 在 `lua/config/options.lua` 中添加：
```lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

### 问题 3: LSP 未自动启动
**现象**: 手动 `:LspStart pyright` 可以工作，但不会自动启动
**原因**: vim.lsp.enable() 调用时机和事件触发时机不匹配
**解决**: 添加多个自动命令和 ftplugin 文件确保自动启动

### 问题 4: 新文件 LSP 不生效
**现象**: 已存在文件 LSP 正常，新建文件 LSP 不启动
**原因**: 新文件的文件类型设置时机不同
**解决**:
1. 添加 BufEnter 和 BufWritePost 事件监听
2. 创建 `after/ftplugin/python.lua` 和 `after/ftplugin/lua.lua`
3. 使用延迟启动确保配置已加载

## ✅ 最终解决方案

### 修改的文件

1. **lua/config/options.lua**
   - 添加 Mason bin 目录到 PATH

2. **lua/plugins/ide.lua**
   - 添加 capabilities 到 LSP 配置
   - 添加多事件自动命令（FileType, BufEnter, BufWritePost）
   - 创建 auto_start_lsp() 辅助函数

3. **after/ftplugin/python.lua** (新建)
   - 文件类型插件，确保 Python 文件总是启动 pyright

4. **after/ftplugin/lua.lua** (新建)
   - 文件类型插件，确保 Lua 文件总是启动 lua_ls

### 核心代码片段

**PATH 设置 (options.lua)**:
```lua
-- 添加 Mason 的 bin 目录到 PATH
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

**LSP 配置 (ide.lua)**:
```lua
-- Python LSP 配置
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  capabilities = capabilities,  -- 关键：添加 capabilities
  -- ...
}

-- 自动启动函数
local function auto_start_lsp()
  local ft = vim.bo.filetype
  if ft == "python" or ft == "lua" then
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      if ft == "python" then
        vim.cmd("LspStart pyright")
      elseif ft == "lua" then
        vim.cmd("LspStart lua_ls")
      end
    end
  end
end

-- 多事件监听
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua" },
  callback = auto_start_lsp,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  pattern = { "*.py", "*.lua" },
  callback = function()
    vim.defer_fn(auto_start_lsp, 100)
  end,
})
```

**文件类型插件 (after/ftplugin/python.lua)**:
```lua
local clients = vim.lsp.get_clients({ bufnr = 0 })
if #clients == 0 then
  vim.defer_fn(function()
    vim.cmd("silent! LspStart pyright")
  end, 200)
end
```

## 🎯 验证结果

所有场景均已测试通过：

- ✅ 打开已存在的 Python 文件 → LSP 自动启动
- ✅ 创建新的 Python 文件 → LSP 自动启动
- ✅ 新文件保存后 → LSP 自动启动
- ✅ 打开 Lua 配置文件 → LSP 自动启动
- ✅ `,jd` 跳转到定义正常工作
- ✅ `K` 显示文档正常工作
- ✅ 代码补全正常工作

## 📚 相关 LSP 快捷键

现在所有 LSP 快捷键都应该正常工作：

| 快捷键 | 功能 | 描述 |
|--------|------|------|
| `,jd` | 跳转到定义 | vim.lsp.buf.definition |
| `,gd` | 跳转到声明 | vim.lsp.buf.declaration |
| `K` | 显示文档 | vim.lsp.buf.hover |
| `gi` | 查看实现 | vim.lsp.buf.implementation |
| `gr` | 查看引用 | vim.lsp.buf.references |
| `,rn` | 重命名 | vim.lsp.buf.rename |
| `,ca` | 代码操作 | vim.lsp.buf.code_action |
| `,fm` | 格式化 | vim.lsp.buf.format |
| `,l` | 手动触发 linting | lint.try_lint |
| `,a` | 格式化文件 | conform.format |

## 🔧 调试工具

已创建的调试工具：

1. **:LspDebug** 或 `,ld` - 显示 LSP 诊断信息
2. **:LspInfo** - 查看 LSP 状态
3. **:Mason** - 管理 LSP 服务器
4. **/tmp/lsp_diag.lua** - 详细诊断脚本

## 📊 技术细节

### Neovim 版本
- 版本: 0.11.6
- LSP API: vim.lsp.config (新 API)

### 已安装的 LSP 服务器
- pyright (Python)
- lua_ls (Lua)
- gopls (Go) - 已安装但未配置
- rust_analyzer (Rust) - 已安装但未配置
- taplo (TOML)
- vue_ls (Vue)

### Mason 路径
- bin 目录: `~/.local/share/nvim/mason/bin/`
- 数据目录: `~/.local/share/nvim/mason/`

## 🎓 经验总结

### 关键点

1. **PATH 环境变量很重要** - 确保 Neovim 能找到 LSP 服务器命令
2. **capabilities 必须传递** - 否则补全功能不完整
3. **自动启动需要多重保障** - FileType 事件 + ftplugin
4. **新文件处理特殊** - 需要额外的事件监听
5. **延迟启动很有用** - 确保配置已完全加载

### 最佳实践

1. 使用 Mason 统一管理 LSP 服务器
2. 使用 vim.lsp.config API (Neovim 0.11+)
3. 创建 ftplugin 文件确保可靠启动
4. 添加调试命令方便排查问题
5. 文档化配置和快捷键

## 🎉 结论

LSP 配置现已完全正常工作，包括：
- ✅ 自动启动机制
- ✅ 所有快捷键功能
- ✅ 代码补全和诊断
- ✅ 新文件和已存在文件均支持

配置已经稳定可用于日常开发！
