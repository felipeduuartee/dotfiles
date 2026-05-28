#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
source ./scripts/helpers.sh

WITH_SECURITY=0
WITH_LANGUAGES=0
WITH_SNAPS=0

for arg in "$@"; do
  case "$arg" in
    --security) WITH_SECURITY=1 ;;
    --languages) WITH_LANGUAGES=1 ;;
    --snaps) WITH_SNAPS=1 ;;
    -h|--help)
      cat <<'HELP'
Uso: ./install.sh [opções]

Opções:
  --security    instala ferramentas de segurança/pentest
  --languages   instala runtimes/ferramentas extras de linguagem
  --snaps       instala snaps opcionais listados em pkgs/snaps.pkgs.txt
  -h, --help    mostra esta ajuda
HELP
      exit 0
      ;;
    *)
      error_message "Opção desconhecida: $arg"
      exit 1
      ;;
  esac
done

main() {
  info_message "Iniciando configuração do ambiente"
  require_command sudo

  sudo apt update
  install_group base

  if [ "$WITH_SECURITY" -eq 1 ]; then
    install_group security
  fi

  if [ "$WITH_LANGUAGES" -eq 1 ]; then
    install_group languages
  fi

  install_python_packages
  install_oh_my_zsh
  install_zsh_plugins
  backup_existing_dotfiles
  create_symlinks

  if [ "$WITH_SNAPS" -eq 1 ]; then
    install_snaps
  fi

  ensure_zsh_shell
  success_message "Ambiente configurado. Faça logout/login se o shell padrão tiver sido alterado."
}

main
