#!/bin/bash

echo "🛠️ Instalando pacotes básicos..."
sudo apt update && sudo apt install -y \
    git \
    curl \
    stow \
    nano \
    htop \
    bat \
    fzf \
    ripgrep \
    python3 \
    python3-pip \
    build-essential

echo "✅ Pacotes instalados."

echo "📁 Clonando dotfiles (caso não tenha feito)..."
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/felipeduuartee/dotfiles.git ~/dotfiles
fi

cd ~/dotfiles || exit

echo "🔗 Criando links simbólicos com stow..."

stow bash
stow git

echo "✅ Dotfiles aplicados com sucesso!"
