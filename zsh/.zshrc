# Caminho do Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Tema desativado para usar PROMPT personalizado
ZSH_THEME=""

# PROMPT igual ao do Bash, com branch Git e título da janela
autoload -Uz vcs_info
precmd() {
  vcs_info
  print -Pn "\e]0;%n@%m: %~\a"
}
setopt prompt_subst
PROMPT='${debian_chroot:+($debian_chroot)}%F{green}%B%n@%m%b%f:%F{blue}%~%f %F{yellow}${vcs_info_msg_0_}%f$ '
zstyle ':vcs_info:git:*' formats '(%b)'

# Plugins ativados
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Carregar Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ---- ALIASES E CONFIGS COPIADAS DO BASH ----

# Histórico
HISTSIZE=1000
HISTFILESIZE=2000

# Evita linhas duplicadas no histórico
setopt HIST_IGNORE_ALL_DUPS

# LS com cores
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# Aliases úteis
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias dinf='ssh fds23@macalan.c3sl.ufpr.br'
alias py='python3'
alias myenv='source myenv/bin/activate'
alias compactar='tar -czf'

# Alerta para comandos demorados
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Adiciona binários locais ao PATH
export PATH="$PATH:$HOME/.local/bin"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# ---- ALIAS GIT ----
alias gs='git status'
alias ga='git add .'
alias gaa='git add -A'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gl='git pull'
alias gp='git push'
alias gpo='git push origin'
alias gr='git remote -v'
alias grm='git rebase main'
alias grs='git reset --soft HEAD~1'
alias grh='git reset --hard HEAD'
alias gcl='git clone'
alias gstash='git stash'
alias gpop='git stash pop'
alias gdf='git diff'

# ---- FUNÇÕES GIT ----

# Cria um novo branch e faz push imediatamente
gnew() {
  git checkout -b "$1" && git push -u origin "$1"
}


# =========== pyenv ===========


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
