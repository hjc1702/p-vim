#!/usr/bin/env bash
# ==========================================
# p-vim 一键安装脚本（新电脑可直接使用）
# ==========================================

set -Eeuo pipefail

export DISABLE_AUTO_UPDATE=true
export DISABLE_UPDATE_PROMPT=true

trap 'echo; echo "脚本执行失败，请检查上面的报错信息。"; exit 1' ERR

BASEDIR="$(cd -- "$(dirname -- "$0")" && pwd)"
CURRENT_DIR="$BASEDIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

OS=""
DISTRO=""
PKG_INSTALL=""
PKG_UPDATE=""

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
  local default_yes="${2:-false}"
  local answer
  if [[ "$default_yes" == "true" ]]; then
    read -r -p "$prompt [Y/n] " answer || true
    [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]
  else
    read -r -p "$prompt [y/N] " answer || true
    [[ "$answer" =~ ^[Yy]$ ]]
  fi
}

ensure_brew_in_path() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    export PATH="/usr/local/bin:$PATH"
  fi
}

detect_os() {
  if [[ "$OSTYPE" == darwin* ]]; then
    OS="macos"
    print_info "检测到 macOS"
    return
  fi

  if [[ "$OSTYPE" == linux-gnu* ]]; then
    OS="linux"
    if [[ -f /etc/os-release ]]; then
      # shellcheck source=/etc/os-release
      . /etc/os-release
      DISTRO="${ID:-unknown}"
    else
      DISTRO="unknown"
    fi
    print_info "检测到 Linux (${DISTRO})"
    return
  fi

  print_error "不支持的操作系统: $OSTYPE"
  exit 1
}

setup_package_manager() {
  if [[ "$OS" == "macos" ]]; then
    ensure_brew_in_path
    if ! command_exists brew; then
      print_info "安装 Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ensure_brew_in_path
    fi
    if ! command_exists brew; then
      print_error "Homebrew 安装失败，请手动安装后重试。"
      exit 1
    fi
    print_success "Homebrew 可用"
    return
  fi

  case "$DISTRO" in
    ubuntu|debian)
      PKG_UPDATE="sudo apt update"
      PKG_INSTALL="sudo apt install -y"
      ;;
    fedora|rhel|centos)
      PKG_UPDATE="sudo dnf makecache"
      PKG_INSTALL="sudo dnf install -y"
      ;;
    arch|manjaro)
      PKG_UPDATE="sudo pacman -Sy"
      PKG_INSTALL="sudo pacman -S --noconfirm"
      ;;
    *)
      print_error "暂不支持此 Linux 发行版: ${DISTRO}"
      print_info "请手动安装: neovim git curl ripgrep fd node python3 make gcc"
      exit 1
      ;;
  esac

  print_success "包管理器已就绪"
}

version_ge() {
  local current="$1"
  local required="$2"
  [[ "$(printf '%s\n' "$required" "$current" | sort -V | head -n1)" == "$required" ]]
}

install_neovim() {
  print_header "检查 Neovim"

  local need_install="false"

  if command_exists nvim; then
    local ver
    ver="$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
    print_success "Neovim 已安装 (版本 ${ver})"
    if ! version_ge "$ver" "0.10.0"; then
      print_warning "Neovim 版本低于 0.10.0，建议升级。"
      if confirm "是否升级 Neovim？" true; then
        need_install="true"
      fi
    fi
  else
    need_install="true"
  fi

  if [[ "$need_install" != "true" ]]; then
    return
  fi

  print_info "安装/升级 Neovim..."
  if [[ "$OS" == "macos" ]]; then
    brew install neovim || brew upgrade neovim
  else
    eval "$PKG_UPDATE"
    eval "$PKG_INSTALL neovim"
  fi

  print_success "Neovim 安装完成"
}

install_dependencies() {
  print_header "安装依赖工具"

  if [[ "$OS" == "macos" ]]; then
    local deps=(git curl wget ripgrep fd node python3 make)
    for dep in "${deps[@]}"; do
      if command_exists "$dep"; then
        print_success "$dep 已安装"
      else
        print_info "安装 $dep..."
        brew install "$dep"
        print_success "$dep 安装完成"
      fi
    done

    if ! xcode-select -p >/dev/null 2>&1; then
      print_warning "未检测到 Xcode Command Line Tools，建议执行: xcode-select --install"
    fi
    return
  fi

  eval "$PKG_UPDATE"
  case "$DISTRO" in
    ubuntu|debian)
      eval "$PKG_INSTALL git curl wget ripgrep fd-find nodejs npm python3 python3-pip make gcc unzip"
      ;;
    fedora|rhel|centos)
      eval "$PKG_INSTALL git curl wget ripgrep fd-find nodejs npm python3 python3-pip make gcc unzip"
      ;;
    arch|manjaro)
      eval "$PKG_INSTALL git curl wget ripgrep fd nodejs npm python python-pip make gcc unzip"
      ;;
  esac
  print_success "依赖工具安装完成"
}

install_python_provider() {
  print_header "配置 Python Provider（可选）"

  if ! command_exists python3; then
    print_warning "未检测到 python3，跳过。"
    return
  fi

  if python3 -m pip --version >/dev/null 2>&1; then
    python3 -m pip install --user --upgrade pynvim >/dev/null 2>&1 || true
    print_success "pynvim 已安装/更新"
  else
    print_warning "未检测到 pip，跳过 pynvim 安装。"
  fi
}

install_nerd_font() {
  print_header "安装 Nerd Font（可选）"

  if ! confirm "是否安装 Maple Mono NF CN 字体？" false; then
    print_info "跳过字体安装"
    return
  fi

  if [[ "$OS" == "macos" ]]; then
    if brew list --cask font-maple-mono-nf-cn >/dev/null 2>&1; then
      print_success "Maple Mono NF CN 已安装"
    else
      brew install --cask font-maple-mono-nf-cn
      print_success "Maple Mono NF CN 安装完成"
    fi
    return
  fi

  mkdir -p "$HOME/.local/share/fonts"
  local font_dir="$HOME/.local/share/fonts/maple-font"

  if [[ -d "$font_dir" ]]; then
    print_success "Maple Mono NF CN 已安装"
    return
  fi

  print_info "下载 Maple Mono NF CN..."
  local tmp_zip
  tmp_zip="$(mktemp /tmp/maple-font.XXXXXX.zip)"
  local release_url
  release_url="$(curl -s https://api.github.com/repos/subframe7536/maple-font/releases/latest | grep 'browser_download_url.*MapleMono-NF-CN.zip' | cut -d '"' -f 4)"

  if [[ -z "$release_url" ]]; then
    print_warning "获取字体下载地址失败，跳过字体安装。"
    return
  fi

  curl -fL "$release_url" -o "$tmp_zip"
  unzip -q "$tmp_zip" -d "$font_dir"
  rm -f "$tmp_zip"
  fc-cache -fv >/dev/null 2>&1 || true
  print_success "Maple Mono NF CN 安装完成"
}

setup_symlink() {
  print_header "设置配置软链接"

  local target="$HOME/.config/nvim"
  mkdir -p "$HOME/.config"

  if [[ -d "$target" && ! -L "$target" ]]; then
    print_warning "检测到已有目录: $target"
    if ! confirm "是否备份并继续？" false; then
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
  print_header "p-vim 新电脑安装脚本"
  print_info "配置目录: $CURRENT_DIR"

  detect_os
  setup_package_manager
  install_neovim
  install_dependencies
  install_python_provider
  install_nerd_font
  setup_symlink
  install_plugins
  final_message
}

main "$@"
