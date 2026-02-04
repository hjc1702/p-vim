# 虚拟环境与 LSP 配置指南

> 已归档：当前版本已移除 LSP/Mason/Lint/Format，本文件仅保留历史记录。

## 🎯 问题说明

在使用虚拟环境时，LSP 可能遇到以下问题：

### Python 虚拟环境
- **问题**: pyright 需要找到正确的 Python 解释器和依赖包
- **场景**: 切换 venv、conda、poetry 等虚拟环境时

### Node 版本管理（nvm）
- **问题**: pyright-langserver 依赖 Node.js，切换版本可能导致 LSP 失效
- **场景**: 使用 `nvm use` 切换 Node 版本时

## ✅ 当前配置状态

### LSP 服务器来源
根据检查，系统中有两个 pyright 来源：

1. **Mason 安装**（推荐）
   - 路径: `~/.local/share/nvim/mason/bin/pyright-langserver`
   - 特点: 独立于系统 Node 版本，最稳定

2. **npm 全局安装**
   - 路径: `~/.nvm/versions/node/v20.19.0/bin/pyright-langserver`
   - 特点: 依赖当前 Node 版本，切换版本会失效

### PATH 配置
我们已经在 `lua/config/options.lua` 中配置：
```lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
```

这确保 **优先使用 Mason 安装的 LSP 服务器**。

## 🔧 解决方案

### 方案 1: 使用 Mason 安装（推荐）✨

**优点**:
- ✅ 完全独立于系统环境
- ✅ 不受 nvm 切换影响
- ✅ 统一管理所有 LSP 服务器
- ✅ 自动更新

**配置**: 已完成，无需额外配置

**验证**:
```vim
:Mason
" 确认 pyright 已安装（显示 ✓）
```

### 方案 2: Python 虚拟环境自动检测

为了让 pyright 正确识别虚拟环境，我们需要配置自动检测。

#### 创建项目配置文件

在项目根目录创建 `pyrightconfig.json`:

```json
{
  "venvPath": ".",
  "venv": ".venv"
}
```

或使用 `pyproject.toml`:

```toml
[tool.pyright]
venvPath = "."
venv = ".venv"
```

#### 动态检测虚拟环境（高级）

更新 `lua/plugins/ide.lua` 中的 pyright 配置：

```lua
-- 自动检测 Python 虚拟环境
local function get_python_path()
  -- 检查常见的虚拟环境
  local venv_paths = {
    vim.fn.getcwd() .. "/.venv/bin/python",
    vim.fn.getcwd() .. "/venv/bin/python",
    vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin/python",
    vim.fn.exepath("python3"),
    vim.fn.exepath("python"),
  }

  for _, path in ipairs(venv_paths) do
    if path and vim.fn.executable(path) == 1 then
      return path
    end
  end

  return "python3"
end

-- 在 pyright 配置中使用
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  capabilities = capabilities,
  root_markers = {
    "pyproject.toml", "setup.py", "setup.cfg",
    "requirements.txt", "Pipfile", "pyrightconfig.json",
    ".venv", "venv", ".git"
  },
  settings = {
    python = {
      pythonPath = get_python_path(),  -- 动态检测
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}
```

### 方案 3: 环境切换时重启 LSP

创建便捷命令来处理虚拟环境切换：

在 `lua/config/functions.lua` 中添加：

```lua
-- Python 虚拟环境切换后重启 LSP
M.restart_python_lsp = function()
  -- 停止所有 Python LSP 客户端
  for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
    client.stop()
  end

  -- 延迟重启
  vim.defer_fn(function()
    vim.cmd("LspStart pyright")
    print("Python LSP 已重启")
  end, 500)
end

-- 创建用户命令
vim.api.nvim_create_user_command("PythonLspRestart", M.restart_python_lsp, {})
```

使用方法：
```vim
" 激活虚拟环境后
:PythonLspRestart
```

## 📝 使用建议

### 日常工作流

#### Python 项目

1. **使用项目虚拟环境**
   ```bash
   cd your-project
   source .venv/bin/activate  # 或 conda activate
   nvim
   ```

2. **在项目根目录添加配置文件**
   - 推荐: `pyrightconfig.json` 或 `pyproject.toml`
   - 指定虚拟环境路径

3. **切换虚拟环境后**
   ```vim
   :PythonLspRestart
   " 或重新打开文件
   :e!
   ```

#### Node 项目

1. **使用 Mason 的 LSP 服务器**
   - Mason 的 pyright 不受 nvm 影响
   - 其他 Node-based LSP（如 typescript-language-server）也应通过 Mason 安装

2. **如果需要特定 Node 版本**
   - 确保在启动 Neovim 前切换到正确的 Node 版本
   - 或配置项目的 `.nvmrc` 文件

### 最佳实践

1. **优先使用 Mason** ✨
   ```vim
   :Mason
   " 安装所有需要的 LSP 服务器
   " pyright, lua_ls, typescript-language-server 等
   ```

2. **项目级配置**
   - 在每个 Python 项目根目录添加 `pyrightconfig.json`
   - 明确指定虚拟环境路径

3. **环境变量**
   - 在激活虚拟环境后启动 Neovim
   - Neovim 会继承环境变量 `VIRTUAL_ENV`

4. **使用 direnv**（可选）
   - 自动加载项目环境变量
   - 配合 `.envrc` 文件自动切换环境

## 🔍 验证和调试

### 检查 Python 路径

在 Neovim 中：
```vim
:lua print(vim.lsp.get_clients()[1].config.settings.python.pythonPath)
```

### 检查虚拟环境

```vim
:!which python
:!echo $VIRTUAL_ENV
```

### 查看 LSP 日志

```vim
:lua vim.cmd('edit ' .. vim.lsp.get_log_path())
" 搜索 python path 相关信息
```

### 测试导入

在 Python 文件中测试是否能正确识别虚拟环境的包：
```python
import some_package_in_venv  # 应该没有警告
```

## ⚙️ 高级配置

### 自动检测并通知

在 `lua/plugins/ide.lua` 中添加：

```lua
-- 检测虚拟环境变化并通知
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
      vim.notify("检测到虚拟环境: " .. venv, vim.log.levels.INFO)
      -- 可选：自动重启 LSP
      -- vim.defer_fn(function() vim.cmd("PythonLspRestart") end, 1000)
    end
  end,
})
```

### 多环境支持

对于使用多种虚拟环境工具的项目：

```lua
local function detect_venv()
  local markers = {
    { name = "poetry",  file = "pyproject.toml", cmd = "poetry env info -p" },
    { name = "pipenv",  file = "Pipfile",        cmd = "pipenv --venv" },
    { name = "conda",   env = "CONDA_DEFAULT_ENV" },
    { name = "venv",    dir = ".venv" },
    { name = "venv",    dir = "venv" },
  }

  for _, marker in ipairs(markers) do
    if marker.file and vim.fn.filereadable(marker.file) == 1 then
      if marker.cmd then
        local handle = io.popen(marker.cmd)
        local result = handle:read("*a")
        handle:close()
        return result:gsub("%s+$", "")
      end
    elseif marker.dir and vim.fn.isdirectory(marker.dir) == 1 then
      return vim.fn.getcwd() .. "/" .. marker.dir
    elseif marker.env and vim.env[marker.env] then
      return vim.env[marker.env]
    end
  end

  return nil
end
```

## 📚 参考示例

### 示例 1: 标准 venv 项目

```
my-project/
├── .venv/                 # 虚拟环境
├── pyrightconfig.json     # pyright 配置
├── requirements.txt
└── src/
    └── main.py
```

`pyrightconfig.json`:
```json
{
  "venvPath": ".",
  "venv": ".venv",
  "reportMissingImports": true
}
```

### 示例 2: Poetry 项目

```
my-project/
├── pyproject.toml         # poetry 配置
├── poetry.lock
└── src/
    └── main.py
```

`pyproject.toml`:
```toml
[tool.pyright]
venvPath = "."
```

### 示例 3: Conda 环境

启动 Neovim 前：
```bash
conda activate my-env
nvim
```

或在 Neovim 中：
```vim
:!conda activate my-env
:PythonLspRestart
```

## 🎯 总结

### 推荐配置（最简单）

1. **使用 Mason 安装 LSP 服务器** ✨
   - 不受 Node 版本影响
   - 自动管理和更新

2. **在项目中添加 pyrightconfig.json**
   - 明确指定虚拟环境
   - 项目级配置，团队共享

3. **在激活环境后启动 Neovim**
   - 简单直接
   - 符合日常工作流

### 问题解决流程

```
虚拟环境切换后 LSP 不工作？
  ↓
1. 检查 :LspInfo - LSP 是否运行？
  ↓
2. 检查 :Mason - pyright 是否安装？
  ↓
3. 运行 :PythonLspRestart - 重启 LSP
  ↓
4. 检查项目配置 - pyrightconfig.json 是否正确？
  ↓
5. 查看日志 - :lua vim.cmd('edit ' .. vim.lsp.get_log_path())
```

### 优势

- ✅ **Mason 隔离**: LSP 服务器独立于系统环境
- ✅ **自动检测**: 支持多种虚拟环境工具
- ✅ **便捷重启**: 一键重启 LSP 适应新环境
- ✅ **项目配置**: 团队协作配置一致

现在的配置已经很好地处理了虚拟环境问题！🎉
