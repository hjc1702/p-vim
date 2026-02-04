#!/usr/bin/env bash
# ==========================================
# p-vim macOS 一键安装脚本
# 仅支持 macOS，最小必要依赖
# ==========================================

set -Eeuo pipefail

trap 'echo; echo "安装失败，请检查上面的错误信息。"; exit 1' ERR

BASEDIR="$(cd -- "$(dirname -- "$0")" && pwd)"
CURRENT_DIR="$BASEDIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
  echo
  echo -e "${BLUE}=========================================="
  echo -e "$1"
  echo -e "==========================================${NC}"
  echo
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC}  $1"; }

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

confirm() {
  local prompt="$1"
  local answer
  read -r -p "$prompt [y/N] " answer || true
  [[ "$answer" =~ ^[Yy]$ ]]
}

ensure_macos() {
  if [[ "$OSTYPE" != darwin* ]]; then
    print_error "该脚本仅支持 macOS。"
    exit 1
  fi
  print_success "检测到 macOS"
}

ensure_brew_in_path() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    export PATH="/usr/local/bin:$PATH"
  fi
}

install_homebrew() {
  print_header "检查 Homebrew"

  ensure_brew_in_path
  if command_exists brew; then
    print_success "Homebrew 已安装"
    return
  fi

  print_info "安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_in_path

  if ! command_exists brew; then
    print_error "Homebrew 安装失败，请手动安装后重试。"
    exit 1
  fi

  print_success "Homebrew 安装完成"
}

install_xcode_clt() {
  print_header "检查编译工具链"

  if xcode-select -p >/dev/null 2>&1; then
    print_success "Xcode Command Line Tools 已安装"
    return
  fi

  print_warning "未检测到 Xcode Command Line Tools。"
  print_info "LuaSnip / telescope-fzf-native / Treesitter 构建需要编译工具。"
  if confirm "是否现在执行 xcode-select --install？"; then
    xcode-select --install || true
    print_warning "请完成弹窗安装后，重新执行本脚本。"
    exit 0
  fi

  print_error "缺少编译工具，无法继续安装。"
  exit 1
}

install_packages() {
  print_header "安装必要依赖"

  # 基于当前项目，仅保留必要依赖：
  # neovim: 编辑器
  # git: lazy.nvim 拉取插件
  # curl: 安装流程/下载
  # ripgrep: Telescope live_grep 与 todo-comments 搜索依赖
  # fd: Telescope 文件搜索加速
  # make: 构建 telescope-fzf-native 与 LuaSnip jsregexp
  local deps=(neovim git curl ripgrep fd make)

  for dep in "${deps[@]}"; do
    if command_exists "$dep"; then
      print_success "$dep 已安装"
    else
      print_info "安装 $dep..."
      brew install "$dep"
      print_success "$dep 安装完成"
    fi
  done
}

install_nerd_font() {
  print_header "安装 Nerd Font（可选）"

  if ! confirm "是否安装 Maple Mono NF CN 字体？"; then
    print_info "跳过字体安装"
    return
  fi

  if brew list --cask font-maple-mono-nf-cn >/dev/null 2>&1; then
    print_success "Maple Mono NF CN 已安装"
  else
    brew install --cask font-maple-mono-nf-cn
    print_success "Maple Mono NF CN 安装完成"
  fi
}

setup_symlink() {
  print_header "设置配置软链接"

  local target="$HOME/.config/nvim"
  mkdir -p "$HOME/.config"

  if [[ -d "$target" && ! -L "$target" ]]; then
    print_warning "检测到已有目录: $target"
    if ! confirm "是否备份并继续？"; then
      print_error "用户取消安装"
      exit 1
    fi
    local backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$target" "$backup_dir"
    print_success "已备份到: $backup_dir"
  fi

  if [[ -L "$target" || -e "$target" ]]; then
    rm -rf "$target"
  fi

  ln -s "$CURRENT_DIR" "$target"
  print_success "软链接创建完成: $target -> $CURRENT_DIR"
}

install_plugins() {
  print_header "安装插件"

  print_info "首次同步插件（可能需要 1~3 分钟）..."
  if nvim --headless "+Lazy! sync" +qa >/tmp/pvim-lazy-sync.log 2>&1; then
    print_success "插件安装完成"
  else
    print_warning "自动安装插件失败，可手动执行 :Lazy sync"
    print_info "日志: /tmp/pvim-lazy-sync.log"
  fi
}

final_message() {
  print_header "安装完成"

  echo -e "${GREEN}✓ p-vim 已就绪，可以直接使用${NC}"
  echo
  echo "下一步："
  echo "1. 运行: nvim"
  echo "2. 执行: :checkhealth"
  echo "3. 执行: :Lazy 查看插件状态"
  echo "4. 打开任意代码文件验证高亮/补全/片段"
  echo
  echo "提示："
  echo "- 若图标显示异常，请在终端切换到 Nerd Font"
  echo "- 当前配置为轻量模式（无 LSP / 无 lint / 无 format）"
}

main() {
  print_header "p-vim macOS 安装脚本"
  print_info "配置目录: $CURRENT_DIR"

  ensure_macos
  install_homebrew
  install_xcode_clt
  install_packages
  install_nerd_font
  setup_symlink
  install_plugins
  final_message
}

main "$@"
