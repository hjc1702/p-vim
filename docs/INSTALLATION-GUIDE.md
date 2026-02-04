# 安装指南

本文档提供在新电脑上安装和配置 p-vim 的详细步骤（当前为轻量配置，不含 LSP/Lint/Format）。

## 常见提示说明

如果首次打开 Neovim 时看到类似错误：

```
Failed to run `config` for nvim-treesitter
module 'nvim-treesitter.configs' not found
```

这是**正常现象**，因为插件还在后台安装中。配置文件已添加错误保护，会自动跳过未安装的插件。

## 安装步骤

### 1. 前置要求

确保已安装以下软件：

```bash
# macOS (使用 Homebrew)
brew install neovim git ripgrep fd

# Ubuntu/Debian
sudo apt install neovim git ripgrep fd-find

# 验证版本（需要 Neovim 0.10+）
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

首次启动 Neovim 时，**可能会看到一些错误或警告**，这是正常的：

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

### 6. 安装 Treesitter 解析器

Treesitter 解析器会在打开对应文件类型时自动安装，也可以手动安装：

```vim
:TSInstall python lua vim javascript
```

查看已安装的解析器：

```vim
:TSInstallInfo
```

### 7. 验证安装

运行健康检查：

```vim
:checkhealth
```

重点检查：
- ✅ `lazy.nvim` - 插件管理器
- ✅ `nvim-treesitter` - 语法高亮
- ✅ `telescope.nvim` - 模糊搜索

### 8. 重启 Neovim

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

### Q2: Treesitter 编译失败

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

### Q3: 配置文件冲突

**A**: 如果已有旧的 Neovim 配置，先备份：

```bash
# 备份旧配置
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# 然后重新创建软链接
ln -s ~/Workspace/hjc1702/p-vim ~/.config/nvim
```

### Q4: 插件版本不匹配

**A**: 使用 `lazy-lock.json` 锁定的版本：

```bash
# 在项目目录执行
git pull origin master

# 然后在 Neovim 中
:Lazy restore
```

## 完整安装时间线

一次完整的安装通常需要：
- 1-2 分钟：下载/安装插件
- 1-2 分钟：安装 Treesitter 解析器（按需）

