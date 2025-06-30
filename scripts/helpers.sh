#!/usr/bin/env bash

say() {
  echo "$@" | sed \
    -e "s/\(@red\)/$(tput setaf 1)/g" \
    -e "s/\(@green\)/$(tput setaf 2)/g" \
    -e "s/\(@yellow\)/$(tput setaf 3)/g" \
    -e "s/\(@blue\)/$(tput setaf 4)/g" \
    -e "s/\(@reset\)/$(tput sgr0)/g" \
    -e "s/\(@b\)/$(tput bold)/g"
}

info_message() {
  say "@b@blue[INFO]@reset $*"
}

success_message() {
  say "@b@green[SUCCESS]@reset $*"
}

error_message() {
  say "@b@red[ERROR]@reset $*"
}

install_group() {
  local group_file="pkgs/$1.pkgs.txt"
  if [ -f "$group_file" ]; then
    info_message "Instalando grupo de pacotes: $1"
    xargs -a "$group_file" sudo apt install -y
  else
    error_message "Arquivo $group_file não encontrado!"
  fi
}

install_python_packages() {
  local python_file="pkgs/python.pkgs.txt"

  if ! command -v pip3 >/dev/null 2>&1; then
    info_message "pip3 não encontrado. Instalando python3-pip..."
    sudo apt install -y python3-pip
  fi

  if [ -f "$python_file" ]; then
    info_message "Instalando pacotes Python com pip..."
    xargs -a "$python_file" pip3 install --user
  else
    error_message "Arquivo $python_file não encontrado!"
  fi
}

verify_stow() {
  if ! command -v stow >/dev/null 2>&1; then
    info_message "stow não encontrado. Instalando..."
    sudo apt install -y stow
  fi
}

create_symlinks() {
  info_message "Criando symlinks com stow..."
  stow git
  stow zsh
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info_message "Instalando Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    info_message "Oh My Zsh já instalado."
  fi
}

install_zsh_plugins() {
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    info_message "Instalando plugin zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi

  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    info_message "Instalando plugin zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
}
