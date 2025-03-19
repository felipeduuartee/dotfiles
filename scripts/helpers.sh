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
  if [ -f "$python_file" ]; then
    info_message "Instalando pacotes Python com pip..."
    xargs -a "$python_file" pip3 install --user
  else
    error_message "Arquivo $python_file não encontrado!"
  fi
}

create_symlinks() {
  info_message "Criando symlinks com stow..."
  stow bash
  stow git
}
