#!/bin/bash
# ==========================================
# Neovim 完整安装脚本
# 自动检测系统并安装所有依赖
# ==========================================

set -e  # 遇到错误立即退出

BASEDIR=$(dirname "$0")
cd "$BASEDIR" || exit 1
CURRENT_DIR=$(pwd)

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_header() {
    echo ""
    echo -e "${BLUE}=========================================="
    echo -e "$1"
    echo -e "==========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "检测到 macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            print_info "检测到 Linux ($DISTRO)"
        fi
    else
        print_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 安装包管理器
install_package_manager() {
    if [[ "$OS" == "macos" ]]; then
        if ! command_exists brew; then
            print_info "安装 Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew 安装完成"
        else
            print_success "Homebrew 已安装"
        fi
    elif [[ "$OS" == "linux" ]]; then
        if [[ "$DISTRO" == "ubuntu" ]] || [[ "$DISTRO" == "debian" ]]; then
            print_info "使用 apt 包管理器"
        elif [[ "$DISTRO" == "fedora" ]] || [[ "$DISTRO" == "rhel" ]] || [[ "$DISTRO" == "centos" ]]; then
            print_info "使用 dnf/yum 包管理器"
        elif [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "manjaro" ]]; then
            print_info "使用 pacman 包管理器"
        fi
    fi
}

# 安装 Neovim
install_neovim() {
    print_header "检查 Neovim"

    if command_exists nvim; then
        NVIM_VERSION=$(nvim --version | head -n1 | grep -oP '\d+\.\d+\.\d+')
        print_success "Neovim 已安装 (版本 $NVIM_VERSION)"

        # 检查版本是否 >= 0.10.0
        REQUIRED_VERSION="0.10.0"
        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NVIM_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            print_success "Neovim 版本满足要求 (>= 0.10.0)"
        else
            print_warning "Neovim 版本过低，建议升级到 0.10.0 或更高"
            read -p "是否升级 Neovim? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                UPGRADE_NVIM=true
            fi
        fi
    else
        print_info "Neovim 未安装，开始安装..."
        INSTALL_NVIM=true
    fi

    if [[ "$INSTALL_NVIM" == true ]] || [[ "$UPGRADE_NVIM" == true ]]; then
        if [[ "$OS" == "macos" ]]; then
            brew install neovim
        elif [[ "$OS" == "linux" ]]; then
            if [[ "$DISTRO" == "ubuntu" ]] || [[ "$DISTRO" == "debian" ]]; then
                sudo apt update
                sudo apt install -y neovim
            elif [[ "$DISTRO" == "fedora" ]] || [[ "$DISTRO" == "rhel" ]]; then
                sudo dnf install -y neovim
            elif [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "manjaro" ]]; then
                sudo pacman -S --noconfirm neovim
            fi
        fi
        print_success "Neovim 安装完成"
    fi
}

# 安装基础依赖
install_dependencies() {
    print_header "安装依赖工具"

    local deps=("git" "curl" "wget")

    if [[ "$OS" == "macos" ]]; then
        # macOS 使用 Homebrew
        deps+=("ripgrep" "fd" "node" "python3")

        for dep in "${deps[@]}"; do
            if ! command_exists "$dep"; then
                print_info "安装 $dep..."
                brew install "$dep"
                print_success "$dep 安装完成"
            else
                print_success "$dep 已安装"
            fi
        done

    elif [[ "$OS" == "linux" ]]; then
        # Linux 根据发行版选择包管理器
        if [[ "$DISTRO" == "ubuntu" ]] || [[ "$DISTRO" == "debian" ]]; then
            sudo apt update
            sudo apt install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip
        elif [[ "$DISTRO" == "fedora" ]] || [[ "$DISTRO" == "rhel" ]]; then
            sudo dnf install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip
        elif [[ "$DISTRO" == "arch" ]] || [[ "$DISTRO" == "manjaro" ]]; then
            sudo pacman -S --noconfirm git curl wget ripgrep fd nodejs npm python python-pip
        fi
        print_success "依赖工具安装完成"
    fi
}

# 安装 Python 工具
install_python_tools() {
    print_header "安装 Python 工具"

    if command_exists pip3; then
        print_info "安装 Python linting/formatting 工具..."
        pip3 install --user --upgrade pip
        pip3 install --user flake8 black isort
        print_success "Python 工具安装完成"
    else
        print_warning "pip3 未找到，跳过 Python 工具安装"
    fi
}

# 安装 Nerd Font（可选）
install_nerd_font() {
    print_header "安装 Nerd Font"

    print_info "Nerd Font 用于显示图标，建议安装"
    read -p "是否安装 Nerd Font? (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OS" == "macos" ]]; then
            # macOS 使用 Homebrew Cask
            if ! brew list --cask font-hack-nerd-font >/dev/null 2>&1; then
                print_info "安装 Hack Nerd Font..."
                brew tap homebrew/cask-fonts
                brew install --cask font-hack-nerd-font
                print_success "Hack Nerd Font 安装完成"
                print_warning "请在终端设置中将字体改为 'Hack Nerd Font'"
            else
                print_success "Hack Nerd Font 已安装"
            fi
        elif [[ "$OS" == "linux" ]]; then
            # Linux 手动安装
            print_info "下载 Hack Nerd Font..."
            mkdir -p ~/.local/share/fonts
            cd ~/.local/share/fonts

            if [ ! -f "Hack Regular Nerd Font Complete.ttf" ]; then
                curl -fLo "Hack Regular Nerd Font Complete.ttf" \
                    https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf
                fc-cache -fv
                print_success "Hack Nerd Font 安装完成"
                print_warning "请在终端设置中将字体改为 'Hack Nerd Font'"
            else
                print_success "Hack Nerd Font 已安装"
            fi

            cd "$CURRENT_DIR"
        fi
    else
        print_info "跳过 Nerd Font 安装"
    fi
}

# 设置软链接
setup_symlink() {
    print_header "设置配置软链接"

    # 检查是否已存在配置
    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        print_warning "检测到现有 Neovim 配置: $HOME/.config/nvim"
        read -p "是否备份并继续? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "安装已取消"
            exit 1
        fi

        backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "备份到: $backup_dir"
        mv "$HOME/.config/nvim" "$backup_dir"
        print_success "备份完成"
    fi

    # 删除现有软链接
    if [ -L "$HOME/.config/nvim" ]; then
        print_info "删除现有软链接..."
        rm "$HOME/.config/nvim"
    fi

    # 创建 ~/.config 目录
    mkdir -p "$HOME/.config"

    # 创建软链接
    print_info "创建软链接: $CURRENT_DIR -> $HOME/.config/nvim"
    ln -sf "$CURRENT_DIR" "$HOME/.config/nvim"
    print_success "软链接创建完成"
}

# 安装插件和 LSP
install_plugins() {
    print_header "安装 Neovim 插件"

    print_info "首次启动 Neovim 会自动安装插件..."
    print_info "这可能需要几分钟时间"
    echo ""

    # 使用 headless 模式安装插件
    print_info "正在安装插件..."
    nvim --headless "+Lazy! sync" +qa

    print_success "插件安装完成"
}

# 主安装流程
main() {
    print_header "Neovim 配置自动安装脚本"
    print_info "配置目录: $CURRENT_DIR"

    # 检测操作系统
    detect_os

    # 安装包管理器
    install_package_manager

    # 安装 Neovim
    install_neovim

    # 安装依赖
    install_dependencies

    # 安装 Python 工具
    install_python_tools

    # 安装字体（可选）
    install_nerd_font

    # 设置软链接
    setup_symlink

    # 安装插件
    install_plugins

    # 完成
    print_header "安装完成！"

    echo -e "${GREEN}✓ Neovim 配置已成功安装${NC}"
    echo ""
    echo "下一步："
    echo ""
    echo "1. 启动 Neovim:"
    echo "   ${BLUE}nvim${NC}"
    echo ""
    echo "2. 检查健康状态:"
    echo "   ${BLUE}:checkhealth${NC}"
    echo ""
    echo "3. Mason 会自动安装 LSP 服务器，也可以手动查看:"
    echo "   ${BLUE}:Mason${NC}"
    echo ""
    echo "4. 尝试新功能:"
    echo "   - 打开 Python 文件测试 LSP"
    echo "   - 按 ${BLUE},${NC} 查看快捷键提示"
    echo "   - 按 ${BLUE}s${NC} 快速跳转"
    echo "   - 按 ${BLUE},xx${NC} 查看诊断列表"
    echo ""
    echo -e "${YELLOW}提示：${NC}"
    echo "- 如果终端图标显示不正常，请确保使用 Nerd Font"
    echo "- 首次使用时 Mason 会在后台安装工具，请稍等片刻"
    echo ""
    echo -e "${BLUE}=========================================="
    echo "回滚命令："
    echo -e "==========================================${NC}"
    echo ""
    echo "如果需要回滚到旧配置："
    echo "   ${BLUE}rm ~/.config/nvim${NC}"
    echo "   ${BLUE}mv ~/.config/nvim.backup.* ~/.config/nvim${NC}"
    echo ""
}

# 运行主程序
main
