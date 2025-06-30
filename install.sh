#!/usr/bin/env bash
set -euo pipefail

source ./scripts/helpers.sh

main() {
  info_message "Iniciando instalação do ambiente de desenvolvimento"

  sudo apt update
  install_group base
  install_python_packages
  verify_stow
  install_oh_my_zsh
  install_zsh_plugins
  create_symlinks

  success_message "Ambiente configurado com sucesso!"
}

main

if [ "$SHELL" != "$(which zsh)" ]; then
  info_message "Mudando shell padrão para Zsh"
  chsh -s "$(which zsh)"
  info_message "Shell padrão alterado. Faça logout e login novamente para que a mudança tenha efeito."
fi
