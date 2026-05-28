#!/usr/bin/env bash

say() {
  if command -v tput >/dev/null 2>&1 && [ -t 1 ]; then
    echo "$@" | sed \
      -e "s/\(@red\)/$(tput setaf 1)/g" \
      -e "s/\(@green\)/$(tput setaf 2)/g" \
      -e "s/\(@yellow\)/$(tput setaf 3)/g" \
      -e "s/\(@blue\)/$(tput setaf 4)/g" \
      -e "s/\(@reset\)/$(tput sgr0)/g" \
      -e "s/\(@b\)/$(tput bold)/g"
  else
    echo "$@" | sed -e 's/@red//g;s/@green//g;s/@yellow//g;s/@blue//g;s/@reset//g;s/@b//g'
  fi
}

info_message() { say "@b@blue[INFO]@reset $*"; }
success_message() { say "@b@green[SUCCESS]@reset $*"; }
warn_message() { say "@b@yellow[WARN]@reset $*"; }
error_message() { say "@b@red[ERROR]@reset $*"; }

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error_message "Comando obrigatório não encontrado: $1"
    exit 1
  fi
}

install_group() {
  local group_file="pkgs/$1.pkgs.txt"
  if [ ! -f "$group_file" ]; then
    error_message "Arquivo $group_file não encontrado."
    return 1
  fi

  info_message "Instalando grupo de pacotes apt: $1"
  grep -vE '^\s*($|#)' "$group_file" | xargs -r sudo apt install -y
}

install_python_packages() {
  local python_file="pkgs/python.pkgs.txt"

  if [ ! -f "$python_file" ]; then
    warn_message "Arquivo $python_file não encontrado; pulando pacotes Python."
    return 0
  fi

  if ! command -v pipx >/dev/null 2>&1; then
    info_message "pipx não encontrado; instalando."
    sudo apt install -y pipx
  fi

  python3 -m pipx ensurepath || true

  info_message "Instalando ferramentas Python via pipx."
  while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
    pipx install "$package" || pipx upgrade "$package" || true
  done < "$python_file"
}

backup_file_if_needed() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="$target.backup.$(date +%Y%m%d-%H%M%S)"
    warn_message "Backup de $target em $backup"
    mv "$target" "$backup"
  fi
}

backup_existing_dotfiles() {
  backup_file_if_needed "$HOME/.zshrc"
  backup_file_if_needed "$HOME/.gitconfig"
}

create_symlinks() {
  info_message "Criando symlinks com stow."
  stow --target="$HOME" git
  stow --target="$HOME" zsh
}

install_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    info_message "Oh My Zsh já instalado."
    return 0
  fi

  require_command curl
  info_message "Instalando Oh My Zsh."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_zsh_plugins() {
  require_command git
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$zsh_custom/plugins"

  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    info_message "Instalando plugin zsh-autosuggestions."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
    info_message "Instalando plugin zsh-syntax-highlighting."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
  fi
}

install_snaps() {
  local snap_file="pkgs/snaps.pkgs.txt"
  if [ ! -f "$snap_file" ]; then
    warn_message "Arquivo $snap_file não encontrado; pulando snaps."
    return 0
  fi

  if ! command -v snap >/dev/null 2>&1; then
    warn_message "snap não encontrado; pulando snaps."
    return 0
  fi

  info_message "Instalando snaps opcionais."
  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    # formato: nome [--classic]
    sudo snap install $line || true
  done < "$snap_file"
}

ensure_zsh_shell() {
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [ -z "$zsh_path" ]; then
    warn_message "zsh não encontrado; shell padrão não alterado."
    return 0
  fi

  if [ "${SHELL:-}" != "$zsh_path" ]; then
    info_message "Alterando shell padrão para $zsh_path."
    chsh -s "$zsh_path"
  else
    info_message "Shell padrão já é zsh."
  fi
}
