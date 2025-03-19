#!/usr/bin/env bash

source ./scripts/helpers.sh

main() {
  info_message "Iniciando instalação do ambiente de desenvolvimento"

  sudo apt update
  install_group base
  install_python_packages
  create_symlinks

  success_message "Ambiente configurado com sucesso!"
}

main
