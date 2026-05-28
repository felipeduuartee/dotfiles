# dotfiles

Dotfiles e bootstrap para Ubuntu 26.04.

## Uso recomendado

```bash
git clone https://github.com/felipeduuartee/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

O instalador faz backup automático de `~/.zshrc` e `~/.gitconfig` se eles existirem e não forem symlinks gerenciados pelo repositório.

## Opções

Instalação padrão:

```bash
./install.sh
```

Instalar também ferramentas de segurança/pentest:

```bash
./install.sh --security
```

Instalar também linguagens/ferramentas extras:

```bash
./install.sh --languages
```

Instalar também alguns snaps opcionais:

```bash
./install.sh --snaps
```

Tudo junto:

```bash
./install.sh --security --languages --snaps
```

## Observações

- Não use `curl | bash`: este repositório depende de arquivos locais em `scripts/` e `pkgs/`.
- Flatpak/Stremio não são instalados por este script.
- Chaves SSH não são copiadas por segurança.
