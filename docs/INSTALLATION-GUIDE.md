# 安装指南

本文档提供在新电脑上安装和配置 p-vim 的详细步骤。

## 问题说明

如果你在新电脑上首次打开 Neovim 时看到类似以下错误：

```
Failed to run `config` for nvim-treesitter
module 'nvim-treesitter.configs' not found
```

这是**正常现象**，因为插件还在后台安装中。配置文件已经添加了错误保护，会自动跳过未安装的插件。

## 安装步骤

### 1. 前置要求

确保已安装以下软件：

```bash
# macOS (使用 Homebrew)
brew install neovim git ripgrep fd

# Ubuntu/Debian
sudo apt install neovim git ripgrep fd-find

# 验证版本（需要 Neovim 0.9.0+）
nvim --version
```

### 2. 克隆配置

```bash
# 克隆仓库
git clone https://github.com/hjc1702/p-vim.git ~/Workspace/hjc1702/p-vim

# 创建软链接
ln -s ~/Workspace/hjc1702/p-vim ~/.config/nvim
```

**或者**使用安装脚本：

```bash
cd ~/Workspace/hjc1702/p-vim
./install-neovim.sh
```

### 3. 首次启动

首次启动 Neovim 时，**会看到一些错误或警告**，这是正常的：

```bash
nvim
```

你可能会看到：
- ❌ `Failed to run config for nvim-treesitter` - **正常，插件还在安装**
- ⚠️  `nvim-treesitter not installed yet` - **正常，稍等片刻**
- ⚠️  `rainbow-delimiters not installed yet` - **正常，稍等片刻**

**不要关闭 Neovim**，等待几秒钟，lazy.nvim 会在后台自动下载所有插件。

### 4. 检查插件安装状态

在 Neovim 中执行：

```vim
:Lazy
```

你会看到插件管理器界面：
- ✅ 绿色勾号表示已安装
- 🔄 旋转图标表示正在安装
- ❌ 红色叉号表示安装失败

等待所有插件显示绿色勾号。

### 5. 同步插件

如果有插件安装失败或需要更新，执行：

```vim
:Lazy sync
```

这会：
1. 安装缺失的插件
2. 更新已有插件
3. 清理未使用的插件

### 6. 安装 LSP 服务器

打开 Mason（LSP 服务器管理器）：

```vim
:Mason
```

**推荐安装的 LSP 服务器**：
- `pyright` - Python（按 `i` 安装）
- `lua_ls` - Lua
- `gopls` - Go
- `rust_analyzer` - Rust
- `taplo` - TOML

在 Mason 界面中：
- 按 `/` 搜索
- 按 `i` 安装
- 按 `X` 卸载
- 按 `U` 更新所有
- 按 `q` 退出

### 7. 安装 Treesitter 解析器

Treesitter 解析器会在打开对应文件类型时自动安装，也可以手动安装：

```vim
:TSInstall python lua vim javascript
```

查看已安装的解析器：

```vim
:TSInstallInfo
```

### 8. 验证安装

运行健康检查：

```vim
:checkhealth
```

重点检查：
- ✅ `lazy.nvim` - 插件管理器
- ✅ `nvim-treesitter` - 语法高亮
- ✅ `mason.nvim` - LSP 管理器
- ✅ `telescope.nvim` - 模糊搜索

### 9. 重启 Neovim

完成所有安装后，**完全退出并重新启动** Neovim：

```bash
# 退出所有 Neovim 实例
pkill nvim

# 重新启动
nvim
```

此时应该不会再有错误提示。

## 常见问题

### Q1: 首次启动看到很多错误

**A**: 正常现象，插件还在安装中。等待 30 秒后执行 `:Lazy sync`，然后重启 Neovim。

### Q2: Mason 无法安装 LSP 服务器

**A**: 检查网络连接和代理设置：

```bash
# 设置代理（如果需要）
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890

# 重启 Neovim
nvim
```

### Q3: Treesitter 编译失败

**A**: 确保已安装 C 编译器：

```bash
# macOS
xcode-select --install

# Ubuntu/Debian
sudo apt install build-essential

# 然后重新安装解析器
nvim
:TSInstall! python
```

### Q4: 配置文件冲突

**A**: 如果已有旧的 Neovim 配置，先备份：

```bash
# 备份旧配置
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# 然后重新创建软链接
ln -s ~/Workspace/hjc1702/p-vim ~/.config/nvim
```

### Q5: 插件版本不匹配

**A**: 使用 `lazy-lock.json` 锁定的版本：

```bash
# 在项目目录执行
git pull origin master

# 然后在 Neovim 中
:Lazy restore
```

## 完整安装时间线

一次完整的安装通常需要：

1. **0-10 秒**: 启动 Neovim，lazy.nvim 开始下载插件
2. **10-30 秒**: 插件下载完成，可能显示一些警告（正常）
3. **30-60 秒**: 执行 `:Lazy sync` 确保所有插件就绪
4. **1-2 分钟**: 执行 `:Mason` 安装 LSP 服务器
5. **2-5 分钟**: Treesitter 解析器自动安装（打开文件时）
6. **5 分钟后**: 完成安装，重启 Neovim 享受完整功能

## 卸载

如果需要卸载配置：

```bash
# 删除软链接
rm ~/.config/nvim

# 删除数据目录
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# 恢复备份（如果有）
mv ~/.config/nvim.bak ~/.config/nvim
```

## 更新配置

定期更新配置和插件：

```bash
# 更新配置文件
cd ~/Workspace/hjc1702/p-vim
git pull

# 在 Neovim 中更新插件
nvim
:Lazy sync
:Mason update
```

## 技术支持

如果遇到问题：

1. 运行 `:checkhealth` 查看详细诊断
2. 查看日志文件：`~/.local/state/nvim/log`
3. 查看项目文档：`docs/` 目录
4. 提交 Issue：[GitHub Issues](https://github.com/hjc1702/p-vim/issues)
